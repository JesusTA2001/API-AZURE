const mysql = require('mysql2/promise');
require('dotenv').config();

// ============================================
// CONEXIÓN LOCAL (COMENTADA)
// ============================================
// const pool = mysql.createPool({
//   host: process.env.DB_HOST || 'localhost',
//   user: process.env.DB_USER || 'root',
//   password: process.env.DB_PASSWORD || 'root',
//   database: process.env.DB_NAME || 'proyectoingles',
//   port: process.env.DB_PORT || 3306,
//   waitForConnections: true,
//   connectionLimit: 10,
//   queueLimit: 0
// });

// ============================================
// CONEXIÓN AZURE (ACTIVA)
// ============================================
const pool = mysql.createPool({
  host: process.env.DB_HOST || 'mysqlingles.mysql.database.azure.com',
  user: process.env.DB_USER || 'admin_ingles',
  password: process.env.DB_PASSWORD || 'Gui11ermo1',
  database: process.env.DB_NAME || 'proyectoIngles',
  port: process.env.DB_PORT || 3306,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
  ssl: {
    rejectUnauthorized: true
  }
});

// Función para probar la conexión
const testConnection = async () => {
  try {
    const connection = await pool.getConnection();
    console.log('✅ Conexión exitosa a MySQL Azure');
    console.log(`📊 Base de datos: ${process.env.DB_NAME || 'proyectoIngles'}`);
    console.log(`🔌 Host: ${process.env.DB_HOST || 'mysqlingles.mysql.database.azure.com'}:${process.env.DB_PORT || 3306}`);
    connection.release();
    return true;
  } catch (error) {
    console.error('❌ Error al conectar con MySQL Azure:', error.message);
    return false;
  }
};

module.exports = { pool, testConnection };
