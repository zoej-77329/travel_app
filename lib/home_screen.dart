import 'package:flutter/material.dart';
import 'discover_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Map<String, String>> favoriteDestinations = [];

  void toggleFavorite(Map<String, String> destination) {
    setState(() {
      if (favoriteDestinations.contains(destination)) {
        favoriteDestinations.remove(destination);
      } else {
        favoriteDestinations.add(destination);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      DiscoverScreen(onFavoriteToggle: toggleFavorite, favorites: favoriteDestinations),
      FavoritesScreen(favorites: favoriteDestinations),
      ProfileScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Discover"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }
}

