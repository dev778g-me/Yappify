import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class Profilepage extends StatefulWidget {
  Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  final _user = FirebaseAuth.instance;

  String username = '';

  void selectimage() {}

  @override
  void initState() {
    super.initState();
    getusername();
  }

  void getusername() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(_user.currentUser!.uid)
        .get();
    print(snapshot.data());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    logout() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Log Out '),
          content: const Text('Are you sure you want to Log Out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'No',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );
    }

    showsheet() {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ListTile(
                  onTap: () {},
                  leading: const Icon(
                    Iconsax.setting,
                  ),
                  title: const Text('Settings'),
                ),
              ),
              ListTile(
                onTap: () {},
                leading: Icon(Iconsax.edit),
                title: Text('Edit Profile'),
              ),
              ListTile(
                onTap: () {
                  logout();
                },
                leading: Icon(Iconsax.logout),
                title: Text('Log Out'),
              )
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Iconsax.add_square4)),
          IconButton(
              onPressed: () {
                showsheet();
              },
              icon: const Icon(Icons.menu_rounded))
        ],
        title: Text('@${username}'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Colors.transparent),
                currentAccountPicture: const CircleAvatar(),
                accountName: Text(
                  _user.currentUser!.email.toString(),
                  style: const TextStyle(color: Colors.black),
                ),
                accountEmail: const Row(
                  children: [
                    Text(
                      'Following',
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      'Followers',
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                )),
            const Text(
              'All Posts',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            )
          ],
        ),
      ),
    );
  }
}
