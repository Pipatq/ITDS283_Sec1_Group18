import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/standing_page.dart';
import 'pages/tournament_schedule.dart';
import 'pages/feed_news.dart';
import 'pages/add_news.dart';
void main() {
  runApp(const MatchScoreApp());
}

class MatchScoreApp extends StatelessWidget {
  const MatchScoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Match Score',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      routes: {
        '/tournament_schedule': (context) => const TournamentSchedule(),
        '/add_news': (context) => const AddNewsPage(),
      },
      home: const MainNavigation(),
      
    );
  }
}

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  void _onItemTapped(BuildContext context, int index) {
    if (index == 0) 
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigation()),
        );
    ; // Home is already on screen
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StandingPage()),
      );
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FeedNews()),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const HomePage(),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.black54,
        onTap: (index) => _onItemTapped(context, index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}
