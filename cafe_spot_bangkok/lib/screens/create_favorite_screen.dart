import 'package:flutter/material.dart';

import '../models/cafe.dart';
import '../services/api_service.dart';

class CreateFavoriteScreen extends StatefulWidget {
  final String userEmail;
  final int? initialCafeId;

  const CreateFavoriteScreen({
    super.key,
    required this.userEmail,
    this.initialCafeId,
  });

  @override
  State<StatefulWidget> createState() {
    return CreateFavoriteScreenState();
  }
}

class CreateFavoriteScreenState extends State<CreateFavoriteScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _api = ApiService();
  final TextEditingController _noteController = TextEditingController();

  List<Cafe> _cafes = [];
  int? _selectedCafeId;
  String _category = 'Work-friendly';
  bool _loading = true;
  bool _saving = false;

  final List<String> _categories = [
    'Work-friendly',
    'Date spot',
    'Must try',
    'Quiet study',
    'Late-night',
  ];

  @override
  void initState() {
    super.initState();
    _loadCafes();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadCafes() async {
    try {
      final cafes = await _api.fetchCafes();
      setState(() {
        _cafes = cafes;
        _selectedCafeId = widget.initialCafeId ??
            (cafes.isNotEmpty ? cafes.first.id : null);
        _loading = false;
      });
    } catch (_) {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _create() async {
    if (_selectedCafeId == null) {
      _showSnackBar('Please select a cafe');
      return;
    }

    setState(() {
      _saving = true;
    });
    try {
      await _api.createFavorite({
        'user_email': widget.userEmail,
        'cafe_id': _selectedCafeId,
        'category': _category,
        'note': _noteController.text,
      });
      if (!mounted) return;
      _showSnackBar('Create favorite success');
      Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      _showSnackBar('Error creating favorite');
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Save Cafe')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Text('Saving as: ${widget.userEmail}'),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<int>(
                      initialValue: _selectedCafeId,
                      decoration: const InputDecoration(labelText: 'Cafe'),
                      items: _cafes
                          .map(
                            (cafe) => DropdownMenuItem(
                              value: cafe.id,
                              child: Text('${cafe.name} (${cafe.area})'),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCafeId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a cafe';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<String>(
                      initialValue: _category,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: _categories
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _category = value;
                          });
                        }
                      },
                    ),
                    TextFormField(
                      controller: _noteController,
                      decoration: const InputDecoration(labelText: 'Note'),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a note';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saving
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  _create();
                                }
                              },
                        child: Text(_saving ? 'Saving...' : 'CREATE'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
