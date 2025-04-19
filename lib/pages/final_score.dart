
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';
import 'player_profile.dart';
import 'package:flutter/gestures.dart';

class FinalScorePage extends StatefulWidget {
  final int matchId;

  const FinalScorePage({super.key, required this.matchId});

  @override
  State<FinalScorePage> createState() => _FinalScorePageState();
}

class _FinalScorePageState extends State<FinalScorePage> {
  Map<String, dynamic>? matchData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMatchStats();
  }

  Future<void> fetchMatchStats() async {
    final url = Uri.parse('${AppConfig.baseUrl}/match_stats/${widget.matchId}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        matchData = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || matchData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final home = matchData!['home'];
    final away = matchData!['away'];
    final homeGoals = matchData!['home_goals'] ?? [];
    final awayGoals = matchData!['away_goals'] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFF1C1432),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1432),
        title: const Text('Final Score'),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.network(
                  '${AppConfig.baseUrl}/images/${matchData!['logo_home']}',
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, color: Colors.white, size: 48),
                ),
                Column(
                  children: [
                    const Text('Full Time', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      '${matchData!['score_home']} - ${matchData!['score_away']}',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                Image.network(
                  '${AppConfig.baseUrl}/images/${matchData!['logo_away']}',
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, color: Colors.white, size: 48),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "${matchData!['team_home']} vs ${matchData!['team_away']}",
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 8),
            if (homeGoals.isNotEmpty || awayGoals.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text.rich(
                  TextSpan(
                    children: [
                      ...homeGoals.map<InlineSpan>((g) => _goalSpan(g)).toList(),
                      ...awayGoals.map<InlineSpan>((g) => _goalSpan(g)).toList(),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 20),
            Divider(color: Colors.white24),
            const SizedBox(height: 10),
            const Text(
              "Statistic Match",
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildStatRow('Shoot', home['shots'], away['shots']),
            _buildStatRow('On Target', home['shots_on_target'], away['shots_on_target']),
            _buildStatRow('Possession', "${home['ball_possession']}%", "${away['ball_possession']}%"),
            _buildStatRow('Pass', home['passes'], away['passes']),
            _buildStatRow('Accuracy', "${home['pass_accuracy']}%", "${away['pass_accuracy']}%"),
            _buildStatRow('Foul', home['fouls'], away['fouls']),
            _buildStatRow('Yellow Card', home['yellow_cards'], away['yellow_cards']),
            _buildStatRow('Red Card', home['red_cards'], away['red_cards']),
            _buildStatRow('Offside', home['offsides'], away['offsides']),
            _buildStatRow('Corner Kick', home['corners'], away['corners']),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, dynamic homeValue, dynamic awayValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$homeValue", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text("$awayValue", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  TextSpan _goalSpan(dynamic goal) {
    final goalText = goal['text']; // e.g. "Kylian Mbappé 14'"
    final playerId = goal['player_id'];

    return TextSpan(
      text: "$goalText, ",
      style: const TextStyle(color: Colors.white),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PlayerProfilePage(playerId: playerId),
            ),
          );
        },
    );
  }
}
