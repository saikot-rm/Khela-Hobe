# 🏟️ Flutter Frontend Setup for KhelaHobe!

## 📋 File Structure

The Flutter app consists of the following files that need to be organized in your Flutter project:

```
flutter_frontend/
└── lib/
    ├── main.dart                      ← flutter_main.dart (renamed)
    ├── widgets/
    │   └── role_router.dart           ← role_router.dart
    ├── screens/
    │   ├── auth/
    │   │   └── login_screen.dart      ← login_screen.dart
    │   └── dashboards/
    │       ├── player_dashboard.dart  ← player_dashboard.dart
    │       ├── landowner_dashboard.dart ← landowner_dashboard.dart
    │       └── investor_dashboard.dart ← investor_dashboard.dart
    └── providers/
        └── auth_provider.dart         ← auth_provider.dart
```

## 🚀 Setup Instructions

### Step 1: Create Flutter Project

```bash
flutter create khelahobe_mobile
cd khelahobe_mobile
```

### Step 2: Copy Dart Files

Copy all the `.dart` files from the root directory to their respective locations in the `lib/` folder.

**From**: `C:\Users\rm saikot\Documents\GitHub\Khela-Hobe\`  
**To**: `C:\Users\rm saikot\Documents\GitHub\Khela-Hobe\flutter_frontend\lib\`

### Step 3: Update pubspec.yaml

Replace the dependencies section in `pubspec.yaml` with:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  provider: ^6.0.0
  shared_preferences: ^2.2.2
  go_router: ^11.0.0
  cupertino_icons: ^1.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

### Step 4: Install Dependencies

```bash
flutter pub get
```

### Step 5: Run the App

```bash
flutter run
```

To run on a specific device:
```bash
flutter devices
flutter run -d <device-id>
```

## 📁 File Descriptions

| File | Purpose | Location |
|------|---------|----------|
| **role_router.dart** | Main routing widget that checks user role | `lib/widgets/` |
| **login_screen.dart** | Login & demo account access | `lib/screens/auth/` |
| **player_dashboard.dart** | Player interface with venue browsing | `lib/screens/dashboards/` |
| **landowner_dashboard.dart** | Landowner interface with properties | `lib/screens/dashboards/` |
| **investor_dashboard.dart** | Investor interface with ROI charts | `lib/screens/dashboards/` |
| **auth_provider.dart** | State management for authentication | `lib/providers/` |
| **flutter_main.dart** | App entry point (rename to main.dart) | `lib/` |

## 🎨 App Architecture

```
KhelaHobeApp (main.dart)
    ↓
MultiProvider (Provider setup)
    ↓
RoleRouter (role_router.dart)
    ↓
┌─────────────────────────────────────┐
│                                     │
├─ LoginScreen (no auth)              │
├─ PlayerDashboard (role='Player')    │
├─ LandownerDashboard (role='Landowner') │
└─ InvestorDashboard (role='Investor') │
```

## 🔐 Authentication Flow

1. **App Launch**: RoleRouter checks SharedPreferences for auth token
2. **No Token**: Show LoginScreen
3. **Login/Demo**: Save token & role to SharedPreferences
4. **Role Check**: Route to appropriate dashboard
5. **Logout**: Clear SharedPreferences, return to LoginScreen

## 🧪 Testing Different Roles

The app provides **instant demo logins** without credentials:

1. **Click "Player"** → Browse Venues, Make Bookings
2. **Click "Landowner"** → Manage Properties, View Revenue
3. **Click "Investor"** → See Wallet, ROI Charts, Investments

Or use test credentials:
```
Email: amit@khelahobe.com
Password: test123456
```

## 📱 Demo Account Roles

### 👤 Player Dashboard
- ✅ Bottom Navigation (Browse Venues, My Bookings, History)
- ✅ Search venues functionality
- ✅ View venue details & pricing
- ✅ Booking management

### 🏠 Landowner Dashboard
- ✅ Tab Navigation (Property Performance, Construction Updates)
- ✅ Revenue statistics
- ✅ Property management cards
- ✅ Construction progress tracking

### 💰 Investor Dashboard
- ✅ Wallet Balance Display (₹245,000)
- ✅ ROI Performance Chart (6-month history)
- ✅ Active Investments List
- ✅ Available Investment Opportunities
- ✅ Investment Analytics

## 🔗 Backend Connection

The app connects to your Node.js backend:

```
Backend URL: http://localhost:5000
```

### API Endpoints Used:
- `POST /api/auth/login` - User authentication
- `GET /api/auth/profile` - User profile data
- `GET /api/bookings/my-bookings` - Player bookings
- `GET /api/investments/projects` - Investment projects

**Important**: Ensure backend is running before testing real API calls.

## 🛠️ Development Commands

```bash
flutter run              # Run app
flutter run -v          # Verbose logging
flutter clean           # Clean build
flutter doctor          # Check dependencies
flutter pub get         # Install packages
```

## 🚨 Troubleshooting

### App crashes on launch
```bash
flutter clean
flutter pub get
flutter run
```

### Can't find http package
```bash
flutter pub add http
flutter pub get
```

### SharedPreferences not working
- Make sure you're running on emulator/device, not web
- Check app permissions in device settings

### Backend connection fails
1. Ensure Node.js backend is running: `npm start`
2. Check URL is correct: `http://localhost:5000`
3. Verify backend health: `curl http://localhost:5000/health`

## 📦 Dependencies Explained

| Package | Purpose |
|---------|---------|
| **http** | Make API requests to backend |
| **provider** | State management & auth |
| **shared_preferences** | Persist login data |
| **go_router** | Advanced routing (optional) |
| **cupertino_icons** | iOS-style icons |

## ✅ Verification Checklist

- [ ] All Dart files copied to correct folders
- [ ] `pubspec.yaml` updated with dependencies
- [ ] `flutter pub get` executed successfully
- [ ] No build errors: `flutter run`
- [ ] Demo logins work instantly
- [ ] Three different dashboards display correctly
- [ ] Logout clears data and returns to login
- [ ] Backend connection works (optional)

## 🎯 Next Steps

1. **Test Demo Logins** - Verify role-based routing works
2. **Connect Backend** - Update API endpoints when ready
3. **Add Real Data** - Replace mock data with backend data
4. **Payment Integration** - Add Razorpay or Stripe
5. **Push Notifications** - Firebase Cloud Messaging
6. **Image Upload** - Venue photos & documents

---

**Version**: 1.0.0  
**Flutter SDK**: 3.0+  
**Last Updated**: 2026-05-16
