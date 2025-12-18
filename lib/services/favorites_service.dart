import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesService {
  final user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add favorite
  Future<void> addFavorite(Map<String, String> item) async {
    await _db
        .collection("users")
        .doc(user!.uid)
        .collection("favorites")
        .doc(item["title"]) // title as ID
        .set(item);
  }

  // Remove favorite
  Future<void> removeFavorite(String title) async {
    await _db
        .collection("users")
        .doc(user!.uid)
        .collection("favorites")
        .doc(title)
        .delete();
  }

  // ✅ Live stream for favorites (returns QuerySnapshot)
  Stream<QuerySnapshot> favoriteStream() {
    return _db
        .collection("users")
        .doc(user!.uid)
        .collection("favorites")
        .snapshots();
  }

  // Check if favorite
  Future<bool> isFavorite(String title) async {
    var doc = await _db
        .collection("users")
        .doc(user!.uid)
        .collection("favorites")
        .doc(title)
        .get();
    return doc.exists;
  }
}