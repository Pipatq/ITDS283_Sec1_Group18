import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';

class StandingPage extends StatefulWidget {
  const StandingPage({super.key});

  @override
  State<StandingPage> createState() => _StandingPageState();
}

class _StandingPageState extends State<StandingPage> {
  Future<List<dynamic>> fetchStandings() async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}/standings'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load standings');
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // -------- Top Match Result Card --------
            FutureBuilder<List<dynamic>>(
              future: fetchMatches(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || snapshot.data!.isEmpty) {
                  return const SizedBox.shrink();
                }

                final latest = snapshot.data!.last;

                return Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Text("Lorem ipsum",
                          style: TextStyle(color: Colors.white70)),
                      Text("Week ${latest['week']}",
                          style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                    '${AppConfig.baseUrl}/images/${latest['team_home_logo']}'),
                              ),
                              const SizedBox(height: 4),
                              Text('${latest['team_home_name']}',
                                  style: const TextStyle(color: Colors.white)),
                              const Text("Home",
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.white70)),
                            ],
                          ),
                          Text(
                            "${latest['score_home']} : ${latest['score_away']}",
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                    '${AppConfig.baseUrl}/images/${latest['team_away_logo']}'),
                              ),
                              const SizedBox(height: 4),
                              Text('${latest['team_away_name']}',
                                  style: const TextStyle(color: Colors.white)),
                              const Text("Away",
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.white70)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            // -------- Standings Table --------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Table Standings",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text("See All", style: TextStyle(color: Colors.purple)),
              ],
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF211A35),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Expanded(
                          flex: 3,
                          child: Text("Club",
                              style: TextStyle(color: Colors.white70))),
                      Expanded(
                          child: Text("W",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white70))),
                      Expanded(
                          child: Text("D",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white70))),
                      Expanded(
                          child: Text("L",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white70))),
                      Expanded(
                          child: Text("Poin",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white70))),
                    ],
                  ),
                  const Divider(color: Colors.white24),

                  // Standings List
                  FutureBuilder<List<dynamic>>(
                    future: fetchStandings(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox(height: 80);
                      }
                      final standings = snapshot.data!;
                      return Column(
                        children: standings.map((team) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 10,
                                        backgroundImage: NetworkImage(
                                            '${AppConfig.baseUrl}/images/${team['logo']}'),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(team['team_name'],
                                          style: const TextStyle(
                                              color: Colors.white)),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    child: Text('${team['wins']}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white))),
                                Expanded(
                                    child: Text('${team['draws']}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white))),
                                Expanded(
                                    child: Text('${team['losses']}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white))),
                                Expanded(
                                    child: Text('${team['points']}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white))),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),

                  const SizedBox(height: 12),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DotLegend(color: Colors.blue, text: "UEFA Champions league"),
                      DotLegend(color: Colors.orange, text: "Europa League"),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DotLegend extends StatelessWidget {
  final Color color;
  final String text;

  const DotLegend({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 4, backgroundColor: color),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }
}
