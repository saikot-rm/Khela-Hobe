# 🎯 KhelaHobe Complete Setup Guide (3-Part Implementation)

## ✅ What You've Created

You now have a **complete, integrated platform** for KhelaHobe! - a sports venue and investment platform. Here's what's been delivered:

---

## 📊 Part 1: MySQL Database ✓

**File**: `khelahobe_schema.sql`

### What It Does:
- Creates 11 interconnected MySQL tables
- Supports 4 user roles: Admin, Player, Landowner, Investor
- Tracks venues, bookings, investments, transactions, reviews

### Key Tables:
```
users → venues ↔ investment_projects → investments
         ↓
      bookings
         ↓
      wallets → transactions
         ↓
      reviews
```

### To Import:
```bash
mysql -u root -p < khelahobe_schema.sql
```

---

## 🔌 Part 2: Node.js Express Backend ✓

**File**: `server.js`

### API Endpoints:

#### Authentication (`/api/auth`)
- `POST /register` - Create new user account
- `POST /login` - Login & get JWT token
- `GET /profile` - Get current user profile

#### Bookings (`/api/bookings`)
- `GET /venue/:venueId` - View venue bookings
- `GET /my-bookings` - Get user's bookings
- `POST /` - Create new booking
- `PATCH /:bookingId/status` - Update booking status
- `DELETE /:bookingId` - Cancel booking

#### Investments (`/api/investments`)
- `GET /projects` - List all funding projects
- `GET /projects/:projectId` - Get project details
- `GET /my-investments` - Get user's investments
- `POST /` - Create new investment
- `GET /projects/:projectId/progress` - Funding progress

### To Run:
```bash
npm install
npm start          # Production
npm run dev        # Development (auto-reload)
```

Server runs on: `http://localhost:5000`

---

## 📱 Part 3: Flutter Frontend ✓

**Files**: All `.dart` files in root directory

### Architecture:

```
RoleRouter
├── Checks SharedPreferences for user role
└── Routes to appropriate dashboard:
    ├── PlayerDashboard (Green)
    │   ├── Browse Venues
    │   ├── My Bookings
    │   └── Booking History
    ├── LandownerDashboard (Orange)
    │   ├── Property Performance (Revenue, Stats)
    │   └── Construction Updates
    └── InvestorDashboard (Deep Purple)
        ├── Wallet Balance (₹245,000)
        ├── ROI Performance Chart
        ├── Active Investments
        └── Available Opportunities
```

### Key Features:

✅ **JWT Authentication** - Secure token-based login  
✅ **Role-Based Routing** - Different UIs per role  
✅ **Demo Accounts** - Test instantly without credentials  
✅ **State Management** - Provider for global auth state  
✅ **LocalStorage** - SharedPreferences for persistence  
✅ **Beautiful UI** - Material Design 3 with gradients  

---

## 🚀 Complete Setup Roadmap

### Step 1: Database Setup (5 minutes)

```bash
# Import schema
mysql -u root -p < khelahobe_schema.sql

# Verify tables exist
mysql> USE khelahobe;
mysql> SHOW TABLES;
```

✅ **Verification**: You should see 11 tables

---

### Step 2: Backend Setup (10 minutes)

```bash
# Install dependencies
npm install

# Update .env with your database password
# (Already created with defaults)

# Start server
npm start

# Test health endpoint
curl http://localhost:5000/health
```

✅ **Verification**: 
- Server starts without errors
- Port 5000 is accessible
- Database connects successfully

---

### Step 3: Flutter App Setup (15 minutes)

```bash
# Create new Flutter project
flutter create khelahobe_mobile
cd khelahobe_mobile

# Copy all .dart files to lib/ folder structure:
# ├── lib/
# │   ├── main.dart (from flutter_main.dart)
# │   ├── widgets/
# │   │   └── role_router.dart
# │   ├── screens/
# │   │   ├── auth/
# │   │   │   └── login_screen.dart
# │   │   └── dashboards/
# │   │       ├── player_dashboard.dart
# │   │       ├── landowner_dashboard.dart
# │   │       └── investor_dashboard.dart
# │   └── providers/
# │       └── auth_provider.dart

# Update pubspec.yaml with provided dependencies

# Get dependencies
flutter pub get

# Run app
flutter run
```

✅ **Verification**:
- App launches without errors
- Demo buttons work (instant login)
- Role-based dashboards display

---

## 🧪 Testing Checklist

### Test #1: Database Connectivity
```bash
# From Node.js backend directory
node -e "require('./config/database.js')"
# Expected: ✓ Database connected successfully
```

### Test #2: Backend API
```bash
# Health check
curl http://localhost:5000/health

# Test registration
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "password": "test123456",
    "phone": "+91-9999999999",
    "role": "Player"
  }'

# Test login
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "test123456"
  }'
```

