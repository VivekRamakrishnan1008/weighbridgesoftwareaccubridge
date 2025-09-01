const { app, ipcMain } = require('electron');
const sql = require("mssql");
const fs = require('fs');
const bootstrapData = require("./bootstrap.js");
const log = require('electron-log');
log.transports.file.level = 'info';
log.transports.file.file = __dirname + '/db-log.log';

var sqlConfig = {
  pool: {
    max: 10,
    min: 0,
    idleTimeoutMillis: 30000
  },
  options: {
    encrypt: false, // for azure
    trustServerCertificate: true // change to true for local dev / self-signed certs
  },
  authentication:{
    type: 'default'
  }
};

try {
  var envPath = app.getPath('userData') + "\\" + bootstrapData.mConstants.appName + "\\" + bootstrapData.mConstants.envFilename;
  console.log('=== DB Service Debug ===');
  console.log('Trying to read env from:', envPath);
  
  var data = fs.readFileSync(envPath, 'utf-8');
  console.log('Env file data (first 200 chars):', data.substring(0, 200));
  
  log.debug("Environment file path:");
  log.debug(envPath);
  global.env_data = JSON.parse(data);
  
  console.log('Parsed env_data.database:', env_data.database);
  initializeSqlConfig(env_data);
} catch (e) {
  console.log('Failed to read from AppData, error:', e.message);
  // Try fallback location
  try {
    var fallbackPath = __dirname + "\\..\\env.json";
    console.log('Trying fallback location:', fallbackPath);
    var data2 = fs.readFileSync(fallbackPath, 'utf-8');
    console.log('Fallback env file data (first 200 chars):', data2.substring(0, 200));
    global.env_data = JSON.parse(data2);
    console.log('Parsed fallback env_data.database:', env_data.database);
    initializeSqlConfig(env_data);
  } catch (e2) {
    console.log('Fallback also failed:', e2.message);
    log.error(e);
    log.error(e2);
  }
}


function initializeSqlConfig(dbDetails){
  try {
    console.log('=== Initialize SQL Config ===');
    console.log('dbDetails received:', dbDetails);
    console.log('dbDetails.database:', dbDetails.database);
    
    sqlConfig['user'] = dbDetails['database']['username'];
    sqlConfig['password'] = dbDetails['database']['password'];
    sqlConfig['database'] = dbDetails['database']['database'];
sqlConfig['server'] =dbDetails['database']['server'];
sqlConfig['options'] = {
    encrypt: false,
    trustServerCertificate: true,

};
    sqlConfig['port'] = dbDetails['database']['port'];
    log.debug(`User - ${sqlConfig['user']}`);
    log.debug(`Password - ${sqlConfig['password']}`);
    log.debug(`Database - ${sqlConfig['database']}`);
    log.debug(`Server - ${sqlConfig['server']}`);
    log.debug(`Port - ${sqlConfig['port']}`);
    
    console.log('About to call loadEnvDataFromDB...');
    loadEnvDataFromDB();
  }
  catch (e) {
    console.log('Error in initializeSqlConfig:', e);
    log.error(e);
    return false;
  }
}

ipcMain.handle("initializeDBConfig", async (event, args) => {
  log.silly("Initialize SQL Configuration");
  initializeSqlConfig(args[0]);
});

ipcMain.on("executeDBQuery", (event, arg) => {
  log.silly(sqlConfig);
  log.silly(arg[1]);
  sql.connect(sqlConfig).then(pool => {
    return pool.query(arg[1]);
  }).then(results => {
    log.silly(results);
    event.sender.send("db-reply", [arg[0], results['recordset']]);
  }).catch(e=>{
    log.error(e);
  });
})

ipcMain.handle("executeSyncStmt", async (event, arg) => {
  try {
    var pool = await sql.connect(sqlConfig);
    var results = await pool.query(arg[1]);
  } catch (err) {
    log.error(err);
    return { error: err.message };
  }
  return processResult(arg[0], results);
});

ipcMain.handle("executeSyncInsertAutoId", async (event, arg) => {
  var pool = await sql.connect(sqlConfig);
  var getIdQuery = `SELECT max(${arg[1]}) as maxId FROM ${arg[0]}`;
  var result = await pool.query(getIdQuery);
  if (result['recordset'][0]['maxId'] === null) {
    var newId = 1;
  } else {
    var newId = result['recordset'][0]['maxId'] + 1;
  }
  var mQuery = arg[2].replace(`{${arg[1]}}`, newId);
  try {
    log.silly(mQuery);
    var results = await pool.query(mQuery);
  } catch (err) {
    log.error(err);
    return { "error": err };
  }
  return { affectedRows: processResult(arg[0], results), "newId": newId};
});

ipcMain.handle("createDataForInitialSetup", async (event, arg) => {
  try {
    initialDataSetup()
  } catch (err) {
    log.error(err);
  }
  return true;
});

ipcMain.handle("get-env-data", async (event, arg) => {
  return env_data;
})

async function initialDataSetup() {
  const data = require("./bootstrap.js");
  var pool = await sql.connect(sqlConfig);
  var keys = Object.keys(data.seed);
  for (var key of keys) {
    for (var obj of data.seed[key]) {
      var stmt = data['sqlStmt'][key]
      for (var sKey of Object.keys(obj)) {
        stmt = stmt.replace(`{${sKey}}`, obj[sKey])
      }
      try {
        await pool.query(stmt);
      } catch (err) {
        log.error(err);
      }      
    }
  }
}

function processResult(queryType, result){
  if (queryType === "INSERT" || queryType === "UPDATE" || queryType === "DELETE") {
    return result['rowsAffected'][0] > 0;
  } else {
    return result['recordset'];
  }
}

async function loadEnvDataFromDB() {
  console.log('=== Attempting Database Connection ===');
  console.log('Current sqlConfig:', {
    user: sqlConfig.user,
    server: sqlConfig.server,
    database: sqlConfig.database,
    port: sqlConfig.port,
    options: sqlConfig.options
  });
  
  try {
    console.log('Calling sql.connect...');
    var pool = await sql.connect(sqlConfig);
    console.log('Database connection successful!');
    
    var keys = Object.keys(bootstrapData.envStmts);
    for (var key of keys) {
      var stmt = bootstrapData['envStmts'][key]['stmt'];
      for (var replacementKey of bootstrapData['envStmts'][key]['replacementKeys']) {
        stmt = stmt.replace(`{${replacementKey}}`, env_data[replacementKey])
      }
      try {
        var result = await pool.query(stmt);
        env_data[key] = processResult("SELECT", result);
        if (bootstrapData['envStmts'][key]['isSingleRecord']) {
          env_data[key] = env_data[key][0];
        }
      } catch (err) {
        console.log('Error executing query for key:', key, err.message);
        log.error(err);
      }
    }
  } catch (err) {
    console.log('=== Database Connection Failed ===');
    console.log('Error:', err.message);
    console.log('Error code:', err.code);
    console.log('===================================');
    log.error(err);
  }
}

const stmtExecutor = async (stmtType, stmt) => {
  try {
    var pool = await sql.connect(sqlConfig);
    var results = await pool.query(stmt);
  } catch (err) {
    log.error(err);
    return { error: err.message };
  }
  return processResult(stmtType, results);
}

exports.stmtExecutor = stmtExecutor;
