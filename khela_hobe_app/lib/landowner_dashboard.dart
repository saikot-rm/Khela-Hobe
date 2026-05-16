import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandownerDashboard extends StatefulWidget {
  const LandownerDashboard({super.key});

  @override
  State<LandownerDashboard> createState() => _LandownerDashboardState();
}

class _LandownerDashboardState extends State<LandownerDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String _landownerName = 'Landowner';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadLandownerInfo();
  }

  Future<void> _loadLandownerInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _landownerName = prefs.getString('user_name') ?? 'Landowner';
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        title: const Text('🏟️ KhelaHobe - Landowner'),
        backgroundColor: Colors.orange[700],
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Property Performance', icon: Icon(Icons.trending_up)),
            Tab(text: 'Construction Updates', icon: Icon(Icons.construction)),
          ],
        ),
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
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPropertyPerformance(),
          _buildConstructionUpdates(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add new venue feature coming soon!')),
          );
        },
        backgroundColor: Colors.orange[700],
        icon: const Icon(Icons.add),
        label: const Text('Add Venue'),
      ),
    );
  }

  Widget _buildPropertyPerformance() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, $_landownerName! 👋',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard('Total Revenue', '₹45,000', Colors.green),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard('Bookings', '24', Colors.blue),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard('Venues', '3', Colors.purple),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard('Avg Rating', '4.5★', Colors.orange),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Your Properties', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...[1, 2, 3].map((i) => _buildPropertyCard(i)),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyCard(int index) {
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
                  'Property $index',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: const Text('Active'),
                  backgroundColor: Colors.green[200],
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('28 bookings this month | ₹14,000 earned'),
            const SizedBox(height: 8),
            const LinearProgressIndicator(value: 0.75),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              icon: const Icon(Icons.edit),
              label: const Text('View Details'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConstructionUpdates() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Construction Updates',
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
                    const Text('Property 2 - Indoor Arena Expansion', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('Status: In Progress'),
                    const SizedBox(height: 8),
                    Chip(
                      label: const Text('75% Complete'),
                      backgroundColor: Colors.amber[200],
                    ),
                    const SizedBox(height: 12),
                    const LinearProgressIndicator(value: 0.75),
                    const SizedBox(height: 12),
                    const Text('Expected Completion: June 30, 2026'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text('No other ongoing projects', style: TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
