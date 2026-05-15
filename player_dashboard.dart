import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayerDashboard extends StatefulWidget {
  const PlayerDashboard({Key? key}) : super(key: key);

  @override
  State<PlayerDashboard> createState() => _PlayerDashboardState();
}

class _PlayerDashboardState extends State<PlayerDashboard> {
  int _selectedIndex = 0;
  late String _playerName = 'Player';

  @override
  void initState() {
    super.initState();
    _loadPlayerInfo();
  }

  Future<void> _loadPlayerInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _playerName = prefs.getString('user_name') ?? 'Player';
    });
  }

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏟️ KhelaHobe - Player'),
        backgroundColor: Colors.green[700],
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'logout') {
                _logout();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('My Profile'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: _buildContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Browse Venues',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'My Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Booking History',
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildBrowseVenues();
      case 1:
        return _buildMyBookings();
      case 2:
        return _buildBookingHistory();
      default:
        return _buildBrowseVenues();
    }
  }

  Widget _buildBrowseVenues() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, $_playerName! 👋',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search venues by location...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Available Venues', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...[1, 2, 3].map((i) => _buildVenueCard(i)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildVenueCard(int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Arena ${index} - Turf',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: const Text('Active'),
                  backgroundColor: Colors.green[200],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                const Expanded(
                  child: Text('Downtown Area, City'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('₹500/hour', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green)),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Booking feature coming soon!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Book Now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyBookings() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Active Bookings',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Arena 1 - Turf', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('Date: June 15, 2026'),
                    const Text('Time: 5:00 PM - 7:00 PM'),
                    const Text('Price: ₹1000', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Chip(
                      label: const Text('Confirmed'),
                      backgroundColor: Colors.blue[200],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text('No more bookings', style: TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingHistory() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.history, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Booking History',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Your past bookings will appear here'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() => _selectedIndex = 0);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Browse Venues'),
          ),
        ],
      ),
    );
  }
}
