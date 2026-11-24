import 'package:flutter/material.dart';

import '../models/cafe.dart';
import '../services/api_service.dart';

class UpdateFavoriteScreen extends StatefulWidget {
  final int id;
  final String userEmail;

  const UpdateFavoriteScreen({
    super.key,
    required this.id,
    required this.userEmail,
  });

  @override
  State<StatefulWidget> createState() {
    return UpdateFavoriteScreenState();
  }
}

class UpdateFavoriteScreenState extends State<UpdateFavoriteScreen> {
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
    _load();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final cafes = await _api.fetchCafes();
      final favorite = await _api.fetchFavoriteById(widget.id);
      setState(() {
        _cafes = cafes;
        _selectedCafeId = favorite.cafeId;
        _category = favorite.category;
        _noteController.text = favorite.note;
        _loading = false;
      });
    } catch (_) {
      setState(() {
        _loading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch favorite data')),
      );
    }
  }

  Future<void> _update() async {
    if (_selectedCafeId == null) return;

    setState(() {
      _saving = true;
    });
    try {
      await _api.updateFavorite({
        'id': widget.id,
        'user_email': widget.userEmail,
        'cafe_id': _selectedCafeId,
        'category': _category,
        'note': _noteController.text,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Update favorite success')),
      );
      Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating favorite')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Save')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
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
                    ),
                    DropdownButtonFormField<String>(
                      initialValue: _categories.contains(_category)
                          ? _category
                          : _categories.first,
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
                                  _update();
                                }
                              },
                        child: Text(_saving ? 'Saving...' : 'EDIT'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
