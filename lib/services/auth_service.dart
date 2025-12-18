import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get currentUserId {
    return _auth.currentUser!.uid;
  }
}
