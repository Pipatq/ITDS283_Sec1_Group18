import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';
import 'tournament_schedule.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? avatarUrl;

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final avatar = prefs.getString('avatar');
    if (avatar != null) {
      setState(() {
        avatarUrl = avatar;
      });
    }
  }

  Future<List<dynamic>> fetchMatches() async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}/matches'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load matches');
    }
  }

  int selectedDateIndex = 0;
  final DateTime now = DateTime.now();

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String getTodayDateString() {
    final today = DateTime.now();
    return '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> dateOptions = [
      now,
      now.add(const Duration(days: 1)),
      now.add(const Duration(days: 2)),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Avatar Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  avatarUrl != null
                      ? CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: NetworkImage(avatarUrl!),
                          onBackgroundImageError: (_, __) =>
                              const Icon(Icons.error),
                        )
                      : const SizedBox(width: 40),
                  const Text(
                    'Match Score',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(width: 40),
                ],
              ),

              const SizedBox(height: 16),
              Row(
                children: List.generate(dateOptions.length, (index) {
                  return GestureDetector(
                    child: DateChip(
                      text: index == 0 ? 'Today' : formatDate(dateOptions[index]),
                      selected: index == selectedDateIndex,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              const Text("Live Match", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              FutureBuilder<List<dynamic>>(
                future: fetchMatches(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final today = getTodayDateString();
                  final todayMatches = snapshot.data!.where((m) => m['match_date'] == today).toList();

                  if (todayMatches.isEmpty) {
                    return const Text('No matches today', style: TextStyle(color: Colors.grey));
                  }

                  todayMatches.retainWhere((match) => match['status'] == 'live');
                  if (todayMatches.length > 3) {
                    todayMatches.removeRange(3, todayMatches.length);
                  }

                  return SizedBox(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: todayMatches.length,
                      itemBuilder: (context, index) {
                        final match = todayMatches[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: LiveMatchCard(
                            homeName: match['team_home_name'],
                            awayName: match['team_away_name'],
                            homeLogo: '${AppConfig.baseUrl}/images/${match['team_home_logo']}',
                            awayLogo: '${AppConfig.baseUrl}/images/${match['team_away_logo']}',
                            scoreHome: match['score_home'],
                            scoreAway: match['score_away'],
                            week: match['week'].toString(),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Matches", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/tournament_schedule');
                    },
                    child: const Text("See all", style: TextStyle(color: Colors.purple)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: fetchMatches(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    final today = getTodayDateString();
                    final todayMatches = snapshot.data!.where((m) => m['match_date'] == today).toList();

                    if (todayMatches.isEmpty) {
                      return const Center(
                        child: Text('No matches available', style: TextStyle(color: Colors.grey)),
                      );
                    }

                    return ListView.builder(
                      itemCount: todayMatches.length,
                      itemBuilder: (context, index) {
                        final match = todayMatches[index];
                        return MatchItem(
                          team1: match['team_home_name'],
                          team2: match['team_away_name'],
                          logo1: '${AppConfig.baseUrl}/images/${match['team_home_logo']}',
                          logo2: '${AppConfig.baseUrl}/images/${match['team_away_logo']}',
                          time: match['match_time'],
                          date: match['match_date'],
                        );
                      },
                    );
                  },
                ),
              ),
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
  final String homeName;
  final String awayName;
  final String homeLogo;
  final String awayLogo;
  final int scoreHome;
  final int scoreAway;
  final String week;

  const LiveMatchCard({
    super.key,
    required this.homeName,
    required this.awayName,
    required this.homeLogo,
    required this.awayLogo,
    required this.scoreHome,
    required this.scoreAway,
    required this.week,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TeamInfo(name: homeName, homeAway: "Home", logo: homeLogo),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Live Now", style: TextStyle(color: Colors.white70)),
              Text("Week $week", style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              Text("$scoreHome : $scoreAway", style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            ],
          ),
          TeamInfo(name: awayName, homeAway: "Away", logo: awayLogo),
        ],
      ),
    );
  }
}

class TeamInfo extends StatelessWidget {
  final String name;
  final String homeAway;
  final String logo;

  const TeamInfo({super.key, required this.name, required this.homeAway, required this.logo});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          child: ClipOval(
            child: Image.network(
              logo,
              height: 40,
              width: 40,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, color: Colors.white),
            ),
          ),
        ),
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
  final String? logo1;
  final String? logo2;

  const MatchItem({super.key, required this.team1, required this.team2, required this.time, required this.date, this.logo1, this.logo2});

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
          if (logo1 != null)
            CircleAvatar(
              radius: 14,
              backgroundColor: Colors.grey.shade200,
              child: ClipOval(
                child: Image.network(
                  logo1!,
                  height: 28,
                  width: 28,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 14),
                ),
              ),
            ),
          const SizedBox(width: 8),
          Expanded(flex: 3, child: Text(team1, style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(flex: 2, child: Center(child: Text(time))),
          Expanded(flex: 3, child: Text(team2, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.w600))),
          const SizedBox(width: 8),
          if (logo2 != null)
            CircleAvatar(
              radius: 14,
              backgroundColor: Colors.grey.shade200,
              child: ClipOval(
                child: Image.network(
                  logo2!,
                  height: 28,
                  width: 28,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 14),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
