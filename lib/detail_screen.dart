import 'package:flutter/material.dart';
import 'booking_screen.dart';

class DetailScreen extends StatelessWidget {
  final String title;
  final String image;
  final String location;

  const DetailScreen({
    super.key,
    required this.title,
    required this.image,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌄 Background Image of destination
          Image.asset(
            image,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          // 🌫 Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [Colors.black.withOpacity(0.7), Colors.transparent],
              ),
            ),
          ),

          // 🔙 Back and ❤️ Favorite Buttons
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const Positioned(
            top: 40,
            right: 20,
            child: Icon(Icons.favorite_border, color: Colors.white, size: 28),
          ),

          // 🏖 Destination Details at Bottom
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Location
                  Text(
                    location,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Rating and Info Row
                  Row(
                    children: const [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      SizedBox(width: 5),
                      Text(
                        "4.8  •  22°C  •  7 Days",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Description
                  Text(
                    "Explore this beautiful location surrounded by natural landscapes, beaches, and unique culture. Perfect destination for relaxation and adventure.",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      height: 1.5,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 25),

                  // 🟢 Book Now Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingScreen(
                              // 👇 Now passes destination image to use as background
                              destinationTitle: title,
                              destinationImage: image,
                              destinationLocation: location,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 4,
                        shadowColor: Colors.tealAccent,
                      ),
                      child: const Text(
                        "Book Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
