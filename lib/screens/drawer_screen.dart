import 'package:flutter/material.dart';
import 'package:study_connect/screens/login_screen.dart';
import 'package:study_connect/screens/profile_screen.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Center(
        child: Column(
          children: [
            Container(
              height: 150,
              width: double.infinity,
              color: const Color.fromARGB(255, 241, 156, 10),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 35,
                  child: Icon(Icons.person),
                ),
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            ListTile(
              hoverColor: const Color.fromARGB(255, 241, 156, 10),
              onTap: () {},
              leading: const Icon(Icons.home),
              title: const Text("Home"),
            ),
            ListTile(
              hoverColor: const Color.fromARGB(255, 241, 156, 10),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ));
              },
              leading: const Icon(Icons.personal_injury),
              title: const Text("Profile"),
            ),
            ListTile(
              hoverColor: const Color.fromARGB(255, 241, 156, 10),
              onTap: () {},
              leading: const Icon(Icons.settings),
              title: const Text("Setting"),
            ),
            ListTile(
              hoverColor: const Color.fromARGB(255, 241, 156, 10),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ));
              },
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
