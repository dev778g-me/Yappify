// comment_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iconsax/iconsax.dart';

class CommentScreen extends StatefulWidget {
  final String postId;

  const CommentScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to add a comment
  Future<void> _addComment() async {
    String comment = _commentController.text.trim();
    if (comment.isNotEmpty) {
      User? user = _auth.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('Posts')
            .doc(widget.postId)
            .collection('Comments')
            .add({
          'userId': user.uid,
          'username': user.email ?? 'Anonymous',
          'comment': comment,
          'timestamp': FieldValue.serverTimestamp(),
        });
        _commentController.clear(); // Clear the text field after adding
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Comments'),
        ),
        body: Column(
          children: [
            // List of comments
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Posts')
                    .doc(widget.postId)
                    .collection('Comments')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      return ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(doc['username']),
                        subtitle: Text(doc['comment']),
                        trailing: Text(
                          doc['timestamp'] != null
                              ? (doc['timestamp'] as Timestamp)
                                  .toDate()
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0]
                              : '',
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            // Input field to add a new comment
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      maxLines: null, // Allows for multiple lines
                      //maxLength: _maxlength,
                      decoration: const InputDecoration(
                        hintText:
                            "What's happening?", // Placeholder like Twitter
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,

                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 20.0,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Iconsax.send_1, color: Colors.blue),
                    onPressed: _addComment,
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
