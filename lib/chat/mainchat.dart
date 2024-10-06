import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _search = TextEditingController();
  Map<String, dynamic>? usermap;
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  void onsearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    await _firestore
        .collection('Users')
        .where('email', isEqualTo: _search.text)
        .get()
        .then(
      (value) {
        if (value.docs.isNotEmpty) {
          setState(() {
            usermap = value.docs[0].data();
            print(usermap);
          });
        } else
          setState(() {
            usermap = null;
            print(usermap);
          });
      },
    );
  }

  String chatroomid(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2[0].toLowerCase().codeUnits[0]) {
      return '$user1$user2';
    } else {
      return '$user2$user1';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Search Yapping'),
        ),
        body: Column(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: _search,
                  decoration: InputDecoration(
                    hintText: 'Search User',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20.0),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        onsearch();
                      },
                    ),
                  ),
                )),
            usermap != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      onTap: () {},
                      leading: CircleAvatar(
                          backgroundImage: usermap!['pfp'] != null
                              ? NetworkImage(usermap!['pfp'])
                              : AssetImage('assets/icon.png')),
                      title: Text(usermap!['name']),
                      subtitle: Text(usermap!['email']),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text('No User found'),
                    ),
                  )
          ],
        ));
  }

  void _startChatWithUser(String userId) {
    // Implement your chat functionality here
    // You can navigate to a chat screen or initialize a chat session with the selected user
    print('Start chat with user ID: $userId');
    // For example, you might navigate to another screen:
    // Navigator.push(context, MaterialPageRoute(builder: (context) => IndividualChatScreen(userId: userId)));
  }
}
