import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
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

  Future _pickimagefromgallery() async {
    final rerunimage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _selectimg = File(rerunimage!.path);
    });
  }

  final _maxlength = 200;
  final _controller = TextEditingController();
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
                  onPressed: () {},
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
              controller: _controller,
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
