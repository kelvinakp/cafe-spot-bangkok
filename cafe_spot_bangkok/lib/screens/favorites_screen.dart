import 'package:flutter/material.dart';

import '../models/favorite.dart';
import '../services/api_service.dart';
import '../widgets/cafe_network_image.dart';
import 'create_favorite_screen.dart';
import 'update_favorite_screen.dart';

class FavoritesScreen extends StatefulWidget {
  final String userEmail;

  const FavoritesScreen({super.key, required this.userEmail});

  @override
  State<StatefulWidget> createState() {
    return _FavoritesScreenState();
  }
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final ApiService _api = ApiService();
  List<Favorite> _favorites = [];
  List<Favorite> _filtered = [];
  bool _loading = true;
  String? _error;
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Work-friendly',
    'Date spot',
    'Must try',
    'Quiet study',
    'Late-night',
  ];

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  Future<void> _fetchFavorites() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final favorites = await _api.fetchFavorites(email: widget.userEmail);
      setState(() {
        _favorites = favorites;
        _applyFilters();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _applyFilters() {
    _filtered = _favorites.where((item) {
      return _selectedCategory == 'All' || item.category == _selectedCategory;
    }).toList();
  }

  Future<void> _deleteFavorite(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove save?'),
        content: const Text(
          'This only removes your saved item. The cafe stays in Explore.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _api.deleteFavorite(id);
      setState(() {
        _favorites.removeWhere((item) => item.id == id);
        _applyFilters();
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Delete favorite success')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting favorite: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Failed to load saves\n$_error',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _fetchFavorites,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateFavoriteScreen(
                      userEmail: widget.userEmail,
                    ),
                  ),
                );
                _fetchFavorites();
              },
              child: const Text('CREATE SAVE'),
            ),
          ),
        ),
        SizedBox(
          height: 52,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            children: _categories.map((category) {
              final selected = category == _selectedCategory;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(category),
                  selected: selected,
                  onSelected: (_) {
                    setState(() {
                      _selectedCategory = category;
                      _applyFilters();
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: _filtered.isEmpty
              ? const Center(child: Text('No saved cafes yet. Create one!'))
              : ListView.builder(
                  itemCount: _filtered.length,
                  itemBuilder: (context, index) {
                    final favorite = _filtered[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CafeNetworkImage(
                                    url: favorite.cafeImage,
                                    width: 56,
                                    height: 56,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        favorite.cafeName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        '${favorite.category} • ${favorite.cafeArea}',
                                      ),
                                      Text(
                                        favorite.note,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () =>
                                      _deleteFavorite(favorite.id),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text('DEL'),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            UpdateFavoriteScreen(
                                          id: favorite.id,
                                          userEmail: widget.userEmail,
                                        ),
                                      ),
                                    );
                                    _fetchFavorites();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.blue,
                                  ),
                                  child: const Text('EDIT'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
