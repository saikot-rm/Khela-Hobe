const express = require('express');
const cors = require('cors');
require('dotenv').config();

// Import middleware
const errorHandler = require('./middleware/errorHandler');

// Import routes
const authRoutes = require('./routes/auth');
const bookingsRoutes = require('./routes/bookings');
const investmentsRoutes = require('./routes/investments');

// Initialize Express app
const app = express();
const PORT = process.env.PORT || 5000;

// ============================================================================
// MIDDLEWARE
// ============================================================================

// CORS setup
app.use(cors({
  origin: process.env.API_URL || 'http://localhost:3000',
  credentials: true
}));

// Body parser middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Request logging middleware
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.path}`);
  next();
});

// ============================================================================
// ROUTES
// ============================================================================

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({
    success: true,
    message: 'KhelaHobe API is running',
    timestamp: new Date().toISOString()
  });
});

// API endpoints
app.use('/api/auth', authRoutes);
app.use('/api/bookings', bookingsRoutes);
app.use('/api/investments', investmentsRoutes);

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: 'Route not found'
  });
});

// ============================================================================
// ERROR HANDLING
// ============================================================================

// Global error handler
app.use(errorHandler);

// ============================================================================
// START SERVER
// ============================================================================

app.listen(PORT, () => {
  console.log(`
╔════════════════════════════════════════════════════════════╗
║                                                            ║
║          🏟️  KhelaHobe API Server Started! 🏟️            ║
║                                                            ║
║         Server: http://localhost:${PORT}                     ║
║         Environment: ${process.env.NODE_ENV || 'development'}                    ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝
  `);
  console.log('📝 API Endpoints:');
  console.log('   POST   /api/auth/register');
  console.log('   POST   /api/auth/login');
  console.log('   GET    /api/auth/profile');
  console.log('   GET    /api/bookings/venue/:venueId');
  console.log('   GET    /api/bookings/my-bookings');
  console.log('   POST   /api/bookings');
  console.log('   PATCH  /api/bookings/:bookingId/status');
  console.log('   DELETE /api/bookings/:bookingId');
  console.log('   GET    /api/investments/projects');
  console.log('   GET    /api/investments/projects/:projectId');
  console.log('   GET    /api/investments/my-investments');
  console.log('   POST   /api/investments');
  console.log('   GET    /api/investments/projects/:projectId/progress');
});

// Graceful shutdown
process.on('SIGINT', () => {
  console.log('\n👋 Server shutting down gracefully...');
  process.exit(0);
});
