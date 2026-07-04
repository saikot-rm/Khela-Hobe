import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'services/api_service.dart';

class PlayerDashboard extends StatefulWidget {
  const PlayerDashboard({super.key});

  @override
  State<PlayerDashboard> createState() => _PlayerDashboardState();
}

class _PlayerDashboardState extends State<PlayerDashboard> {
  final ApiService _api_service = ApiService();
  final ApiService _apiService = ApiService();
  int _selectedIndex = 0;
  late String _playerName = 'Player';
  late Future<List<Map<String, dynamic>>> _venuesFuture;
  final _searchController = TextEditingController();

  static const Color _deepNavy = Color(0xFF38003C);
  static const Color _neonGreen = Color(0xFF00FF85);
  static const Color _magenta = Color(0xFFEA047E);

  @override
  void initState() {
    super.initState();
    _venuesFuture = _apiService.fetchVenues();
    _loadPlayerInfo();
  }

  Future<void> _openMap(String url) async {
    if (url.isEmpty) return;
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open map link.')),
      );
    }
  }
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
      backgroundColor: _deepNavy,
      appBar: AppBar(
        title: const Text('Premier Turf Showcase'),
        backgroundColor: _deepNavy,
        elevation: 0,
        centerTitle: true,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVenueCard(Map<String, dynamic> venue) {
    final title = venue['title']?.toString() ?? 'Unknown Turf';
    final description = venue['description']?.toString() ?? '';
    final address = venue['address']?.toString() ?? 'Location unavailable';
    final hourlyRate = venue['hourly_rate']?.toString() ?? '0';
    final imageUrl = venue['image_url']?.toString() ?? '';
    final mapLink = venue['map_link']?.toString() ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Card(
        color: const Color(0xFF2A0735),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 8,
        shadowColor: _magenta.withOpacity(0.35),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (imageUrl.isNotEmpty)
                SizedBox(
                  height: 200,
                  child: Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.black12,
                      child: const Center(
                        child: Icon(Icons.image_not_supported, color: Colors.white30, size: 48),
                      ),
                    ),
                  ),
                ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF00FF85), Color(0xFFEA047E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.0, 1.0],
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 6),
                    Text((venue['description'] ?? '').toString(), style: const TextStyle(color: Colors.white70, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('৳$hourlyRate / hour', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text('Premium', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () => _openMap(mapLink),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              address,
                              style: const TextStyle(color: Colors.white, decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () => _openMap(mapLink),
                      icon: const Icon(Icons.map_outlined, color: Colors.white, size: 18),
                      label: const Text('Open in Google Maps', style: TextStyle(color: Colors.white)),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
