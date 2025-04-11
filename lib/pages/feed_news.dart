import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';

class FeedNews extends StatefulWidget {
  const FeedNews({super.key});

  @override
  State<FeedNews> createState() => _FeedNewsState();
}

class _FeedNewsState extends State<FeedNews> {
  Future<List<dynamic>> fetchNews() async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}/news'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: FutureBuilder<List<dynamic>>(
          future: fetchNews(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final newsList = snapshot.data!;
            final topNews = newsList.first;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Center(
                    child: Text(
                      "News Feed",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),

                // Top Highlight News
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.deepPurple.shade900,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      Image.network(
                        '${AppConfig.baseUrl}/images/${topNews['image']}',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Text(
                          topNews['publish_date'].toString().split(" ").first,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              topNews['title'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "แนะนำข่าวสารเพิ่มเติม",
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Title "Today News"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Today News",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text("See all", style: TextStyle(color: Colors.purple)),
                    ],
                  ),
                ),

                // News list
                Expanded(
                  child: ListView.builder(
                    itemCount: newsList.length,
                    itemBuilder: (context, index) {
                      final news = newsList[index];
                      return NewsListTile(news: news);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class NewsListTile extends StatelessWidget {
  final dynamic news;

  const NewsListTile({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              '${AppConfig.baseUrl}/images/${news['image']}',
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news['title'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  news['publish_date'].toString().split(" ").first,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Icon(Icons.remove_red_eye, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text("3k", style: TextStyle(fontSize: 12)),
                    SizedBox(width: 12),
                    Icon(Icons.favorite, size: 16, color: Colors.red),
                    SizedBox(width: 4),
                    Text("2.2k", style: TextStyle(fontSize: 12)),
                    SizedBox(width: 12),
                    Icon(Icons.share, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text("1.4k", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
