import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'services/api_service.dart';

class PlayerDashboard extends StatefulWidget {
  const PlayerDashboard({super.key});

  @override
  State<PlayerDashboard> createState() => _PlayerDashboardState();
}

class _PlayerDashboardState extends State<PlayerDashboard> {
  int _selectedIndex = 0;
  late String _playerName = 'Player';
  late Future<List<dynamic>> _venuesFuture;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _venuesFuture = ApiService().fetchVenues();
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

  Future<void> _openMap(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open map link.')),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KhelaHobe Player'),
        centerTitle: false,
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
        backgroundColor: const Color(0xFF4A144D),
        selectedItemColor: const Color(0xFF00FF85),
        unselectedItemColor: const Color(0xFF8C9BB9),
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
            Text('Welcome, $_playerName', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('Find your next match-ready turf', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by venue or address',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<dynamic>>(
              future: _venuesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(height: 220, child: Center(child: CircularProgressIndicator()));
                }

                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Text('Unable to load venues. Please try again later.', style: TextStyle(color: Colors.redAccent.shade200)),
                  );
                }

                final venues = snapshot.data ?? [];
                if (venues.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: Text('No venues available at this time.', style: TextStyle(color: Colors.grey)),
                  );
                }

                final filteredVenues = venues.whereType<Map<String, dynamic>>().where((venue) {
                  final query = _searchController.text.toLowerCase();
                  if (query.isEmpty) return true;
                  final title = (venue['title'] ?? venue['name'] ?? '').toString().toLowerCase();
                  final address = (venue['location'] ?? '').toString().toLowerCase();
                  return title.contains(query) || address.contains(query);
                }).toList();

                if (filteredVenues.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: Text('No matching venues found.', style: TextStyle(color: Colors.grey)),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredVenues.length,
                  itemBuilder: (context, index) {
                    return _buildVenueCardFromData(filteredVenues[index]);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVenueCardFromData(Map<String, dynamic> venue) {
    final title = (venue['title'] ?? venue['name'] ?? venue['venue_name'] ?? 'Turf Location').toString();
    final locationType = (venue['location_type'] ?? venue['type'] ?? venue['locationType'] ?? 'Turf').toString();
    final priceValue = venue['hourly_price'] ?? venue['price_per_hour'] ?? venue['price'];
    final price = priceValue != null ? '৳$priceValue/hr' : 'Price unavailable';
    final address = (venue['location'] ?? venue['address'] ?? 'Premium location').toString();
    final mapLink = (venue['map_link'] ?? '').toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF4A144D), Color(0xFF360D3A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 16, offset: const Offset(0, 8)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(title, style: const TextStyle(fontFamily: 'Oswald', fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF00FF85))),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEA047E),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: mapLink.isNotEmpty ? () => _openMap(mapLink) : null,
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Color(0xFF00FFFF), size: 18),
                  const SizedBox(width: 6),
                  Expanded(child: Text(address, style: const TextStyle(color: Color(0xFFB8C1D9)))),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text('Type: $locationType', style: const TextStyle(color: Color(0xFFE9ECF8))),
            const SizedBox(height: 14),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.sports_soccer),
                  label: const Text('Book Turf'),
                ),
                const SizedBox(width: 8),
                if (mapLink.isNotEmpty)
                  ElevatedButton.icon(
                    onPressed: () => _openMap(mapLink),
                    icon: const Icon(Icons.map),
                    label: const Text('Open Map'),
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
                    const Text('Price: ৳1000', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
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
