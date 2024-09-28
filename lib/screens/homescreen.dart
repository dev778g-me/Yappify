import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:iconsax/iconsax.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:social/screens/apppage/homepage.dart';
import 'package:social/screens/apppage/noti.dart';
import 'package:social/screens/apppage/profilepage.dart';
import 'package:social/screens/apppage/searchpage.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

int currentindex = 0;
List pages = [
  const Homepage(),
  const Searchpage(),
  const Notipage(),
  Profilepage()
];

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
      bottomNavigationBar: SalomonBottomBar(
          currentIndex: currentindex,
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.deepPurple,
          onTap: (value) {
            //  HapticFeedback.lightImpact();
            setState(() {
              currentindex = value;
            });
          },
          items: [
            SalomonBottomBarItem(
                icon: const Icon(Iconsax.home), title: const Text('Home')),
            SalomonBottomBarItem(
                icon: const Icon(Iconsax.search_favorite),
                title: const Text('Search')),
            SalomonBottomBarItem(
                icon: const Icon(Iconsax.notification),
                title: const Text('Notification')),
            SalomonBottomBarItem(
                icon: const Icon(Iconsax.personalcard),
                title: const Text('Profile')),
          ]),
      //
      // NavigationBar(
      //     labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      //     selectedIndex: currentindex,
      //     elevation: 0,
      //     onDestinationSelected: (value) {
      //
      //     },
      //     destinations: const [
      //       NavigationDestination(icon: Icon(Iconsax.home_2), label: 'Home'),
      //       NavigationDestination(
      //           icon: Icon(Iconsax.search_normal), label: 'Search'),
      //       NavigationDestination(
      //           icon: Icon(Iconsax.personalcard), label: 'Profile'),
      //     ]),
      body: pages[currentindex],
    );
  }
}
