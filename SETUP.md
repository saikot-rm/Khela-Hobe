# SETUP INSTRUCTIONS FOR KHELAHOBE BACKEND

## Step 1: Create Directory Structure

Run this command to create the required directories:

```bash
node initialize-project.js
```

Or manually create these folders:
- `config/`
- `middleware/`
- `routes/`

## Step 2: Copy Routes and Middleware Files

After running the setup script, copy the following files:

### Routes
The following route files need to be created in the `routes/` folder:
- `auth.js` - Authentication endpoints
- `bookings.js` - Booking management
- `investments.js` - Investment operations

### Middleware
The following middleware files need to be created in the `middleware/` folder:
- `errorHandler.js` - Global error handling
- `auth.js` - JWT and role verification

### Config
Create in the `config/` folder:
- `database.js` - MySQL connection pool

## Step 3: Install Dependencies

```bash
npm install
```

This will install:
- express
- mysql2
- dotenv
- jsonwebtoken
- bcryptjs
- cors
- validator
- nodemon (dev)

## Step 4: Import Database Schema

```bash
mysql -u root -p < khelahobe_schema.sql
```

When prompted, enter your MySQL password.

Or use MySQL client:
```sql
mysql> SOURCE /path/to/khelahobe_schema.sql;
```

## Step 5: Configure Environment Variables

Edit `.env` file with your database credentials:

```
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_actual_password
DB_NAME=khelahobe
JWT_SECRET=your_secret_key
PORT=5000
```

## Step 6: Start the Server

### Development Mode (with auto-reload)
```bash
npm run dev
```

### Production Mode
```bash
npm start
```

## Expected Output

```
╔════════════════════════════════════════════════════════════╗
║                                                            ║
║          🏟️  KhelaHobe API Server Started! 🏟️            ║
║                                                            ║
║         Server: http://localhost:5000                      ║
║         Environment: development                           ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝
  
📝 API Endpoints:
   POST   /api/auth/register
   POST   /api/auth/login
   GET    /api/auth/profile
   ...
```

## Quick Test

### 1. Check Server Health
```bash
curl http://localhost:5000/health
```

### 2. Register a Test User
```bash
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test Player",
    "email": "player@test.com",
    "password": "test123456",
    "phone": "+91-9999999999",
    "role": "Player"
  }'
```

### 3. Login
```bash
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "player@test.com",
    "password": "test123456"
  }'
```

## Troubleshooting

### Connection Refused
- MySQL is not running
- Start MySQL: `mysqld` or `sudo systemctl start mysql`

### Database Not Found
- Run schema import: `mysql -u root -p < khelahobe_schema.sql`

### Port Already in Use
- Change PORT in .env or kill process on port 5000

### Dependency Issues
- Delete `node_modules/` and `package-lock.json`
- Run `npm install` again

## File Locations

| File | Purpose |
|------|---------|
| `server.js` | Main Express app |
| `config/database.js` | MySQL connection |
| `middleware/auth.js` | JWT verification |
| `middleware/errorHandler.js` | Error handling |
| `routes/auth.js` | Auth endpoints |
| `routes/bookings.js` | Booking endpoints |
| `routes/investments.js` | Investment endpoints |
| `.env` | Configuration |
| `khelahobe_schema.sql` | Database schema |

## Next: Frontend Integration

Once the backend is running, you can:
1. Set up React/Vue frontend
2. Configure frontend API URL to `http://localhost:5000`
3. Test API endpoints with Postman or cURL

---
Last Updated: 2026-05-16
