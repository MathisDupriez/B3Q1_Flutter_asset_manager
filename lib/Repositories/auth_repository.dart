import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository({FirebaseAuth? firebaseAuth}) 
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  /// Stream to listen to authentication state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Get the current authenticated user
  User? get currentUser => _firebaseAuth.currentUser;

  /// Sign up with email and password
  Future<User?> signUp({required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: _handleFirebaseAuthException(e));
    }
  }

  /// Sign in with email and password
  Future<User?> signIn({required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: _handleFirebaseAuthException(e));
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// Send a password reset email
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw AuthException(message: 'Failed to send password reset email');
    }
  }

  /// Update user profile information
  Future<void> updateUserProfile({String? displayName, String? photoURL}) async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.updateDisplayName(displayName);
        await user.updatePhotoURL(photoURL);
        await user.reload();
      }
    } catch (e) {
      throw AuthException(message: 'Failed to update user profile');
    }
  }

  /// Handle FirebaseAuth exceptions and return user-friendly messages
  String _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'This email address is already in use.';
      case 'weak-password':
        return 'The password is too weak.';
      default:
        return 'An unknown error occurred. Please try again.';
    }
  }
}

/// Custom exception class for authentication-related errors
class AuthException implements Exception {
  final String message;

  AuthException({required this.message});

  @override
  String toString() => message;
}
