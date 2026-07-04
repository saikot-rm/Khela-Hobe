import 'package:flutter/material.dart';

import 'api_service.dart';

import 'services/api_service.dart';

class LandownerDashboard extends StatefulWidget {
  const LandownerDashboard({super.key});

  @override
  State<LandownerDashboard> createState() => _LandownerDashboardState();
}

class _LandownerDashboardState extends State<LandownerDashboard>
    with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  late TabController _tabController;
  late String _landownerName = 'Landowner';
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _addressController = TextEditingController();
  final _rateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _mapLinkController = TextEditingController();
  bool _isSubmitting = false;
  late Future<List<Map<String, dynamic>>> _venuesFuture;
  int? _editingVenueId;

  static const Color _deepNavy = Color(0xFF38003C);
  static const Color _neonGreen = Color(0xFF00FF85);
  static const Color _magenta = Color(0xFFEA047E);
  static const Color _errorRed = Color(0xFFB00020);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadVenues();
    _loadLandownerInfo();
  }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _addressController.dispose();
    _rateController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _mapLinkController.dispose();
    super.dispose();
  }

  void _loadVenues() {
    setState(() {
      _venuesFuture = _apiService.fetchVenues();
    });
  }

  void _showVenueDialog({Map<String, dynamic>? venue}) {
    if (venue != null) {
      _editingVenueId = venue['id'] as int?;
      _titleController.text = venue['title']?.toString() ?? '';
      _descriptionController.text = venue['description']?.toString() ?? '';
      _addressController.text = venue['address']?.toString() ?? '';
      _hourlyRateController.text = venue['hourly_rate']?.toString() ?? '';
      _imageUrlController.text = venue['image_url']?.toString() ?? '';
      _mapLinkController.text = venue['map_link']?.toString() ?? '';
    } else {
      _editingVenueId = null;
      _titleController.clear();
      _descriptionController.clear();
      _addressController.clear();
      _hourlyRateController.clear();
      _imageUrlController.clear();
      _mapLinkController.clear();
    }

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1B0029),
          title: Text(
            _editingVenueId == null ? 'Create New Turf' : 'Update Turf',
            style: const TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(_titleController, 'Title'),
                  const SizedBox(height: 10),
                  _buildTextField(_descriptionController, 'Description', maxLines: 3),
                  const SizedBox(height: 10),
                  _buildTextField(_addressController, 'Address'),
                  const SizedBox(height: 10),
                  _buildTextField(_hourlyRateController, 'Hourly Rate (৳)', keyboardType: TextInputType.number),
                  const SizedBox(height: 10),
                  _buildTextField(_imageUrlController, 'Image Asset Path'),
                  const SizedBox(height: 10),
                  _buildTextField(_mapLinkController, 'Google Maps Link', keyboardType: TextInputType.url),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: _neonGreen),
              onPressed: _saveVenue,
              child: Text(_editingVenueId == null ? 'Create' : 'Update', style: const TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF2E003E),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Required field';
        }
        if (label == 'Hourly Rate (৳)' && double.tryParse(value) == null) {
          return 'Enter a valid number';
        }
        return null;
      },
    );
  }

  Future<void> _saveVenue() async {
    if (!_formKey.currentState!.validate()) return;

    final payload = {
      'landowner_id': 1,
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'address': _addressController.text.trim(),
      'hourly_rate': double.parse(_hourlyRateController.text.trim()),
      'image_url': _imageUrlController.text.trim(),
      'map_link': _mapLinkController.text.trim(),
    };

    try {
      if (_editingVenueId == null) {
        await _apiService.createVenue(payload);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Turf created successfully')));
      } else {
        await _apiService.updateVenue(_editingVenueId!, payload);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Turf updated successfully')));
      }
      _loadVenues();
      Navigator.of(context).pop();
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unable to save turf.')));
    }
  }

  Future<void> _deleteVenue(int id) async {
    try {
      await _apiService.deleteVenue(id);
      _loadVenues();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Turf deleted successfully')));
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to delete turf.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _deepNavy,
      appBar: AppBar(
        title: const Text('Landowner Control Room'),
        backgroundColor: _deepNavy,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Manage your Dhaka turf portfolio', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Swipe left to remove, tap edit to update update details.', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 18),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _venuesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator(color: _neonGreen));
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Unable to load turfs.', style: TextStyle(color: Colors.white70)));
                  }
                  final venues = snapshot.data ?? [];
                  if (venues.isEmpty) {
                    return const Center(child: Text('No turfs found. Add a new turf to get started.', style: TextStyle(color: Colors.white70)));
                  }
                  return ListView.builder(
                    itemCount: venues.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final venue = venues[index];
                      return Dismissible(
                        key: ValueKey(venue['id']),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          padding: const EdgeInsets.only(right: 24),
                          decoration: BoxDecoration(color: _errorRed, borderRadius: BorderRadius.circular(22)),
                          alignment: Alignment.centerRight,
                          child: const Icon(Icons.delete, color: Colors.white, size: 32),
                        ),
                        onDismissed: (_) {
                          _deleteVenue(venue['id'] as int);
                        },
                        child: Card(
                          color: const Color(0xFF2A0735),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                          elevation: 6,
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        venue['title']?.toString() ?? 'Untitled Turf',
                                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: _neonGreen),
                                      onPressed: () => _showVenueDialog(venue: venue),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(venue['description']?.toString() ?? '', style: const TextStyle(color: Colors.white70)),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, color: _magenta, size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        venue['address']?.toString() ?? '',
                                        style: const TextStyle(color: Colors.white70),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '৳${venue['hourly_rate']?.toString() ?? '0'}/hr',
                                      style: const TextStyle(color: _neonGreen, fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    Text(
                                      'ID: ${venue['id']}',
                                      style: const TextStyle(color: Colors.white38, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 64,
        height: 64,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFF00FF85), Color(0xFFEA047E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
      _imageUrlController.text = (venue['image_url'] ?? '').toString();
      _mapLinkController.text = (venue['map_link'] ?? '').toString();
    } else {
      _editingVenueId = null;
      _titleController.clear();
      _addressController.clear();
      _rateController.clear();
      _descriptionController.clear();
      _imageUrlController.clear();
      _mapLinkController.clear();
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
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _imageUrlController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'Image URL'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _mapLinkController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'Map Link'),
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
        'image_url': _imageUrlController.text.trim(),
        'map_link': _mapLinkController.text.trim(),
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
        ),
      ),
    );
  }
}
