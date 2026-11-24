import 'package:flutter/material.dart';

import '../login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String userEmail;

  const ProfileScreen({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: Color(0xFF6D4C41),
            child: Icon(Icons.person, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            'Cafe Spot Bangkok',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('Logged in as: $userEmail'),
          const SizedBox(height: 4),
          const Text('CSC452 Final Project • Team of 2'),
          const SizedBox(height: 24),
          const Text(
            'How this app works',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text('• Explore: browse real Bangkok cafes'),
          const Text('• My Saves: CRUD your cafe saves by category'),
          const Text('• Delete only removes your save, not the cafe'),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }
}
