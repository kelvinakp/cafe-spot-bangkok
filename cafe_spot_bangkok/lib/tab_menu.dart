import 'package:flutter/material.dart';

import 'screens/cafe_list_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/profile_screen.dart';

class TabMenu extends StatelessWidget {
  final String userEmail;

  const TabMenu({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cafe Spot Bangkok'),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.explore), text: 'Explore'),
              Tab(icon: Icon(Icons.bookmark), text: 'My Saves'),
              Tab(icon: Icon(Icons.person), text: 'Profile'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CafeListScreen(userEmail: userEmail),
            FavoritesScreen(userEmail: userEmail),
            ProfileScreen(userEmail: userEmail),
          ],
        ),
      ),
    );
  }
}
