import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvestorDashboard extends StatefulWidget {
  const InvestorDashboard({super.key});

  @override
  State<InvestorDashboard> createState() => _InvestorDashboardState();
}

class _InvestorDashboardState extends State<InvestorDashboard> {
  late String _investorName = 'Investor';
  final double _walletBalance = 245000.0;
  final double _totalReturns = 18500.0;

  @override
  void initState() {
    super.initState();
    _loadInvestorInfo();
  }

  Future<void> _loadInvestorInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _investorName = prefs.getString('user_name') ?? 'Investor';
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
        title: const Text('🏟️ KhelaHobe - Investor'),
        backgroundColor: Colors.deepPurple[700],
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, $_investorName! 👋',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              
              // Wallet Balance Card
              _buildWalletCard(),
              const SizedBox(height: 24),
              
              // ROI Chart
              _buildROIChart(),
              const SizedBox(height: 24),
              
              // Active Investments
              _buildActiveInvestments(),
              const SizedBox(height: 24),
              
              // Available Investment Listings
              _buildAvailableListings(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Investment feature coming soon!')),
          );
        },
        backgroundColor: Colors.deepPurple[700],
        icon: const Icon(Icons.trending_up),
        label: const Text('Invest Now'),
      ),
    );
  }

  Widget _buildWalletCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.deepPurple[700]!, Colors.deepPurple[500]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Wallet Balance',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 12),
            Text(
              '৳${_walletBalance.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Returns',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '+৳${_totalReturns.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.lightGreen,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'ROI',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '7.5%',
                      style: TextStyle(
                        color: Colors.yellow[200],
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildROIChart() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ROI Performance (Last 6 Months)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildROIBar('Jan', 2.5),
                _buildROIBar('Feb', 3.2),
                _buildROIBar('Mar', 4.1),
                _buildROIBar('Apr', 5.5),
                _buildROIBar('May', 6.8),
                _buildROIBar('Jun', 7.5),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildROIBar(String month, double percentage) {
    return Column(
      children: [
        Container(
          width: 30,
          height: percentage * 20,
          decoration: BoxDecoration(
            color: Colors.deepPurple[400],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(month, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildActiveInvestments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Your Active Investments', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildInvestmentCard('Arena Central - Turf Expansion', '৳100,000', '8.5%', 0.65),
        const SizedBox(height: 12),
        _buildInvestmentCard('Indoor Sports Complex', '৳75,000', '6.2%', 0.45),
        const SizedBox(height: 12),
        _buildInvestmentCard('Picnic Ground Development', '৳50,000', '5.8%', 0.30),
      ],
    );
  }

  Widget _buildInvestmentCard(String project, String amount, String roi, double progress) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    project,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Chip(
                  label: Text(roi, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  backgroundColor: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Invested: $amount', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple[600]!),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${(progress * 100).toStringAsFixed(0)}% funded',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableListings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Available Investment Opportunities', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {},
              child: const Text('See All', style: TextStyle(color: Colors.deepPurple)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildListingCard('Community Sports Center', '৳500,000 target', '12% expected ROI', 'Funding'),
        const SizedBox(height: 12),
        _buildListingCard('Rooftop Turf Project', '৳300,000 target', '9.5% expected ROI', 'Funding'),
      ],
    );
  }

  Widget _buildListingCard(String title, String target, String roi, String status) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
                Chip(
                  label: const Text('New', style: TextStyle(color: Colors.white, fontSize: 12)),
                  backgroundColor: Colors.amber,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(target, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 4),
            Text(roi, style: const TextStyle(color: Colors.green, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Investment details coming soon!')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              child: const SizedBox(
                width: double.infinity,
                child: Center(child: Text('View Details')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
