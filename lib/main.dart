import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_text_fields/theme/material_text_field_theme.dart';
import 'package:social/screens/homescreen.dart';

import 'package:social/screens/wrapper.dart';

void main() async {
  await WidgetsFlutterBinding();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Social',
        theme: ThemeData(
          inputDecorationTheme: FilledOrOutlinedTextTheme(
            radius: 8,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            errorStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            fillColor: Colors.transparent,
            prefixIconColor: Colors.black,
            enabledColor: Colors.grey,
            focusedColor: Colors.blue,
            floatingLabelStyle: const TextStyle(color: Colors.green),
            width: 1.5,
            labelStyle: const TextStyle(fontSize: 16, color: Colors.black),
          ),
          fontFamily: GoogleFonts.dmSans().fontFamily,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Wrapper());
  }
}
