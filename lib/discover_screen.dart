import 'package:flutter/material.dart';
import 'package:travel_app/detail_screen.dart';
import 'package:travel_app/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  // Firebase instances
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<Map<String, String>> allDestinations = [
    {"id": "1", "image": "assets/images/travel4.jpg", "title": "Nusa Penida", "location": "Bali, Indonesia", "category": "Beach"},
    {"id": "2", "image": "assets/images/travel6.jpg", "title": "Haathim Beach", "location": "Maldives", "category": "Beach"},
    {"id": "3", "image": "assets/images/travel5.jpg", "title": "Turquoise Bay", "location": "Australia", "category": "Beach"},
    {"id": "4", "image": "assets/images/travel3.jpg", "title": "Patnem Beach", "location": "Goa, India", "category": "Beach"},
    {"id": "5", "image": "assets/images/travel7.jpg", "title": "Santorini", "location": "Greece", "category": "City"},
    {"id": "6", "image": "assets/images/travel8.jpg", "title": "Swiss Alps", "location": "Switzerland", "category": "Mountain"},
    {"id": "7", "image": "assets/images/travel9.jpg", "title": "Banff", "location": "Canada", "category": "Mountain"},
    {"id": "8", "image": "assets/images/travel10.jpg", "title": "Kyoto Temples", "location": "Japan", "category": "Temple"},
    {"id": "9", "image": "assets/images/travel11.jpg", "title": "New York City", "location": "USA", "category": "City"},
    {"id": "10", "image": "assets/images/travel12.jpg", "title": "Angkor Wat", "location": "Cambodia", "category": "Temple"},
    {"id": "11", "image": "assets/images/travel13.jpg", "title": "Paris", "location": "France", "category": "City"},
  ];

  @override
  void initState() {
    super.initState();
    _initializeFirebaseData();
  }

  // Initialize Firebase data
  Future<void> _initializeFirebaseData() async {
    try {
      // Upload destinations to Firestore if not already present
      final destinationsSnapshot = await _firestore.collection('destinations').get();

      if (destinationsSnapshot.docs.isEmpty) {
        for (var destination in allDestinations) {
          // Use the id from the map as the document ID
          await _firestore.collection('destinations').doc(destination['id']).set({
            'title': destination['title'],
            'image': destination['image'],
            'location': destination['location'],
            'category': destination['category'],
          });
        }
      }
    } catch (e) {
      debugPrint('Error initializing Firebase data: $e');
    }
  }

  // Save favorite to Firebase
  Future<void> _saveFavoriteToFirebase(Map<String, String> destination, bool isFavorite) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final favoriteRef = _firestore
            .collection('users')
            .doc(user.uid)
            .collection('favorites')
            .doc(destination['id']);

        if (isFavorite) {
          await favoriteRef.set({
            'id': destination['id'] ?? '',
            'title': destination['title'] ?? '',
            'image': destination['image'] ?? '',
            'location': destination['location'] ?? '',
            'category': destination['category'] ?? '',
            'timestamp': FieldValue.serverTimestamp(),
          });
        } else {
          await favoriteRef.delete();
        }
      }
    } catch (e) {
      debugPrint('Error saving favorite: $e');
    }
  }

  // Log user activity to Firebase
  Future<void> _logUserActivity(String activity, Map<String, dynamic> data) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('user_activity').add({
          'userId': user.uid,
          'activity': activity,
          'data': data,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      debugPrint('Error logging activity: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter by category
    var filteredDestinations = selectedCategory == "All"
        ? allDestinations
        : allDestinations.where((d) => d["category"] == selectedCategory).toList();

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      filteredDestinations = filteredDestinations.where((d) {
        final title = d["title"]?.toLowerCase() ?? "";
        final location = d["location"]?.toLowerCase() ?? "";
        final query = searchQuery.toLowerCase();
        return title.contains(query) || location.contains(query);
      }).toList();
    }

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

              if (filteredDestinations.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Text(
                      "No destinations found 🔍",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                )
              else
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
                    "Travel far, explore often, and live fully.",
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
        // Log category selection to Firebase
        _logUserActivity('category_selected', {'category': label});
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
        // Log destination view to Firebase
        _logUserActivity('destination_viewed', {
          'id': item['id'],
          'title': item['title'],
          'location': item['location'],
          'category': item['category'],
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              id: item["id"]!,
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
                onTap: () {
                  widget.onFavoriteToggle(item);
                  // Save favorite status to Firebase
                  _saveFavoriteToFirebase(item, !isFav);
                  _logUserActivity('favorite_toggled', {
                    'id': item['id'],
                    'title': item['title'],
                    'isFavorite': !isFav,
                  });
                },
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