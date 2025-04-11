import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';

class TournamentSchedule extends StatefulWidget {
  const TournamentSchedule({super.key});

  @override
  State<TournamentSchedule> createState() => _TournamentSchedulePageState();
}

class _TournamentSchedulePageState extends State<TournamentSchedule> {
  Future<List<dynamic>> fetchMatches() async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}/matches'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load matches');
    }
  }

  List<dynamic> filterNext3DaysMatches(List<dynamic> allMatches) {
    final now = DateTime.now();
    final end = now.add(const Duration(days: 3));
    return allMatches.where((match) {
      final date = DateTime.tryParse(match['match_date'] ?? '');
      return date != null &&
          date.isAfter(now.subtract(const Duration(days: 1))) &&
          date.isBefore(end);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Premier League'),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchMatches(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final matches = filterNext3DaysMatches(snapshot.data!);

          if (matches.isEmpty) {
            return const Center(child: Text("No matches scheduled"));
          }

          final featured = matches.first;

          return SingleChildScrollView(
            child: Column(
              children: [
                // ---------- Featured match (Top Card) ----------
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4)
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text('Lorem ipsum',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Week ${featured['week']}'),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                    '${AppConfig.baseUrl}/images/${featured['team_home_logo']}'),
                              ),
                              const SizedBox(height: 4),
                              Text('${featured['team_home_name']}'),
                              const Text('Home',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey)),
                            ],
                          ),
                          Text(
                            '${featured['score_home']} : ${featured['score_away']}',
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                    '${AppConfig.baseUrl}/images/${featured['team_away_logo']}'),
                              ),
                              const SizedBox(height: 4),
                              Text('${featured['team_away_name']}'),
                              const Text('Away',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ---------- Match List ----------
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: matches.length,
                  itemBuilder: (context, index) {
                    final match = matches[index];
                    return Container(
                      margin:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 3)
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.deepPurple.shade100,
                            radius: 18,
                            backgroundImage: NetworkImage(
                                '${AppConfig.baseUrl}/images/${match['team_home_logo']}'),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(match['team_home_name'],
                                style: const TextStyle(fontWeight: FontWeight.w600)),
                          ),
                          Text(match['match_time'],
                              style: const TextStyle(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold)),
                          Expanded(
                            child: Text(match['team_away_name'],
                                textAlign: TextAlign.end,
                                style: const TextStyle(fontWeight: FontWeight.w600)),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            backgroundColor: Colors.deepPurple.shade100,
                            radius: 18,
                            backgroundImage: NetworkImage(
                                '${AppConfig.baseUrl}/images/${match['team_away_logo']}'),
                          ),
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
