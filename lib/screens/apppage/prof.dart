import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Prof extends StatefulWidget {
  const Prof({super.key});

  @override
  State<Prof> createState() => _ProfState();
}

class _ProfState extends State<Prof> {
  String username = '';
  final user = FirebaseAuth.instance.currentUser;

  Future<void> getdata() async {
    if (user != null) {
      try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user!.uid)
            .get();
        if (snapshot.exists) {
          setState(() {
            username = snapshot['name'] ?? 'No name';
          });
        } else {
          print('Document does not exist');
        }
      } catch (e) {
        print('Error fetching data: $e');
      }
    } else {
      print('User is not logged in');
    }
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(username.isEmpty ? 'Loading...' : username),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 27),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 70,
              ),
            ),
            ElevatedButton(
              onPressed: getdata,
              child: Icon(Icons.abc_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
