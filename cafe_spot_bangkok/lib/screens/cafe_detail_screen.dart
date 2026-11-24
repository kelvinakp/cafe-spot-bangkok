import 'package:flutter/material.dart';

import '../models/cafe.dart';
import '../services/api_service.dart';
import '../widgets/cafe_network_image.dart';
import 'create_favorite_screen.dart';

class CafeDetailPage extends StatefulWidget {
  final int id;
  final String userEmail;

  const CafeDetailPage({
    super.key,
    required this.id,
    required this.userEmail,
  });

  @override
  State<StatefulWidget> createState() {
    return _CafeDetailPageState();
  }
}

class _CafeDetailPageState extends State<CafeDetailPage> {
  final ApiService _api = ApiService();
  Cafe? _cafe;

  @override
  void initState() {
    super.initState();
    _fetchCafeDetail();
  }

  Future<void> _fetchCafeDetail() async {
    try {
      final cafe = await _api.fetchCafeById(widget.id);
      setState(() {
        _cafe = cafe;
      });
    } catch (_) {
      setState(() {
        _cafe = null;
      });
    }
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF5D4037)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$label: $value',
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cafe Detail')),
      body: _cafe == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CafeNetworkImage(
                      url: _cafe!.imageUrl,
                      width: double.infinity,
                      height: 220,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _cafe!.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(_cafe!.description),
                  const SizedBox(height: 16),
                  _infoRow(Icons.place, 'Area', _cafe!.area),
                  _infoRow(Icons.home, 'Address', _cafe!.address),
                  _infoRow(Icons.mood, 'Vibe', _cafe!.vibe),
                  _infoRow(Icons.wifi, 'WiFi', _cafe!.wifiScore),
                  _infoRow(Icons.local_drink, 'Signature', _cafe!.signatureDrink),
                  _infoRow(Icons.payments, 'Price', _cafe!.priceLevel),
                  _infoRow(Icons.storefront, 'Status', _cafe!.status),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateFavoriteScreen(
                              userEmail: widget.userEmail,
                              initialCafeId: _cafe!.id,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.bookmark_add),
                      label: const Text('Save to My Category'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
