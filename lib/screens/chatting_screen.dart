import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_connect/screens/home_screen.dart';
import 'package:study_connect/screens/private_chatting.dart';

class ChattingScreen extends StatefulWidget {
  final Group group;
  const ChattingScreen({
    super.key,
    required this.group,
  });

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final messageController = TextEditingController();

  void sendMessage() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final message = messageController.text;
    final currentUser = _auth.currentUser;

    if (message.isNotEmpty && currentUser != null) {
      await _firestore
          .collection('groups')
          .doc(widget.group.id)
          .collection('messages')
          .add({
        'text': message,
        'email': currentUser.email,
        'createdAt': FieldValue
            .serverTimestamp(), // Use server time to keep consistent timestamps
      });
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const CircleAvatar(
                child: Icon(Icons.person),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(widget.group.name)
            ],
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.video_call)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings_accessibility))
          ],
          backgroundColor: const Color.fromARGB(255, 241, 156, 10),
        ),
        body: Column(
          children: [
            // Message list from Firestore
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('groups')
                    .doc(widget.group.id)
                    .collection('messages')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final messages = snapshot.data!.docs;

                  return ListView.builder(
                    reverse: true, // To show latest messages at the bottom
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final messageData = messages[index];
                      final messageText = messageData['text'] ?? '';
                      final senderEmail = messageData['email'] ?? 'Unknown';
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 241, 156, 10),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  messageText,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PrivateChatScreen(
                                          receiverEmail:
                                              senderEmail, // use senderEmail here
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    senderEmail,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ],
                            )),
                      );
                    },
                  );
                },
              ),
            ),
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
                        )),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  FloatingActionButton(
                    onPressed: sendMessage,
                    backgroundColor: const Color.fromARGB(255, 241, 156, 10),
                    child: const Icon(Icons.send),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
