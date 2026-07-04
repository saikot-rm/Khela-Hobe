const dotenv = require('dotenv');
const mysql = require('mysql2/promise');

dotenv.config();

const pool = mysql.createPool({
  host: process.env.DB_HOST || '127.0.0.1',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'khelahobe',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
});

async function testConnection() {
  try {
    const connection = await pool.getConnection();
    await connection.ping();
    connection.release();
    console.log('✅ Database connection successful.');
  } catch (error) {
    console.error('❌ Database connection failed:', error.message);
  }
}

testConnection();

module.exports = pool;
