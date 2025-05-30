import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/standing_page.dart';
import 'pages/tournament_schedule.dart';
import 'pages/feed_news.dart';
import 'pages/add_news.dart';
import 'pages/profile.dart';
// import 'pages/final_score.dart';
// import 'pages/player_profile.dart';
import 'splash_screen.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: const SplashScreen(), // default entry
    );
  }
}

// ✅ StatefulWidget เพื่อเปลี่ยนหน้าด้วย bottom nav
class MainNavigation extends StatefulWidget {
  final int startIndex;
  const MainNavigation({super.key, this.startIndex = 0}); // default = home

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _selectedIndex;

  final List<Widget> _pages = const [
    HomePage(),
    StandingPage(),
    FeedNews(),
    Profile(), // Profile page ที่เชื่อมกับ session
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.startIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.black54,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
