import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:study_connect/screens/chatting_screen.dart';
import 'package:study_connect/screens/home_screen.dart';

class GroupSearchDelegate extends SearchDelegate {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildGroupSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildGroupSearchResults();
  }

  Widget _buildGroupSearchResults() {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('groups')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name',
              isLessThanOrEqualTo: query + '\uf8ff') // To match prefix
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final results =
            snapshot.data!.docs.map((doc) => Group.fromFirestore(doc)).toList();

        if (results.isEmpty) {
          return Center(child: Text('No groups found.'));
        }

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final group = results[index];
            return ListTile(
              title: Text(group.name),
              subtitle: Text(group.createAt.toString()),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChattingScreen(group: group),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
