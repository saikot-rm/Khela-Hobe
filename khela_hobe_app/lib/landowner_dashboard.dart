import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/api_service.dart';

class LandownerDashboard extends StatefulWidget {
  const LandownerDashboard({super.key});

  @override
  State<LandownerDashboard> createState() => _LandownerDashboardState();
}

class _LandownerDashboardState extends State<LandownerDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String _landownerName = 'Landowner';
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _addressController = TextEditingController();
  final _rateController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isSubmitting = false;
  late Future<List<dynamic>> _venuesFuture;
  int? _editingVenueId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _venuesFuture = ApiService().fetchVenues();
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
    _titleController.dispose();
    _addressController.dispose();
    _rateController.dispose();
    _descriptionController.dispose();
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
        title: const Text('KhelaHobe Landowner'),
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
        onPressed: _showAddVenueDialog,
        backgroundColor: const Color(0xFF00FF85),
        foregroundColor: const Color(0xFF0D1027),
        icon: const Icon(Icons.add),
        label: const Text('Add Venue'),
      ),
    );
  }

  Future<void> _showAddVenueDialog({Map<String, dynamic>? venue}) async {
    if (venue != null) {
      _editingVenueId = venue['id'] as int?;
      _titleController.text = (venue['title'] ?? venue['name'] ?? '').toString();
      _addressController.text = (venue['location'] ?? '').toString();
      _rateController.text = (venue['hourly_price'] ?? venue['price_per_hour'] ?? '').toString();
      _descriptionController.text = (venue['description'] ?? '').toString();
    } else {
      _editingVenueId = null;
      _titleController.clear();
      _addressController.clear();
      _rateController.clear();
      _descriptionController.clear();
    }

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF161C3C),
          title: Text(_editingVenueId == null ? 'Add New Venue' : 'Edit Venue', style: const TextStyle(color: Colors.white)),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _titleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) => value == null || value.trim().isEmpty ? 'Please enter a title' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _addressController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'Address'),
                    validator: (value) => value == null || value.trim().isEmpty ? 'Please enter an address' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _rateController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Hourly Rate'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Please enter an hourly rate';
                      if (double.tryParse(value) == null) return 'Please enter a valid number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descriptionController,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitVenue,
              child: _isSubmitting ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : Text(_editingVenueId == null ? 'Submit' : 'Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitVenue() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final payload = {
        'name': _titleController.text.trim(),
        'location': _addressController.text.trim(),
        'price_per_hour': double.parse(_rateController.text.trim()),
        'description': _descriptionController.text.trim(),
        'type': 'turf',
      };

      if (_editingVenueId == null) {
        await ApiService().createVenue(payload);
      } else {
        await ApiService().updateVenue(_editingVenueId!, payload);
      }

      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_editingVenueId == null ? 'Venue created successfully!' : 'Venue updated successfully!')),
      );
      setState(() {
        _venuesFuture = ApiService().fetchVenues();
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save venue: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _deleteVenue(int id) async {
    try {
      await ApiService().deleteVenue(id);
      if (!mounted) return;
      setState(() {
        _venuesFuture = ApiService().fetchVenues();
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Venue deleted')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete venue: $error')));
    }
  }

  Widget _buildPropertyPerformance() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome, $_landownerName', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('Manage your turf portfolio with premium control', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 20),
            FutureBuilder<List<dynamic>>(
              future: _venuesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(height: 220, child: Center(child: CircularProgressIndicator()));
                }

                if (snapshot.hasError) {
                  return Text('Unable to load venues', style: TextStyle(color: Colors.redAccent.shade200));
                }

                final venues = snapshot.data ?? [];
                if (venues.isEmpty) {
                  return const Padding(padding: EdgeInsets.symmetric(vertical: 24), child: Text('No venues yet. Add your first turf.', style: TextStyle(color: Colors.grey)));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: venues.length,
                  itemBuilder: (context, index) {
                    final venue = venues[index] as Map<String, dynamic>;
                    return Dismissible(
                      key: ValueKey(venue['id'] ?? index),
                      background: Container(
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 24),
                        child: const Icon(Icons.delete_outline, color: Colors.white, size: 30),
                      ),
                      onDismissed: (_) => _deleteVenue((venue['id'] as num).toInt()),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: const LinearGradient(colors: [Color(0xFF4A144D), Color(0xFF360D3A)]),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 12, offset: const Offset(0, 8))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text((venue['title'] ?? venue['name'] ?? 'Turf').toString(), style: const TextStyle(fontFamily: 'Oswald', fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF00FF85))),
                                ),
                                IconButton(
                                  onPressed: () => _showAddVenueDialog(venue: Map<String, dynamic>.from(venue)),
                                  icon: const Icon(Icons.edit, color: Color(0xFF00FFFF)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text((venue['location'] ?? '').toString(), style: const TextStyle(color: Color(0xFFB8C1D9))),
                            const SizedBox(height: 8),
                            Text('৳${venue['hourly_price'] ?? venue['price_per_hour'] ?? 0}/hr', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                            const SizedBox(height: 8),
                            Text((venue['description'] ?? 'Premium turf ready for bookings').toString(), style: const TextStyle(color: Color(0xFFE9ECF8))),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
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
