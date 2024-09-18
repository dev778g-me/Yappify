import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:iconsax/iconsax.dart';
import 'package:social/screens/apppage/homepage.dart';
import 'package:social/screens/apppage/profilepage.dart';
import 'package:social/screens/apppage/searchpage.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

int currentindex = 0;
List pages = [Homepage(), Searchpage(), Profilepage()];

class _HomescreenState extends State<Homescreen> {
  signout() async {
    FirebaseAuth.instance.signOut();
    Get.snackbar('Success', 'Logged Out Successfully',
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
        snackPosition: SnackPosition.TOP);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
          selectedIndex: currentindex,
          elevation: 0,
          onDestinationSelected: (value) {
            setState(() {
              currentindex = value;
            });
          },
          destinations: [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            NavigationDestination(
                icon: Icon(Iconsax.search_normal), label: 'Search'),
            NavigationDestination(
                icon: Icon(Iconsax.personalcard), label: 'Profile'),
          ]),
      body: pages[currentindex],
    );
  }
}
