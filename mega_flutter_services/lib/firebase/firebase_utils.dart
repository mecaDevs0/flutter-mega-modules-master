import 'package:firebase_core/firebase_core.dart';

class FirebaseUtils {
  static Future<void> configure() async {
    await Firebase.initializeApp();
  }
}
