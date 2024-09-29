import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class Chatroom extends StatefulWidget {
  const Chatroom({super.key});

  @override
  State<Chatroom> createState() => _ChatroomState();
}

class _ChatroomState extends State<Chatroom> {
  final TextEditingController _messageController = TextEditingController();
  List<String> _messages = []; // List to store messages

  void _sendMessage() {
    String message = _messageController.text;
    if (message.isNotEmpty) {
      setState(() {
        _messages.add(message); // Add message to the list
      });
      _messageController.clear(); // Clear the text field after sending
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index]), // Display each message
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                    ),
                    onSubmitted: (value) {
                      _sendMessage(); // Send message on enter
                    },
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: Icon(Iconsax.send_1),
                ),
              ],
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset:
          true, // Ensure the layout adjusts when the keyboard is open
    );
  }
}