### Test #3: Flutter Role Routing

1. **Launch app**: `flutter run`
2. **Click "Player" demo button** → Green dashboard with venue browsing
3. **Logout** → Return to login
4. **Click "Landowner" demo button** → Orange dashboard with tabs
5. **Logout** → Return to login
6. **Click "Investor" demo button** → Purple dashboard with wallet & ROI chart

---

## 📂 Project File Structure

```
Khela-Hobe/
├── Database
│   └── khelahobe_schema.sql           (MySQL schema)
├── Backend
│   ├── server.js                      (Express app)
│   ├── package.json                   (Dependencies)
│   ├── .env                           (Configuration)
│   ├── config/
│   │   └── database.js               (MySQL connection)
│   ├── middleware/
│   │   ├── auth.js                   (JWT verification)
│   │   └── errorHandler.js           (Error handling)
│   └── routes/
│       ├── auth.js                   (Login/Register)
│       ├── bookings.js               (Booking CRUD)
│       └── investments.js            (Investment management)
├── Frontend (Flutter)
│   ├── role_router.dart              (Main router)
│   ├── player_dashboard.dart         (Player UI)
│   ├── landowner_dashboard.dart      (Landowner UI)
│   ├── investor_dashboard.dart       (Investor UI)
│   ├── login_screen.dart             (Login & demo)
│   ├── auth_provider.dart            (State management)
│   └── flutter_main.dart             (App entry point)
└── Documentation
    ├── README.md                      (Main readme)
    ├── SETUP.md                       (Backend setup)
    ├── FLUTTER_SETUP.md              (Flutter setup)
    └── COMPLETE_SETUP.md             (This file)
```

---

## 🎯 Hitting the 20% Mark

You have now completed the **core architecture** of KhelaHobe:

✅ **Step 1**: MySQL script created & ready to import  
✅ **Step 2**: Node.js backend with working API endpoints  
✅ **Step 3**: Flutter role-based router with 3 dashboards  

### What Works:
- Different UI for each user role (Player/Landowner/Investor)
- Login & authentication system
- JWT tokens with role validation
- Demo accounts for instant testing
- Beautiful, modern Material Design 3 interface

### What's Next (Beyond 20%):
- Real API integration for bookings & investments
- Payment gateway integration (Razorpay/Stripe)
- Image uploads for venues
- Real-time notifications
- Advanced charts & analytics
- Admin dashboard

---

## 🔧 Common Commands Reference

### Database
```bash
mysql -u root -p < khelahobe_schema.sql    # Import schema
mysql -u root -p khelahobe                 # Connect to DB
SHOW TABLES;                               # View tables
DESC users;                                # View table structure
```

### Backend
```bash
npm install                                # Install packages
npm start                                  # Production server
npm run dev                                # Dev with auto-reload
npm test                                   # Run tests
```

### Frontend
```bash
flutter create khelahobe_mobile           # New project
flutter pub get                           # Install dependencies
flutter run                               # Run app
flutter run -v                            # Verbose logging
flutter clean                             # Clean build
flutter build apk                         # Build Android
flutter build ios                         # Build iOS
```

---

## 📞 Quick Troubleshooting

### Backend won't start
```bash
# Check if port 5000 is in use
# Solution: Change PORT in .env or kill process on 5000

# Check database connection
npm install                # Reinstall packages
mysql -u root -p          # Test MySQL access
```

### Flutter app won't compile
```bash
# Full clean rebuild
flutter clean
flutter pub get
flutter run

# Check Flutter doctor
flutter doctor
```

### Database tables not created
```bash
# Verify import worked
mysql> USE khelahobe;
mysql> SELECT COUNT(*) FROM users;

# If error, reimport schema
mysql -u root -p < khelahobe_schema.sql
```

---

## 🎓 Learning Resources

- **Flutter Docs**: https://flutter.dev/docs
- **Express.js Guide**: https://expressjs.com/
- **MySQL Documentation**: https://dev.mysql.com/doc/
- **JWT Auth**: https://jwt.io/

---

## ✨ Summary

You now have:

🏗️ **Robust MySQL Database** - 11 tables with proper relationships  
🔌 **Scalable Node.js API** - RESTful endpoints with auth  
📱 **Beautiful Flutter Frontend** - 3 role-based dashboards  

### All working together:
```
Flutter App 
    ↓
JWT Auth 
    ↓
Express API 
    ↓
MySQL Database
```

### To run everything:
```bash
# Terminal 1: Start backend
npm start

# Terminal 2: Run Flutter app
flutter run

# Or test with curl
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"amit@khelahobe.com","password":"test123456"}'
```

---

**🎉 You've successfully built the foundation of KhelaHobe!**

Next: Integrate real data, add payments, deploy to production.

---

*Last Updated: 2026-05-16*  
*Version: 1.0.0*
