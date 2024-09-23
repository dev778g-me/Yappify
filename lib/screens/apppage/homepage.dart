import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:like_button/like_button.dart';
import 'package:social/screens/apppage/commentpage.dart';
import 'package:social/screens/apppage/postingscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final user = FirebaseAuth.instance.currentUser; // Current logged in user

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

  moreoption() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              title: Text('Delete Post'),
              leading: Icon(Iconsax.profile_delete),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
              },
              title: Text('Block User'),
              leading: Icon(Iconsax.text_block),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              onPressed: () {},
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
                      const CircleAvatar(
                        radius: 25,
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
                                Spacer(),
                                GestureDetector(
                                    onTap: () {
                                      moreoption();
                                    },
                                    child: Icon(Icons.more_vert))
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(posts['content']),
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
                                    child: Icon(
                                      Iconsax.message,
                                      size: 18,
                                    ),
                                  ),
                                  Icon(
                                    Icons.auto_graph,
                                    size: 18,
                                  ),
                                  Icon(
                                    Iconsax.bookmark,
                                    size: 18,
                                  ),
                                  Icon(
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
