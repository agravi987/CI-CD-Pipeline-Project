const { Pool } = require('pg');
require('dotenv').config();

// Create a PostgreSQL connection pool using environment variables
const pool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '5432', 10),
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD || 'postgrespassword',
  database: process.env.DB_NAME || 'devops_db',
  // Connection timeout in milliseconds
  connectionTimeoutMillis: 5000,
});

pool.on('connect', () => {
  console.log(' Connected to PostgreSQL database pool');
});

pool.on('error', (err) => {
  console.error(' Unexpected PostgreSQL client error:', err.message);
});

module.exports = pool;
