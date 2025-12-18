class Destination {
  final String id;
  final String title;
  final String image;
  final String location;

  Destination({
    required this.id,
    required this.title,
    required this.image,
    required this.location,
  });

  factory Destination.fromMap(String id, Map<String, dynamic> data) {
    return Destination(
      id: id,
      title: data["title"],
      image: data["image"],
      location: data["location"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "image": image,
      "location": location,
    };
  }
}
