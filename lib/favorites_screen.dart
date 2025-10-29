import 'package:flutter/material.dart';
import 'package:travel_app/detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Map<String, String>> favorites;

  const FavoritesScreen({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
          shadowColor: Colors.black.withOpacity(0.05),
          centerTitle: true,
        title: const Text("Favorite Destinations", style: TextStyle(color: Colors.black)),
      ),
      body: favorites.isEmpty
          ? const Center(child: Text("No favorites yet 💔",
        style: TextStyle(fontSize: 18, color: Colors.grey),))
          : ListView.builder(
        itemCount: favorites.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final item = favorites[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(
                    title: item["title"]!,
                    image: item["image"]!,
                    location: item["location"]!,
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 15),
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage(item["image"]!),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item["title"] ?? "",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(blurRadius: 6, color: Colors.black45),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        item["location"] ?? "",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
