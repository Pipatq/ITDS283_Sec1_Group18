import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';

class PlayerProfilePage extends StatefulWidget {
  final int playerId;

  const PlayerProfilePage({super.key, required this.playerId});

  @override
  State<PlayerProfilePage> createState() => _PlayerProfilePageState();
}

class _PlayerProfilePageState extends State<PlayerProfilePage> {
  Map<String, dynamic>? player;
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    fetchPlayer();
  }

  Future<void> fetchPlayer() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    final url = Uri.parse('${AppConfig.baseUrl}/player_by_id/${widget.playerId}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          player = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (isError || player == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 48),
              const SizedBox(height: 12),
              const Text("Failed to load player profile", style: TextStyle(color: Colors.white)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: fetchPlayer,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                child: const Text("Retry", style: TextStyle(color: Colors.purple)),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1C1432),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1432),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Player Profile", style: TextStyle(color: Colors.white)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
Container(
  height: 180,
  decoration: const BoxDecoration(
    color: Color(0xFF1C1432),
  ),
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left Side: Logo + Name + Bio
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              "${AppConfig.baseUrl}/images/${player!['team_logo']}",
              height: 32,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              player!['name'] ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              player!['bio'] ?? 'Professional Football Player',
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
          ],
        ),

        // Right Side: Player photo
        Image.network(
          "${AppConfig.baseUrl}/images/${player!['photo']}",
          height: 100,
          width: 100,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image, size: 64, color: Colors.white),
        ),
      ],
    ),
  ),
),

            // Stats box
            Container(
              decoration: const BoxDecoration(
                color: Colors.white ,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.only(top: 20, bottom: 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      StatBox(number: '${player!['games'] ?? '-'}', label: 'Game'),
                      StatBox(number: '${player!['minutes'] ?? '-'}', label: 'Minutes'),
                      StatBox(number: '${player!['goals'] ?? '-'}', label: 'Goal'),
                      StatBox(number: '${player!['assists'] ?? '-'}', label: 'Assists'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Physical Parameters
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    alignment: Alignment.centerLeft,
                    child: const Text("Physical Parameters",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InfoBox(title: "${player!['height']}m", subtitle: "Height"),
                      InfoBox(title: "${player!['weight']}kg", subtitle: "Weight"),
                      InfoBox(title: "${player!['age']} Yr", subtitle: "Age"),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Biography
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    alignment: Alignment.centerLeft,
                    child: const Text("Biography",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      player!['biography'],
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class StatBox extends StatelessWidget {
  final String number;
  final String label;

  const StatBox({super.key, required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(number,
            style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.black54)),
      ],
    );
  }
}

class InfoBox extends StatelessWidget {
  final String title;
  final String subtitle;

  const InfoBox({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}
