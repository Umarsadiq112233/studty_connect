import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: const Color.fromARGB(255, 241, 156, 10),
      ),
      body: const Center(
        child: Column(
          children: [
            CircleAvatar(
              child: Icon(Icons.person_2),
            ),
          ],
        ),
      ),
    );
  }
}
