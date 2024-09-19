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
    );
  }
}
