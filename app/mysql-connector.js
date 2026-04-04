// const mysql = require('mysql');

// var pool = mysql.createPool({
//   connectionLimit: 5,
//   host: 'remotemysql.com',
//   user: 'qpprF0nLD8',
//   password: 'a5uhzM6Rcl',
//   database: 'qpprF0nLD8'
// });


 
function initializeSqlConfig(dbDetails){
  try {
    console.log('=== Initialize SQL Config ===');
    console.log('dbDetails received:', dbDetails);
    console.log('dbDetails.database:', dbDetails.database);
   
   const sqlConfig = {
  user: 'accubridge_login',
  password: 'StrongP@ssw0rd!',
  database: 'weighbridge',
  server: 'localhost',
  options: {
    encrypt: false,
    trustServerCertificate: true,
    instanceName: 'SQLEXPRESS'
  }
};
    console.log('=== Final SQL Config ===');
    console.log('User:', sqlConfig['user']);
    console.log('Password:', sqlConfig['password'] ? '***' : 'undefined');
    console.log('Database:', sqlConfig['database']);
    console.log('Server:', sqlConfig['server']);
    console.log('Port:', sqlConfig['port']);
    console.log('========================');
   
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