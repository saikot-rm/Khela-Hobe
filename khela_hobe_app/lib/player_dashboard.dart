import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'api_service.dart';

class PlayerDashboard extends StatefulWidget {
  const PlayerDashboard({super.key});

  @override
  State<PlayerDashboard> createState() => _PlayerDashboardState();
}

class _PlayerDashboardState extends State<PlayerDashboard> {
  final ApiService _apiService = ApiService();
  late Future<List<Map<String, dynamic>>> _venuesFuture;

  static const Color _deepNavy = Color(0xFF38003C);
  static const Color _neonGreen = Color(0xFF00FF85);
  static const Color _magenta = Color(0xFFEA047E);

  @override
  void initState() {
    super.initState();
    _venuesFuture = _apiService.fetchVenues();
  }

  Future<void> _openMap(String url) async {
    if (url.isEmpty) return;
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open map link.')),
      );
    }
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dhaka Turf Gallery',
              style: TextStyle(
                color: _neonGreen,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Elite grounds, premium experience, swipe to explore.',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _venuesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator(color: _neonGreen));
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.error_outline, color: _magenta, size: 40),
                          SizedBox(height: 12),
                          Text('Unable to load turfs.', style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    );
                  }

                  final venues = snapshot.data ?? [];
                  if (venues.isEmpty) {
                    return const Center(
                      child: Text('No turf listings are available right now.', style: TextStyle(color: Colors.white70)),
                    );
                  }

                  return ListView.builder(
                    itemCount: venues.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return _buildVenueCard(venues[index]);
                    },
                  );
                },
              ),
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
                    Text(description, style: const TextStyle(color: Colors.white70, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
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
