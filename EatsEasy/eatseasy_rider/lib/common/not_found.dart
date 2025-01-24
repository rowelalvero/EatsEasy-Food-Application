import 'package:flutter/material.dart';

import '../constants/constants.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key, this.text="Not found page"});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the back button color to white
        ),
        backgroundColor: kPrimary,
        title: const Text('Page Not Found', style: TextStyle(color: Colors.white),),
      ),
      body: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24, color: Colors.red),
        ),
      ),
    );
  }
}
