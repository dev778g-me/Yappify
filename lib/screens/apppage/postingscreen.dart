import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';

import 'package:social/screens/homescreen.dart';

class Postingscreen extends StatefulWidget {
  Postingscreen({super.key});

  @override
  State<Postingscreen> createState() => _PostingscreenState();
}

class _PostingscreenState extends State<Postingscreen> {
  File? _selectimg;
  final _user = FirebaseAuth.instance.currentUser;
  final yappcontroll = TextEditingController();
  bool posting = false;
  String username = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getusername();
  }

  void getusername() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(_user!.uid)
        .get();
    print(snapshot.data());
    setState(() {
      username = (snapshot.data() as Map<String, dynamic>)['name'];
    });
  }

  Future<void> postayapp(String yapp) async {
    setState(() {
      posting = true;
    });
    if (_user != null) {
      String useriD = _user.uid;
      String email = _user.email.toString();

      await FirebaseFirestore.instance.collection('Posts').add({
        'userid': useriD,
        'timestamp': Timestamp.now(),
        'content': yapp,
        'likes': 0,
        'name': username,
        'email': email,
        'liked by': []
      }).then((_) {
        Get.snackbar('Success', 'Post added Successfully',
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green,
            snackPosition: SnackPosition.TOP);
        print('succsess');
      }).catchError((onError) {
        print(onError);
      });
    }
  }

  Future _pickimagefromgallery() async {
    final rerunimage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _selectimg = File(rerunimage!.path);
    });
  }

  final _maxlength = 200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: EdgeInsets.symmetric(
                      vertical: 0,
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    postayapp(yappcontroll.text);
                    yappcontroll.clear();
                    Get.offAll(() => Homescreen());
                  },
                  child: Text(
                    'Post',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            )
          ],
          leadingWidth: 30,
          leading: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Save Post ?'),
                    content:
                        const Text('You Can Save This Post And Post It Later '),
                    actions: [
                      TextButton(
                        onPressed: () => Get.offAll(() => Homescreen()),
                        child: const Text(
                          'No',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(CupertinoIcons.multiply)),
          title: Text('Post to')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: yappcontroll,
              maxLines: null, // Allows for multiple lines
              maxLength: _maxlength,
              decoration: const InputDecoration(
                hintText: "What's happening?", // Placeholder like Twitter
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,

                contentPadding: EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 20.0,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: Icon(Icons.photo, color: Colors.blue),
            onPressed: () {
              _pickimagefromgallery(); // Add your action for image selection
            },
          ),
          IconButton(
            icon: Icon(Icons.gif, color: Colors.blue),
            onPressed: () {
              // Add your action for GIF selection
            },
          ),
          IconButton(
            icon: Icon(Icons.poll, color: Colors.blue),
            onPressed: () {
              // Add your action for poll creation
            },
          ),
          IconButton(
            icon: Icon(Icons.location_on, color: Colors.blue),
            onPressed: () {
              // Add your action for location tagging
            },
          ),
        ],
      ),
    );
  }
}
