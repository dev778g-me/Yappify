import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:social/screens/apppage/commentpage.dart';

class Profilepage extends StatefulWidget {
  Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  final _user = FirebaseAuth.instance;
  String username = '';
  String uid = '';

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
        username =
            snapshot['username'] ?? ''; // Assuming 'username' is the field name
      });
    } catch (e) {
      print("Error fetching username: $e");
      // You might want to handle this with a Snackbar or similar UI feedback.
    }
  }

  void logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to Log Out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No', style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pop();
              // Optionally navigate to the login page
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
            Container(
              height: 15,
            ),
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
              onTap: () => logout(),
              leading: const Icon(Iconsax.logout),
              title: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
              currentAccountPicture: const CircleAvatar(
                  // Optionally add a network image or local asset here
                  // backgroundImage: AssetImage(
                  //     'assets/images/user_placeholder.png'), // Placeholder image
                  ),
              accountName: Text(
                _user.currentUser!.email.toString(),
                style: const TextStyle(color: Colors.black),
              ),
              accountEmail: const Row(
                children: [
                  Text('Following', style: TextStyle(color: Colors.black)),
                  SizedBox(width: 16),
                  Text('Followers', style: TextStyle(color: Colors.black))
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
                  //.orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  print("Error: ${snapshot.error}");
                  return const Center(child: Text('Something went wrong.'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('You have no posts.'));
                }

                // Debugging output
                print("Posts fetched: ${snapshot.data!.docs.length}");
                print(snapshot.data!.docs.map((doc) => doc.data()).toList());

                return Expanded(
                  child: ListView(
                    children: snapshot.data!.docs.map((mypost) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(children: [
                            Stack(children: [
                              const CircleAvatar(radius: 25),
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
