import 'package:flutter/material.dart';

class myListtiile extends StatelessWidget {
  final IconData icon;
  final Text text;
  const myListtiile({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListTile(
      leading: Icon(icon),
      title: text,
    ));
  }
}
