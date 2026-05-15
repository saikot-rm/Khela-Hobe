# KhelaHobe! Backend API - Setup Guide

## 📋 Project Structure

```
Khela-Hobe/
├── config/
│   └── database.js          # MySQL connection pool
├── middleware/
│   ├── auth.js              # JWT authentication & role checks
│   └── errorHandler.js      # Global error handling
├── routes/
│   ├── auth.js              # Registration, login, profile
│   ├── bookings.js          # Venue booking CRUD operations
│   └── investments.js       # Investment project management
├── server.js                # Main Express server
├── package.json             # Dependencies
├── .env.example             # Environment variables template
├── khelahobe_schema.sql     # MySQL database schema
└── README.md                # This file
```

## 🚀 Quick Start

### 1. Install Dependencies

```bash
npm install
```

### 2. Set Up Environment Variables

Copy `.env.example` to `.env` and update with your database credentials:

```bash
cp .env.example .env
```

Edit `.env` with your settings:
```
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=khelahobe
JWT_SECRET=your_secret_key_here
PORT=5000
```

### 3. Import Database Schema

```bash
mysql -u root -p < khelahobe_schema.sql
```

Or manually in MySQL:
```sql
SOURCE khelahobe_schema.sql;
```

### 4. Start the Server

**Development (with auto-reload):**
```bash
npm run dev
```

**Production:**
```bash
npm start
```

Server will start at `http://localhost:5000`

## 📚 API Documentation

### Authentication Endpoints

#### Register User
```bash
POST /api/auth/register
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "phone": "+91-9876543210",
  "role": "Player"  # Admin, Player, Landowner, or Investor
}
```

#### Login
```bash
POST /api/auth/login
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "password123"
}

Response:
{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "role": "Player"
  }
}
```

#### Get User Profile
```bash
GET /api/auth/profile
Authorization: Bearer {token}
```

### Booking Endpoints

#### Get All Venue Bookings
```bash
GET /api/bookings/venue/:venueId
Authorization: Bearer {token}
```

#### Get My Bookings
```bash
GET /api/bookings/my-bookings
Authorization: Bearer {token}
(Requires Player role)
```

#### Create Booking
```bash
POST /api/bookings
Authorization: Bearer {token}
Content-Type: application/json

{
  "venue_id": 1,
  "booking_date": "2026-06-15",
  "start_time": "09:00:00",
  "end_time": "11:00:00",
  "notes": "Evening game"
}
```

#### Update Booking Status
```bash
PATCH /api/bookings/:bookingId/status
Authorization: Bearer {token}
Content-Type: application/json

{
  "status": "confirmed"  # pending, confirmed, cancelled, completed
}
```

#### Delete Booking
```bash
DELETE /api/bookings/:bookingId
Authorization: Bearer {token}
```

### Investment Endpoints

#### Get All Active Projects
```bash
GET /api/investments/projects
```

#### Get Project Details
```bash
GET /api/investments/projects/:projectId
```

#### Get My Investments
```bash
GET /api/investments/my-investments
Authorization: Bearer {token}
(Requires Investor role)
```

#### Create Investment
```bash
POST /api/investments
Authorization: Bearer {token}
Content-Type: application/json

{
  "project_id": 1,
  "amount": 50000
}
```

#### Get Project Funding Progress
```bash
GET /api/investments/projects/:projectId/progress
```

## 🔐 Authentication

All protected endpoints require JWT token in the Authorization header:

```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

Token is valid for 7 days (configurable via `JWT_EXPIRE` in .env)

## 👥 User Roles

- **Admin**: Full system access
- **Player**: Can book venues and leave reviews
- **Landowner**: Can create venues and investment projects
- **Investor**: Can invest in projects

## 📦 Dependencies

- **express**: Web framework
- **mysql2/promise**: MySQL database driver (promise-based)
- **jsonwebtoken**: JWT authentication
- **bcryptjs**: Password hashing
- **cors**: Cross-origin resource sharing
- **dotenv**: Environment variable management
- **validator**: Input validation
- **nodemon**: Development auto-reload (dev only)

## ⚠️ Error Handling

All errors follow this format:

```json
{
  "success": false,
  "message": "Error description"
}
```

Common error codes:
- **400**: Bad request (validation error)
- **401**: Unauthorized (missing/invalid token)
- **403**: Forbidden (insufficient permissions)
- **404**: Not found
- **409**: Conflict (duplicate entry)
- **500**: Server error

## 🧪 Testing with cURL

### Register
```bash
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "password": "password123",
    "phone": "+91-9999999999",
    "role": "Player"
  }'
```

### Login
```bash
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

### Create Booking (with token)
```bash
curl -X POST http://localhost:5000/api/bookings \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -d '{
    "venue_id": 1,
    "booking_date": "2026-06-15",
    "start_time": "09:00:00",
    "end_time": "11:00:00"
  }'
```

## 📝 Environment Variables Reference

| Variable | Description | Default |
|----------|-------------|---------|
| `DB_HOST` | MySQL server host | localhost |
| `DB_PORT` | MySQL server port | 3306 |
| `DB_USER` | MySQL username | root |
| `DB_PASSWORD` | MySQL password | (empty) |
| `DB_NAME` | Database name | khelahobe |
| `PORT` | Server port | 5000 |
| `NODE_ENV` | Environment | development |
| `JWT_SECRET` | JWT signing key | (required) |
| `JWT_EXPIRE` | Token expiration | 7d |
| `API_URL` | CORS origin | http://localhost:5000 |

## 🐛 Troubleshooting

### Database connection fails
- Ensure MySQL is running
- Check DB credentials in .env
- Verify database exists: `mysql -u root -p -e "USE khelahobe;"`

### Port already in use
- Change PORT in .env or: `PORT=5001 npm start`

### CORS errors
- Update `API_URL` in .env to match your frontend URL

### JWT errors
- Ensure JWT_SECRET is set and consistent
- Check token format: `Authorization: Bearer {token}`

## 📚 Next Steps

1. Set up frontend (React/Vue/Angular)
2. Integrate with payment gateway for transactions
3. Add email notifications
4. Implement file uploads for venue images
5. Add admin dashboard
6. Deploy to production (AWS, Heroku, etc.)

---

**Created**: 2026-05-16  
**Version**: 1.0.0
