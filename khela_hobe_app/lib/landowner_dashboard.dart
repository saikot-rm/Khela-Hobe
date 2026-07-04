import 'package:flutter/material.dart';

import 'api_service.dart';

class LandownerDashboard extends StatefulWidget {
  const LandownerDashboard({super.key});

  @override
  State<LandownerDashboard> createState() => _LandownerDashboardState();
}

class _LandownerDashboardState extends State<LandownerDashboard> {
  final ApiService _apiService = ApiService();
  late Future<List<Map<String, dynamic>>> _venuesFuture;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _hourlyRateController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _mapLinkController = TextEditingController();
  int? _editingVenueId;

  static const Color _deepNavy = Color(0xFF38003C);
  static const Color _neonGreen = Color(0xFF00FF85);
  static const Color _magenta = Color(0xFFEA047E);
  static const Color _errorRed = Color(0xFFB00020);

  @override
  void initState() {
    super.initState();
    _loadVenues();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _hourlyRateController.dispose();
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
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () => _showVenueDialog(),
          child: const Icon(Icons.add, color: Colors.black),
        ),
      ),
    );
  }
}
