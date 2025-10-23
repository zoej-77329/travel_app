class Destination {
  final String name;
  final String location;
  final String imageUrl;
  final String description;
  bool isFavorite;

  Destination({
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.description,
    this.isFavorite = false,
  });

  void toggleFavorite() {
    isFavorite = !isFavorite;
  }
}

List<Destination> destinations = [
  Destination(
    name: "La Costa",
    location: "Peru, South America",
    imageUrl: "assets/images/travel2.jpg",
    description: "Explore the sunny coasts of Peru with stunning beaches and beautiful sunsets.",
  ),
  Destination(
    name: "Rio De Janeiro",
    location: "Brazil, South America",
    imageUrl: "assets/images/travel3.jpg",
    description: "A vibrant city surrounded by mountains and famous beaches like Copacabana.",
  ),
  Destination(
    name: "Nusa Penida",
    location: "Bali, Indonesia",
    imageUrl: "assets/images/travel4.jpg",
    description: "An island paradise with clear blue water and breathtaking cliffs.",
  ),
  Destination(
    name: "Vestrahorn",
    location: "Iceland, Europe",
    imageUrl: "assets/images/travel5.jpg",
    description: "A dramatic mountain landscape in Iceland, perfect for adventure seekers.",
  ),
  Destination(
    name: "Haathim Beach",
    location: "Maldives",
    imageUrl: "assets/images/travel6.jpg",
    description: "Turquoise water, white sand, and peaceful tropical vibes await you here.",
  ),
];
