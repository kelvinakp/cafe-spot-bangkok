import 'package:flutter/material.dart';

import '../models/cafe.dart';
import '../services/api_service.dart';
import '../widgets/cafe_network_image.dart';
import 'cafe_detail_screen.dart';

class CafeListScreen extends StatefulWidget {
  final String userEmail;

  const CafeListScreen({super.key, required this.userEmail});

  @override
  State<StatefulWidget> createState() {
    return _CafeListScreenState();
  }
}

class _CafeListScreenState extends State<CafeListScreen> {
  final ApiService _api = ApiService();
  List<Cafe> _cafes = [];
  List<Cafe> _filtered = [];
  bool _loading = true;
  String? _error;
  String _selectedArea = 'All';
  String _selectedVibe = 'All';

  final List<String> _areas = [
    'All',
    'Ari',
    'Phaya Thai',
    'Thonglor',
    'Silom',
    'Song Wat',
    'Ekkamai',
  ];

  final List<String> _vibes = [
    'All',
    'Quiet',
    'Aesthetic',
    'Pet-friendly',
    'Late-night',
  ];

  @override
  void initState() {
    super.initState();
    _fetchCafes();
  }

  Future<void> _fetchCafes() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final cafes = await _api.fetchCafes();
      setState(() {
        _cafes = cafes;
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
    _filtered = _cafes.where((cafe) {
      final areaOk = _selectedArea == 'All' || cafe.area == _selectedArea;
      final vibeOk = _selectedVibe == 'All' || cafe.vibe == _selectedVibe;
      return areaOk && vibeOk;
    }).toList();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Open':
        return Colors.green;
      case 'Crowded':
        return Colors.orange;
      case 'Closed':
        return Colors.red;
      default:
        return Colors.grey;
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
              Text('Failed to load cafes\n$_error', textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _fetchCafes,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchCafes,
      child: Column(
        children: [
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: _areas.map((area) {
                final selected = area == _selectedArea;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(area),
                    selected: selected,
                    onSelected: (_) {
                      setState(() {
                        _selectedArea = area;
                        _applyFilters();
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: _vibes.map((vibe) {
                final selected = vibe == _selectedVibe;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(vibe),
                    selected: selected,
                    onSelected: (_) {
                      setState(() {
                        _selectedVibe = vibe;
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
                ? ListView(
                    children: const [
                      SizedBox(height: 120),
                      Center(child: Text('No cafes found for this filter')),
                    ],
                  )
                : ListView.builder(
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final cafe = _filtered[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CafeNetworkImage(
                              url: cafe.imageUrl,
                              width: 64,
                              height: 64,
                            ),
                          ),
                          title: Text(cafe.name),
                          subtitle: Text(
                            '${cafe.area} • ${cafe.priceLevel} • WiFi ${cafe.wifiScore}\n${cafe.description}',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          isThreeLine: true,
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _statusColor(cafe.status)
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              cafe.status,
                              style: TextStyle(
                                color: _statusColor(cafe.status),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CafeDetailPage(
                                  id: cafe.id,
                                  userEmail: widget.userEmail,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
