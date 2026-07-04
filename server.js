const express = require('express');
const pool = require('./db');
const authController = require('./backend/authController');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());
app.use('/api/auth', authController);

app.get('/api/venues', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT id, name, type, location, price_per_hour FROM venues LIMIT 10');
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

app.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`);
});
