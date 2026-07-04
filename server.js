const express = require('express');
const cors = require('cors');
const pool = require('./db');
const authController = require('./backend/authController');

const express = require('express');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());
app.use('/api/auth', authController);

app.get('/api/venues', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT id, title AS name, type, location, price_per_hour FROM venues ORDER BY id DESC LIMIT 10');
    if (rows && rows.length > 0) {
      return res.json(rows);
    }
  } catch (error) {
    console.warn('Falling back to sample venues:', error.message);
  }

  return res.json([
    {
      id: 1,
      title: 'Arena One Turf',
      location_type: 'turf',
      hourly_price: 1200,
      location: 'Dhaka',
    },
    {
      id: 2,
      title: 'City Sports Club',
      location_type: 'indoor',
      hourly_price: 900,
      location: 'Chattogram',
    },
    {
      id: 3,
      title: 'Green Field Pitch',
      location_type: 'turf',
      hourly_price: 1500,
      location: 'Sylhet',
    },
  ]);
});

app.post('/api/venues', async (req, res) => {
  const { landowner_id, title, description, address, hourly_rate, image_url, map_link } = req.body;

  if (!title || !address || hourly_rate == null) {
    return res.status(400).json({
      success: false,
      message: 'Missing required fields. Please provide title, address and hourly_rate.',
    });
  }

  try {
    const [result] = await pool.query(
      `INSERT INTO venues (landowner_id, title, description, address, hourly_rate, image_url, map_link)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [landowner_id || 1, title, description || '', address, hourly_rate, image_url || '', map_link || '']
    );

    const insertId = result.insertId || (result && result.affectedRows ? result.insertId : null);
    return res.status(201).json({
      success: true,
      message: 'Venue created successfully',
      venue: { id: insertId, landowner_id: landowner_id || 1, title, description, address, hourly_rate, image_url, map_link },
    });
  } catch (err) {
    console.error('Create venue error:', err.message || err);
    return res.status(500).json({ success: false, message: 'Unable to create venue', error: err.message });
  }
});

app.put('/api/venues/:id', async (req, res) => {
  const { id } = req.params;
  const { hourly_rate, description } = req.body;

  if (hourly_rate == null && description == null) {
    return res.status(400).json({ error: 'At least one field is required.' });
  }

  try {
    const updates = [];
    const values = [];

    if (hourly_rate != null) {
      updates.push('price_per_hour = ?');
      values.push(hourly_rate);
    }

    if (description != null) {
      updates.push('description = ?');
      values.push(description);
    }

    values.push(id);

    const [result] = await pool.query(
      `UPDATE venues SET ${updates.join(', ')} WHERE id = ?`,
      values
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Venue not found.' });
    }

    return res.json({ success: true, message: 'Venue updated successfully.' });
  } catch (error) {
    console.error('Update venue error:', error);
    return res.status(500).json({ error: 'Unable to update venue.' });
  }
});

app.delete('/api/venues/:id', async (req, res) => {
  const { id } = req.params;

  try {
    const [result] = await pool.query('DELETE FROM venues WHERE id = ?', [id]);

    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Venue not found.' });
    }

    return res.json({ success: true, message: 'Venue deleted successfully.' });
  } catch (error) {
    console.error('Delete venue error:', error);
    return res.status(500).json({ error: 'Unable to delete venue.' });
  }
});

app.get('/', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT 1 AS ok');
    res.json({ status: 'ok', db: rows[0] });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.use((req, res) => {
  res.status(404).json({ success: false, message: 'Route not found' });
});

app.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`);
});
});
