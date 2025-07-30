import 'dart:developer' as developer;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'google_user.dart';

class MegaGoogleSignIn {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );

  Future<GoogleUser> signInWithGoogle() async {
    developer.log('Starting Google Sign-In process...', name: 'MegaGoogleSignIn');
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        developer.log('Google Sign-In was cancelled by the user.', name: 'MegaGoogleSignIn');
        throw Exception('Login com Google cancelado pelo usuário.');
      }

      developer.log('Google user obtained: \${googleUser.email}', name: 'MegaGoogleSignIn');

      if (googleUser.email == null) {
        developer.log('Google user email is null. Aborting.', name: 'MegaGoogleSignIn');
        throw Exception('Não foi possível obter o e-mail da sua conta Google.');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      developer.log('Fetching sign-in methods for \${googleUser.email}...', name: 'MegaGoogleSignIn');
      final List<String> signInMethods =
          await _auth.fetchSignInMethodsForEmail(googleUser.email);

      UserCredential userCredential;
      if (signInMethods.isNotEmpty) {
        developer.log('User exists. Signing in with credential.', name: 'MegaGoogleSignIn');
        userCredential = await _auth.signInWithCredential(credential);
      } else {
        developer.log('User does not exist. Creating new user with credential.', name: 'MegaGoogleSignIn');
        userCredential = await _auth.signInWithCredential(credential);
        developer.log('New user created. UID: \${userCredential.user?.uid}', name: 'MegaGoogleSignIn');
        // A subsequent API call should be made to the backend here to register the user profile.
        // This ensures data integrity across the Meca ecosystem.
        // Example:
        // await _registerUserOnBackend(userCredential.user);
      }

      final User user = userCredential.user!;
      developer.log('Sign-in successful. UID: \${user.uid}', name: 'MegaGoogleSignIn');

      return GoogleUser(
        name: user.displayName ?? '',
        email: user.email ?? '',
        phone: user.phoneNumber ?? '',
        photo: user.photoURL ?? '',
        uid: user.uid,
      );
    } on FirebaseAuthException catch (e) {
      developer.log('FirebaseAuthException: \${e.code} - \${e.message}', name: 'MegaGoogleSignIn');
      // Re-throw a more user-friendly exception or handle it.
      throw Exception('Erro de autenticação: \${e.message}');
    } catch (e) {
      developer.log('An unexpected error occurred: $e', name: 'MegaGoogleSignIn');
      // Re-throw the exception to be handled by the caller.
      rethrow;
    }
  }

  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
    developer.log('User signed out from Google.', name: 'MegaGoogleSignIn');
  }
}
