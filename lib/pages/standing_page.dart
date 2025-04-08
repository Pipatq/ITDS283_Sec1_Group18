import 'package:flutter/material.dart';

class StandingPage extends StatelessWidget {
  const StandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161022),
      appBar: AppBar(
        title: const Text("Standings", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          'Standing Page',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
