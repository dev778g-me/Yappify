import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconsax/iconsax.dart';
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
      bottomNavigationBar: Container(
        color: Colors.deepPurple.shade50,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: GNav(
              padding: const EdgeInsets.all(14),
              tabBackgroundColor: Colors.deepPurple.shade100,
              backgroundColor: Colors.deepPurple.shade50,
              color: Colors.black,
              activeColor: Colors.deepPurple,
              gap: 5,
              style: GnavStyle.google,
              selectedIndex: currentindex,
              onTabChange: (value) {
                setState(() {
                  currentindex = value;
                });
              },
              tabs: const [
                GButton(
                  icon: Iconsax.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Iconsax.search_normal,
                  text: 'Search',
                ),
                GButton(
                  icon: Iconsax.notification_favorite,
                  text: 'Notification',
                ),
                GButton(
                  icon: Iconsax.personalcard,
                  text: 'Profile',
                ),
              ]),
        ),
      ),
      //
      // NavigationBar(
      //     labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      //     selectedIndex: currentindex,
      //     elevation: 0,
      //     onDestinationSelected: (value) {
      //       HapticFeedback.lightImpact();
      //       setState(() {
      //         currentindex = value;
      //       });
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
