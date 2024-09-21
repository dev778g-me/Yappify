import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:social/screens/apppage/postingscreen.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          shape: CircleBorder(),
          isExtended: false,
          onPressed: () {
            Get.offAll(Postingscreen());
          },
          child: Icon(Iconsax.add)),
      appBar: AppBar(
        title: const Text('Yappify'),
        actions: [
          IconButton(
              onPressed: () {},
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
                      CircleAvatar(
                        radius: 25,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text(
                                    posts['email'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text(
                                    posts['name'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.w200),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(posts['content']),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(
                                    Icons.favorite_outline,
                                    size: 18,
                                  ),
                                  Icon(
                                    Iconsax.message,
                                    size: 18,
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
                    Divider()
                  ]),
                ));
          }).toList());
        },
      ),
    );
  }
}
