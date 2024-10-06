import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/route_manager.dart';
import 'package:iconsax/iconsax.dart';
import 'package:like_button/like_button.dart';
import 'package:social/chat/mainchat.dart';
import 'package:social/screens/apppage/commentpage.dart';
import 'package:social/screens/apppage/postingscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social/screens/apppage/prof.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  final _auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser; // Current logged in user
  String username = '';
  // Function to toggle the like status
  Future<void> toggleLike(DocumentSnapshot post) async {
    final postRef = FirebaseFirestore.instance.collection('Posts').doc(post.id);
    final userId = user?.uid; // Get the current user ID

    if (post['liked by'].contains(userId)) {
      // Unlike: Remove user ID from likedBy list and decrement like count
      await postRef.update({
        'liked by': FieldValue.arrayRemove([userId]),
        'likes': FieldValue.increment(-1),
      });
    } else {
      // Like: Add user ID to likedBy list and increment like count
      await postRef.update({
        'liked by': FieldValue.arrayUnion([userId]),
        'likes': FieldValue.increment(1),
      });
    }
  }

  Future<void> getdata() async {
    if (user != null) {
      try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user!.uid)
            .get();
        if (snapshot.exists) {
          setState(() {
            username = snapshot['id'] ?? 'No name';
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

  fetchprofilepic(String userid) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userid)
          .get();
      if (snapshot.exists) {
        return snapshot['pfp'];
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> deletePost(String postId, String userid) async {
    try {
      print("Post ID to delete: $postId");
      print(userid);
      if (userid == _auth.currentUser!.uid) {
        await FirebaseFirestore.instance
            .collection('Posts')
            .doc(postId)
            .delete()
            .then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Post deleted successfully!'),
              duration:
                  Duration(seconds: 2), // Duration the snackbar stays on screen
              backgroundColor: Colors.green,
            ),
          );
        });
      } else {
        Get.snackbar('Error', 'Delete Your Own Post',
            backgroundColor: Colors.red.withOpacity(0.1),
            colorText: Colors.red,
            snackPosition: SnackPosition.TOP);
      }

      print("Post deleted successfully");
    } catch (e) {
      print("Failed to delete post: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    moreoption() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              ListTile(
                onTap: () {},
                title: Text('Delete Post'),
                leading: Icon(Iconsax.profile_delete),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                },
                title: const Text('Block User'),
                leading: const Icon(Iconsax.text_block),
              )
            ],
          );
        },
      );
    }

    return Scaffold(
      drawer: const Drawer(),
      floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          isExtended: false,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Postingscreen()));
          },
          child: const Icon(Iconsax.add)),
      appBar: AppBar(
        title: const Text('Yappify'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Postingscreen()));
              },
              icon: const Icon(
                Iconsax.add_square,
                color: Colors.black,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Iconsax.favorite_chart,
                color: Colors.black,
              )),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatScreen()));
              },
              icon: const Icon(
                Iconsax.message,
                color: Colors.black,
              ))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Posts')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
              children: snapshot.data!.docs.map((posts) {
            return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(children: [
                    Stack(children: [
                      FutureBuilder(
                        future: fetchprofilepic(posts['userid']),
                        builder: (context, AsyncSnapshot profilesnap) {
                          if (profilesnap.connectionState ==
                              ConnectionState.waiting) {
                            print('w');
                          }
                          if (profilesnap.hasError || !profilesnap.hasData) {
                            return const CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(
                                    'https://imgs.search.brave.com/xrUKEALaUur8Y1NVwGB0yzklRCFIYvh8-Ffrfx7R5Es/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9jZG4u/cGZwcy5nZy9wZnBz/LzUxODctY2F0LnBu/Zw'));
                          }

                          return GestureDetector(
                            onTap: () {
                              // Check if the post belongs to the logged-in user
                              if (user!.uid == posts['userid']) {
                                // Navigate to the user's profile page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Prof(), // Redirect to profile page
                                  ),
                                );
                              } else {
                                // Do nothing if the post doesn't belong to the current user
                                // Optionally, you can show a message or just keep it empty
                              }
                            },
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(profilesnap.data!),
                              radius: 25,
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    posts['email'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    posts['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w200),
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Wrap(
                                            children: [
                                              if (user!.uid ==
                                                  posts[
                                                      'userid']) // Show delete option only for post owner
                                                ListTile(
                                                  onTap: () {
                                                    print(posts['timestamp']);
                                                    deletePost(posts.id,
                                                        posts['userid']);
                                                    Navigator.of(context).pop();
                                                  },
                                                  title: const Text('Delete'),
                                                  leading:
                                                      const Icon(Icons.delete),
                                                ),
                                              ListTile(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                title: const Text('Block User'),
                                                leading: const Icon(
                                                    Iconsax.text_block),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Icon(Icons.more_vert))
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: SelectableText(posts['content']),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  // LikeButton widget with Firestore integration
                                  LikeButton(
                                    likeCount: posts['likes'],
                                    isLiked: posts['liked by'].contains(user
                                        ?.uid), // Check if the user has liked the post
                                    countPostion: CountPostion.right,
                                    size: 18,
                                    onTap: (isLiked) async {
                                      await toggleLike(posts);
                                      return !isLiked; // Return the new like state
                                    },
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CommentScreen(
                                                      postId: posts.id)));
                                    },
                                    child: const Icon(
                                      Iconsax.message,
                                      size: 18,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.auto_graph,
                                    size: 18,
                                  ),
                                  const Icon(
                                    Iconsax.bookmark,
                                    size: 18,
                                  ),
                                  const Icon(
                                    Icons.share_rounded,
                                    size: 18,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ]),
                    const Divider()
                  ]),
                ));
          }).toList());
        },
      ),
    );
  }
}
