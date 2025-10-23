import 'package:flutter/material.dart';
import 'package:travel_app/detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Map<String, String>> favorites;

  const FavoritesScreen({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Favorite Destinations", style: TextStyle(color: Colors.black)),
      ),
      body: favorites.isEmpty
          ? const Center(child: Text("No favorites yet"))
          : ListView.builder(
        itemCount: favorites.length,
        padding: const EdgeInsets.all(15),
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
              padding: const EdgeInsets.all(15),
              child: Text(
                "${item["title"]}\n${item["location"]}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
