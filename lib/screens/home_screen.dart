// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_connect/screens/chatting_screen.dart';
import 'package:study_connect/screens/create_group.dart';
import 'package:study_connect/screens/drawer_screen.dart';
import 'package:study_connect/screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerScreen(),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 241, 156, 10),
        title: const Text("Groups"),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: GroupSearchDelegate());
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Consumer<GroupProvider>(
        builder: (context, GroupProvider, child) {
          return ListView.builder(
            itemCount: GroupProvider.groups.length,
            itemBuilder: (context, index) {
              final group = GroupProvider.groups[index];
              return ListTile(
                leading: const CircleAvatar(
                  child: Icon(
                    Icons.person,
                    color: Color.fromARGB(255, 241, 156, 10),
                  ),
                ),
                title: Text(group.name),
                subtitle: Text(group.createAt.toString()),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChattingScreen(group: group),
                      ));
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final groupName = await showDialog<String>(
            context: context,
            builder: (context) => const CreateGroup(),
          );

          if (groupName != null && groupName.isNotEmpty) {
            Provider.of<GroupProvider>(context, listen: false)
                .createGroup(groupName);
          }
        },
        backgroundColor: const Color.fromARGB(255, 241, 156, 10),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Group {
  final String id; // Firestore document ID
  final String name;
  final DateTime createAt;

  Group({required this.id, required this.name, required this.createAt});

  // Convert Group object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'createAt': createAt.toIso8601String(),
    };
  }

  // Create Group object from Firestore document snapshot
  factory Group.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Group(
        id: doc.id,
        name: data['name'],
        createAt: (data['createAt'] as Timestamp).toDate());
  }
}

class GroupProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Group> _groups = [];

  List<Group> get groups => _groups;

  GroupProvider() {
    _loadGroupsFromFirestore();
  }

  // Create a group and save it to Firestore
  Future<void> createGroup(String name) async {
    try {
      final newGroup = {
        'name': name,
        'createAt': FieldValue.serverTimestamp(),
      };
      await _firestore.collection('groups').add(newGroup);
    } catch (e) {
      print("Error creating group: $e");
    }
  }

  // Load groups from Firestore
  void _loadGroupsFromFirestore() {
    _firestore.collection('groups').snapshots().listen((snapshot) {
      _groups = snapshot.docs.map((doc) => Group.fromFirestore(doc)).toList();
      notifyListeners();
    });
  }
}
