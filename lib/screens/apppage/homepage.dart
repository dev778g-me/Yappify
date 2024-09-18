import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        shadowColor: Colors.black,
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
