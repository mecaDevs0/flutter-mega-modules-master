import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'google_user.dart';

class MegaGoogleSignIn {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<GoogleUser> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final googleAuthCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCredential =
        await _auth.signInWithCredential(googleAuthCredential);

    return GoogleUser(
      name: userCredential.user!.displayName!,
      email: userCredential.user!.email!,
      phone: userCredential.user!.phoneNumber!,
      photo: userCredential.user!.photoURL!,
      uid: userCredential.user!.uid,
    );
  }

  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
  }
}
