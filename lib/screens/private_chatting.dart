import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PrivateChatScreen extends StatefulWidget {
  final String receiverEmail;
  const PrivateChatScreen({
    Key? key,
    required this.receiverEmail,
  }) : super(key: key);

  @override
  _PrivateChatScreenState createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final messageController = TextEditingController();
  late String currentUserEmail;
  late String chatId;

  @override
  void initState() {
    super.initState();
    currentUserEmail = _auth.currentUser!.email!;
    chatId = _getChatId(currentUserEmail, widget.receiverEmail);
  }

  // Generate a unique chat ID for the two users based on their email addresses
  String _getChatId(String user1, String user2) {
    // Sort emails alphabetically to ensure the same chat ID regardless of user order
    List<String> emails = [user1, user2];
    emails.sort();
    return '${emails[0]}_${emails[1]}';
  }

  void sendMessage() async {
    final message = messageController.text;

    if (message.isNotEmpty) {
      final senderName =
          await _getSenderName(); // Fetch sender name from Firestore

      await _firestore
          .collection('privateChats')
          .doc(chatId)
          .collection('messages')
          .add({
        'text': message,
        'sender': currentUserEmail,
        'senderName': senderName, // Include sender name
        'receiver': widget.receiverEmail,
        'createdAt': FieldValue.serverTimestamp(),
      });

      messageController.clear();
    }
  }

// Function to get the sender's name
  Future<String> _getSenderName() async {
    final currentUser = _auth.currentUser;
    final userDoc =
        await _firestore.collection('users').doc(currentUser!.uid).get();
    return userDoc.data()?['name'] ?? 'Unknown'; // Return the sender's name
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with ${widget.receiverEmail}"),
        backgroundColor: const Color.fromARGB(255, 241, 156, 10),
      ),
      body: Column(
        children: [
          // Messages list from Firestore
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('privateChats')
                  .doc(chatId)
                  .collection('messages')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true, // Show latest messages at the bottom
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageData = messages[index];
                    final messageText = messageData['text'] ?? '';
                    final sender = messageData['sender'] ?? 'Unknown';
                    final isCurrentUser = sender == currentUserEmail;

                    return Align(
                      alignment: isCurrentUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isCurrentUser
                              ? const Color.fromARGB(255, 241, 156, 10)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: isCurrentUser
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              messageText,
                              style: TextStyle(
                                  color: isCurrentUser
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            Text(
                              sender,
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Message input field
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: messageController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Type new message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: const BorderSide(
                          width: 3,
                          color: Color.fromARGB(255, 241, 156, 10),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: sendMessage,
                  backgroundColor: const Color.fromARGB(255, 241, 156, 10),
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
