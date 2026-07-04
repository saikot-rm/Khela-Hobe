const express = require('express');
const cors = require('cors');
const mysql = require('mysql');

const app = express();
const PORT = 5000;

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'khelahobe',
});

db.connect((err) => {
  if (err) {
    console.error('❌ MySQL connection failed:', err.message);
    process.exit(1);
  }
  console.log('✅ Connected to MySQL database khelahobe');
});

app.use(cors());
app.use(express.json());

app.get('/api/venues', (req, res) => {
  const sql = 'SELECT * FROM venues ORDER BY id DESC';
  db.query(sql, (err, results) => {
    if (err) {
      return res.status(500).json({ success: false, message: 'Unable to fetch venues', error: err.message });
    }
    res.json(results);
  });
});

app.post('/api/venues', (req, res) => {
  const { landowner_id, title, description, address, hourly_rate, image_url, map_link } = req.body;

  if (!title || !address || !hourly_rate || !image_url || !map_link) {
    return res.status(400).json({
      success: false,
      message: 'Missing required fields. Please provide title, address, hourly_rate, image_url and map_link.',
    });
  }

  const sql = `INSERT INTO venues (landowner_id, title, description, address, hourly_rate, image_url, map_link)
    VALUES (?, ?, ?, ?, ?, ?, ?)`;
  const values = [landowner_id || 1, title, description || '', address, hourly_rate, image_url, map_link];

  db.query(sql, values, (err, result) => {
    if (err) {
      return res.status(500).json({ success: false, message: 'Unable to create venue', error: err.message });
    }
    res.status(201).json({
      success: true,
      message: 'Venue created successfully',
      venue: { id: result.insertId, landowner_id: landowner_id || 1, title, description, address, hourly_rate, image_url, map_link },
    });
  });
});

app.put('/api/venues/:id', (req, res) => {
  const id = Number(req.params.id);
  const { landowner_id, title, description, address, hourly_rate, image_url, map_link } = req.body;

  const fields = { landowner_id, title, description, address, hourly_rate, image_url, map_link };
  const updates = Object.entries(fields)
    .filter(([, value]) => value !== undefined && value !== null)
    .map(([key]) => `${key} = ?`);

  if (!updates.length) {
    return res.status(400).json({ success: false, message: 'No fields provided to update.' });
  }

  const values = Object.entries(fields)
    .filter(([, value]) => value !== undefined && value !== null)
    .map(([, value]) => value);

  const sql = `UPDATE venues SET ${updates.join(', ')} WHERE id = ?`;
  values.push(id);

  db.query(sql, values, (err, result) => {
    if (err) {
      return res.status(500).json({ success: false, message: 'Unable to update venue', error: err.message });
    }
    if (result.affectedRows === 0) {
      return res.status(404).json({ success: false, message: 'Venue not found' });
    }
    res.json({ success: true, message: 'Venue updated successfully' });
  });
});

app.delete('/api/venues/:id', (req, res) => {
  const id = Number(req.params.id);
  const sql = 'DELETE FROM venues WHERE id = ?';

  db.query(sql, [id], (err, result) => {
    if (err) {
      return res.status(500).json({ success: false, message: 'Unable to delete venue', error: err.message });
    }
    if (result.affectedRows === 0) {
      return res.status(404).json({ success: false, message: 'Venue not found' });
    }
    res.json({ success: true, message: 'Venue deleted successfully' });
  });
});

app.use((req, res) => {
  res.status(404).json({ success: false, message: 'Route not found' });
});

app.listen(PORT, () => {
  console.log(`KhelaHobe server is running on http://localhost:${PORT}`);
});
