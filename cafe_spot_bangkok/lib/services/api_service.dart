import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

import '../models/cafe.dart';
import '../models/favorite.dart';

class ApiService {
  static const String deployedUrl = 'https://cafe-spot-bangkok.vercel.app';

  static String get baseUrl {
    if (deployedUrl.isNotEmpty) {
      return deployedUrl;
    }
    if (kIsWeb) {
      return 'http://localhost:3000';
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000';
    }
    return 'http://localhost:3000';
  }

  Future<List<Cafe>> fetchCafes() async {
    final response = await http.get(Uri.parse('$baseUrl/cafes'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load cafes');
    }
    final List<dynamic> data = json.decode(response.body);
    return data
        .map((item) => Cafe.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Cafe> fetchCafeById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/cafes/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load cafe detail');
    }
    final List<dynamic> data = json.decode(response.body);
    if (data.isEmpty) {
      throw Exception('Cafe not found');
    }
    return Cafe.fromJson(data[0] as Map<String, dynamic>);
  }

  Future<List<Favorite>> fetchFavorites({String? email}) async {
    final uri = email == null || email.isEmpty
        ? Uri.parse('$baseUrl/favorites')
        : Uri.parse('$baseUrl/favorites?email=${Uri.encodeComponent(email)}');
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to load favorites');
    }
    final List<dynamic> data = json.decode(response.body);
    return data
        .map((item) => Favorite.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Favorite> fetchFavoriteById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/favorites/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load favorite detail');
    }
    final List<dynamic> data = json.decode(response.body);
    if (data.isEmpty) {
      throw Exception('Favorite not found');
    }
    return Favorite.fromJson(data[0] as Map<String, dynamic>);
  }

  Future<void> createFavorite(Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl/favorites'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create favorite');
    }
  }

  Future<void> updateFavorite(Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse('$baseUrl/favorites'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to update favorite');
    }
  }

  Future<void> deleteFavorite(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/favorites'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete favorite');
    }
  }
}
