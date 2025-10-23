import 'package:flutter/material.dart';
import 'home_screen.dart';

// 🧳 Booking Screen (Beginner-Friendly)
class BookingScreen extends StatelessWidget {
  final String destinationTitle;
  final String destinationImage;
  final String destinationLocation;

  const BookingScreen({
    Key? key,
    required this.destinationTitle,
    required this.destinationImage,
    required this.destinationLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 🌄 Background image
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(destinationImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          // Dark overlay for better text visibility
          color: Colors.black.withOpacity(0.4),
          child: Column(
            children: [
              const SizedBox(height: 50),

              // 🔙 Back button
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                ],
              ),

              // 🏞️ Destination title
              Text(
                destinationTitle,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // ✈️ Booking Form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Traveler Details",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Full Name Field
                      _buildTextField("Full Name"),
                      const SizedBox(height: 15),

                      // Email Field
                      _buildTextField("Email"),
                      const SizedBox(height: 15),

                      // Dates Row (From / To)
                      Row(
                        children: [
                          Expanded(child: _buildTextField("From")),
                          const SizedBox(width: 10),
                          Expanded(child: _buildTextField("To")),
                        ],
                      ),
                      const SizedBox(height: 15),

                      // Number of Travelers
                      _buildTextField("Number of Travelers"),
                      const SizedBox(height: 25),

                      // ✅ Confirm Booking Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingSuccessScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.tealAccent.shade700,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            "Confirm Booking",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
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
        ),
      ),
    );
  }

  // 🧩 Helper Method to Create Reusable Text Fields
  Widget _buildTextField(String label) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.black.withOpacity(0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// 🎉 Booking Success Screen (in the same file)
class BookingSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Background success image
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/success_bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.4),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: Colors.white, size: 100),
                  const SizedBox(height: 25),
                  const Text(
                    "Booking Confirmed!",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Your trip has been successfully booked.\nEnjoy your adventure!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 40),

                  // 🔙 Back to Home Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      "Back to Home",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
