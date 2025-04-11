import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Match Score',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const MatchScoreHome(),
    );
  }
}

class MatchScoreHome extends StatelessWidget {
  const MatchScoreHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile & Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
                  ),
                  Text(
                    'Match Score',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(width: 40), // spacing
                ],
              ),
              const SizedBox(height: 16),

              // Date Selector
              Row(
                children: [
                  DateChip(text: 'Today', selected: true),
                  DateChip(text: '9/3/2025'),
                  DateChip(text: '10/3/2025'),
                ],
              ),
              const SizedBox(height: 20),

              // Live Match
              const Text("Live Match", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              LiveMatchCard(),

              const SizedBox(height: 20),

              // Matches List
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Matches", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("See all", style: TextStyle(color: Colors.purple)),
                ],
              ),
              const SizedBox(height: 12),
              MatchItem(team1: "Man City", team2: "Man U", time: "06:30", date: "08/3/2025"),
              MatchItem(team1: "Man City", team2: "Liverpool", time: "09:30", date: "09/3/2025"),
            ],
          ),
        ),
      ),
    );
  }
}

class DateChip extends StatelessWidget {
  final String text;
  final bool selected;

  const DateChip({super.key, required this.text, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.purple : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black87,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class LiveMatchCard extends StatelessWidget {
  const LiveMatchCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TeamInfo(name: "Real Madrid", homeAway: "Home"),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Lorem ipsum", style: TextStyle(color: Colors.white70)),
              Text("Week 10", style: TextStyle(color: Colors.white70)),
              SizedBox(height: 8),
              Text("3 : 0", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            ],
          ),
          TeamInfo(name: "Liverpool", homeAway: "Away"),
        ],
      ),
    );
  }
}

class TeamInfo extends StatelessWidget {
  final String name;
  final String homeAway;

  const TeamInfo({super.key, required this.name, required this.homeAway});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircleAvatar(radius: 20, backgroundImage: NetworkImage('https://upload.wikimedia.org/wikipedia/en/5/56/Real_Madrid_CF.svg')),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(color: Colors.white, fontSize: 12)),
        Text(homeAway, style: const TextStyle(color: Colors.white70, fontSize: 10)),
      ],
    );
  }
}

class MatchItem extends StatelessWidget {
  final String team1;
  final String team2;
  final String time;
  final String date;

  const MatchItem({
    super.key,
    required this.team1,
    required this.team2,
    required this.time,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(team1, style: const TextStyle(fontWeight: FontWeight.w600)),
          const Spacer(),
          Text(time),
          const Spacer(),
          Text(team2, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
