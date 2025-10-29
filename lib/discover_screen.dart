import 'package:flutter/material.dart';
import 'package:travel_app/detail_screen.dart';
import 'package:travel_app/profile_screen.dart';

class DiscoverScreen extends StatefulWidget {
  final Function(Map<String, String>) onFavoriteToggle;
  final List<Map<String, String>> favorites;

  const DiscoverScreen({
    super.key,
    required this.onFavoriteToggle,
    required this.favorites,
  });

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  String selectedCategory = "All";

  final List<Map<String, String>> allDestinations = [
    {"image": "assets/images/travel4.jpg", "title": "Nusa Penida", "location": "Bali, Indonesia", "category": "Beach"},
    {"image": "assets/images/travel6.jpg", "title": "Haathim Beach", "location": "Maldives", "category": "Beach"},
    {"image": "assets/images/travel5.jpg", "title": "Turquoise Bay", "location": "Australia", "category": "Beach"},
    {"image": "assets/images/travel3.jpg", "title": "Patnem Beach", "location": "Goa, India", "category": "Beach"},
    {"image": "assets/images/travel7.jpg", "title": "Santorini", "location": "Greece", "category": "City"},
    {"image": "assets/images/travel8.jpg", "title": "Swiss Alps", "location": "Switzerland", "category": "Mountain"},
    {"image": "assets/images/travel9.jpg", "title": "Banff", "location": "Canada", "category": "Mountain"},
    {"image": "assets/images/travel10.jpg", "title": "Kyoto Temples", "location": "Japan", "category": "Temple"},
    {"image": "assets/images/travel11.jpg", "title": "New York City", "location": "USA", "category": "City"},
    {"image": "assets/images/travel12.jpg", "title": "Angkor Wat", "location": "Cambodia", "category": "Temple"},
    {"image": "assets/images/travel13.jpg", "title": "Paris", "location": "France", "category": "City"},
  ];

  @override
  Widget build(BuildContext context) {
    final filteredDestinations = selectedCategory == "All"
        ? allDestinations
        : allDestinations.where((d) => d["category"] == selectedCategory).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Los Angeles, CA", style: TextStyle(color: Colors.grey, fontSize: 14)),
                      SizedBox(height: 6),
                      Text("Discover ",
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileScreen()),
                      );
                    },
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.black12,
                      child: Icon(Icons.notifications, color: Colors.black),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              TextField(
                decoration: InputDecoration(
                  hintText: "Search places",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: const Icon(Icons.filter_list),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    buildCategoryButton("All"),
                    const SizedBox(width: 8),
                    buildCategoryButton("Beach"),
                    const SizedBox(width: 8),
                    buildCategoryButton("Mountain"),
                    const SizedBox(width: 8),
                    buildCategoryButton("City"),
                    const SizedBox(width: 8),
                    buildCategoryButton("Temple"),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              Column(
                children: filteredDestinations.take(3).map((item) {
                  final isFav = widget.favorites.contains(item);
                  return buildDestinationCard(context, item, isFav, false);
                }).toList(),
              ),

              const SizedBox(height: 10),

              if (filteredDestinations.length > 3)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: filteredDestinations.skip(3).take(4).map((item) {
                      final isFav = widget.favorites.contains(item);
                      return buildDestinationCard(context, item, isFav, true);
                    }).toList(),
                  ),
                ),

              if (selectedCategory == "All") ...[
                const SizedBox(height: 25),
                const Center(
                  child: Text(
                    "“Travel far, explore often, and live fully.”",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 19, fontWeight: FontWeight.w700, color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 25),
                Column(
                  children: [
                    buildStackedCard("assets/images/travel12.jpg", "Angkor Wat"),
                    const SizedBox(height: 15),
                    buildStackedCard("assets/images/travel13.jpg", "Paris"),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCategoryButton(String label) {
    final selected = selectedCategory == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(color: selected ? Colors.white : Colors.black, fontSize: 13),
        ),
      ),
    );
  }

  Widget buildDestinationCard(
      BuildContext context, Map<String, String> item, bool isFav, bool isHorizontal) {
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
        margin: EdgeInsets.only(bottom: isHorizontal ? 0 : 15, right: isHorizontal ? 15 : 0),
        width: isHorizontal ? 160 : double.infinity,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(item["image"]!),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 15,
              left: 15,
              child: Text(
                "${item["title"]}\n${item["location"]}",
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () => widget.onFavoriteToggle(item),
                child: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStackedCard(String imagePath, String title) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          shadows: [Shadow(blurRadius: 10, color: Colors.black)],
        ),
      ),
    );
  }
}
