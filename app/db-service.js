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
  // Run data migrations to fix any existing incorrect data
  await runDataMigrations(pool);
}

async function runDataMigrations(pool) {
  var migrations = [
    "UPDATE search_field SET fieldName='supplier' WHERE id=1 AND (fieldName IS NULL OR fieldName != 'supplier')",
    "UPDATE search_field SET fieldName='material' WHERE id=2 AND (fieldName IS NULL OR fieldName != 'material')",
    "UPDATE search_field SET fieldName='transporter' WHERE id=3 AND (fieldName IS NULL OR fieldName != 'transporter')",
    "UPDATE search_field SET fieldName='customer' WHERE id=4 AND (fieldName IS NULL OR fieldName != 'customer')"
  ];
  // Add missing columns to weighment table
  var columnMigrations = [
    "IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[weighment]') AND name = 'containerNo') ALTER TABLE [dbo].[weighment] ADD [containerNo] [varchar](100) NULL",
    "IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[weighment]') AND name = 'licenseNo') ALTER TABLE [dbo].[weighment] ADD [licenseNo] [varchar](100) NULL",
    "IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[weighment]') AND name = 'driverName') ALTER TABLE [dbo].[weighment] ADD [driverName] [varchar](150) NULL",
    "IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[weighment]') AND name = 'pucNo') ALTER TABLE [dbo].[weighment] ADD [pucNo] [varchar](100) NULL",
    "IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[weighment]') AND name = 'invoiceNo') ALTER TABLE [dbo].[weighment] ADD [invoiceNo] [varchar](200) NULL",
    "IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[weighment]') AND name = 'lrNo') ALTER TABLE [dbo].[weighment] ADD [lrNo] [varchar](200) NULL"
  ];
  // Fix template_detail: ensure invoiceNo and lrNo ticket fields exist
  var templateMigrations = [
    "IF NOT EXISTS (SELECT 1 FROM template_detail WHERE id=40) INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (40, 1, 'invoiceNo', 'ticket-field', 'Invoice No', 4, 40, 1, 'R')",
    "IF NOT EXISTS (SELECT 1 FROM template_detail WHERE id=41) INSERT INTO template_detail (id, templateId, field, [type], displayName, [row], col, isIncluded, font) VALUES (41, 1, 'lrNo', 'ticket-field', 'LR No', 7, 40, 1, 'R')",
    "UPDATE template_detail SET displayName='CG POWER & INDUSTRIAL SOLUTION LTD,M6,STAMPING DIVISION,', col=15 WHERE id=22 AND displayName != 'CG POWER & INDUSTRIAL SOLUTION LTD,M6,STAMPING DIVISION,'",
    "UPDATE template_detail SET displayName='B-110,B-111/B,B112/2,NAGAPUR MIDC,AHILYANAGAR-414111', col=15 WHERE id=23 AND displayName != 'B-110,B-111/B,B112/2,NAGAPUR MIDC,AHILYANAGAR-414111'"
  ];
  // Strip legacy "CODE-" prefix from supplier/material/customer in weighment_detail
  var dataMigrations = [
    "UPDATE weighment_detail SET supplier = SUBSTRING(supplier, CHARINDEX('-', supplier) + 1, LEN(supplier)) WHERE supplier IS NOT NULL AND CHARINDEX('-', supplier) > 0 AND LEFT(supplier, CHARINDEX('-', supplier) - 1) NOT LIKE '%[^0-9]%'",
    "UPDATE weighment_detail SET material = SUBSTRING(material, CHARINDEX('-', material) + 1, LEN(material)) WHERE material IS NOT NULL AND CHARINDEX('-', material) > 0 AND LEFT(material, CHARINDEX('-', material) - 1) NOT LIKE '%[^0-9]%'",
    "UPDATE weighment_detail SET customer = SUBSTRING(customer, CHARINDEX('-', customer) + 1, LEN(customer)) WHERE customer IS NOT NULL AND CHARINDEX('-', customer) > 0 AND LEFT(customer, CHARINDEX('-', customer) - 1) NOT LIKE '%[^0-9]%'"
  ];
  for (var stmt of migrations.concat(columnMigrations).concat(templateMigrations).concat(dataMigrations)) {
    try {
      await pool.query(stmt);
    } catch (err) {
      log.error(err);
    }
  }
}

async function seedMissingTemplateData(pool) {
  try {
    var result = await pool.query("SELECT COUNT(*) as cnt FROM ticket_template");
    if (result.recordset[0].cnt === 0) {
      console.log('Seeding ticket_template and template_detail...');
      var data = require("./bootstrap.js");
      // Insert ticket_template
      for (var obj of data.seed.ticket_template) {
        var stmt = data.sqlStmt.ticket_template;
        for (var k of Object.keys(obj)) {
          stmt = stmt.replace("{" + k + "}", obj[k]);
        }
        stmt = stmt.replace(/'null'/g, "null");
        try { await pool.query(stmt); } catch (e) { log.error(e); }
      }
      // Insert template_detail
      for (var obj of data.seed.template_detail) {
        var stmt = data.sqlStmt.template_detail;
        for (var k of Object.keys(obj)) {
          stmt = stmt.replace("{" + k + "}", obj[k]);
        }
        stmt = stmt.replace(/'null'/g, "null");
        try { await pool.query(stmt); } catch (e) { log.error(e); }
      }
      console.log('Template seeding complete.');
    }
  } catch (err) {
    log.error(err);
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
    // Auto-fix: run migrations and seed missing data on every startup
    await runDataMigrations(pool);
    await seedMissingTemplateData(pool);
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
