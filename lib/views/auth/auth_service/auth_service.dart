import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. SIGN UP LOGIC (Auth + Firestore Data Save)
  Future<String?> signUpUser({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      // user register
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Firestore Database user details
      if (credential.user != null) {
        await _firestore.collection('users').doc(credential.user!.uid).set({
          'uid': credential.user!.uid,
          'fullName': fullName.trim(),
          'email': email.trim(),
          'phone': phone.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      return null; // Null means Success
    } on FirebaseAuthException catch (e) {
      return e.message; // Firebase Error Message
    } catch (e) {
      return e.toString();
    }
  }

  // 2. LOGIN LOGIC
  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // 3. LOGOUT LOGIC
  Future<void> signOut() async {
    await _auth.signOut();
  }
}