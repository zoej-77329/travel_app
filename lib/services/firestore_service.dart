// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/destination_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  // Stream of user's favorites as Destination objects (real-time)
  Stream<List<Destination>> getFavoritesStream() {
    final uid = _uid;
    if (uid == null) {
      // anonymous empty stream for not-logged-in state
      return const Stream<List<Destination>>.empty();
    }

    return _db
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .snapshots()
        .map((snap) => snap.docs
        .map((d) => Destination.fromMap(d.id, d.data()))
        .toList());
  }

  // Add destination to user's favorites (doc id = destination.id)
  Future<void> addFavorite(Destination dest) async {
    final uid = _uid;
    if (uid == null) throw Exception('No logged in user');

    await _db
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(dest.id)
        .set(dest.toMap());
  }

  // Remove favorite by destination id
  Future<void> removeFavorite(String destId) async {
    final uid = _uid;
    if (uid == null) throw Exception('No logged in user');

    await _db
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(destId)
        .delete();
  }

  // Utility: check quickly if a destination is favorited
  Future<bool> isFavorite(String destId) async {
    final uid = _uid;
    if (uid == null) return false;
    final doc = await _db
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(destId)
        .get();
    return doc.exists;
  }
}
