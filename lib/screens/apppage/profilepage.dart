import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social/screens/apppage/commentpage.dart';
import 'package:social/screens/loginscreen.dart';

class Profilepage extends StatefulWidget {
  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  final _user = FirebaseAuth.instance;
  String username = '';
  String uid = '';
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String urld = '';

  Future<void> _pickimage() async {
    final pickedfile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedfile != null) {
      setState(() {
        _image = File(pickedfile.path);
      });
      _uploadimage();
    }
  }

  Future<void> _uploadimage() async {
    if (_image == null) return;

    final storageref = FirebaseStorage.instance
        .ref()
        .child('users/${_user.currentUser!.uid}.jpg'); // Unique path per user
    final uploadtask = storageref.putFile(_image!);
    final snapshot = await uploadtask.whenComplete(() {});

    final downloadurl = await snapshot.ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(_user.currentUser!.uid)
        .update({'pfp': downloadurl});

    setState(() {
      urld = downloadurl;
    });
  }

  @override
  void initState() {
    super.initState();
    uid = _user.currentUser!.uid; // Set user ID here
    getusername();
  }

  void getusername() async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      setState(() {
        username = snapshot['name'] ?? '';
        urld = snapshot['pfp'] ?? ''; // Fetch profile picture URL
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching username: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    void logout() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to Log Out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Close dialog
              child: const Text('No', style: TextStyle(color: Colors.blue)),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance
                      .signOut(); // Sign out from Firebase
                  Navigator.of(context).pop(); // Close the dialog

                  // Navigate to login page (replace 'LoginScreen()' with your login screen widget)
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const Loginscreen()),
                  );
                } catch (e) {
                  // Error handling
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error logging out: $e")),
                  );
                }
              },
              child: const Text('Yes', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    }

    void showsheet() {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Wrap(
            children: [
              ListTile(
                onTap: () {},
                leading: const Icon(Iconsax.setting),
                title: const Text('Settings'),
              ),
              ListTile(
                onTap: () {},
                leading: const Icon(Iconsax.edit),
                title: const Text('Edit Profile'),
              ),
              ListTile(
                onTap: () {
                  logout();
                },
                leading: const Icon(Iconsax.logout),
                title: const Text('Log Out'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                logout();
              },
              icon: const Icon(Iconsax.add_square4)),
          IconButton(
              onPressed: () => showsheet(),
              icon: const Icon(Icons.menu_rounded))
        ],
        title: Text(username),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.transparent),
              currentAccountPicture: GestureDetector(
                onLongPress: () {
                  _pickimage();
                },
                child: CachedNetworkImage(
                  imageUrl: urld, // URL for the profile image
                  placeholder: (context, url) => const CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/icon.png'), // Default placeholder
                    child: Icon(Iconsax.activity),
                  ),
                  errorWidget: (context, url, error) => const CircleAvatar(
                    backgroundImage: AssetImage(
                        'assets/icon.png'), // Fallback if error occurs
                    child: Icon(Icons.error),
                  ),
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    backgroundImage: imageProvider, // Show the cached image
                  ),
                ),
              ),
              accountName: Text(
                _user.currentUser!.email.toString(),
                style: const TextStyle(color: Colors.black),
              ),
              accountEmail: const Row(
                children: [
                  Text('Following', style: TextStyle(color: Colors.black)),
                  SizedBox(width: 16),
                  Text('Followers', style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            const Text(
              'All Posts',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Posts')
                  .where('userid', isEqualTo: uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong.'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('You have no posts.'));
                }

                return Expanded(
                  child: ListView(
                    children: snapshot.data!.docs.map((mypost) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(children: [
                            Stack(children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(urld),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 50),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(width: 10),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            mypost['email'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            mypost['name'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w200),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(mypost['content']),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CommentScreen(
                                                          postId: mypost.id),
                                                ),
                                              );
                                            },
                                            child: const Icon(Iconsax.message,
                                                size: 18),
                                          ),
                                          const Icon(Icons.auto_graph,
                                              size: 18),
                                          const Icon(Iconsax.bookmark,
                                              size: 18),
                                          const Icon(Icons.share_rounded,
                                              size: 18),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                            const Divider()
                          ]),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
