import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/entities/user_entity.dart';

class AuthRepositoryImpl {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential> loginWithPhonePassword(String phone, String password) async {
    final email = _phoneToEmail(phone);
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signUpWithPhonePassword(String fullName, String phone, String password) async {
    final email = _phoneToEmail(phone);
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    if (userCredential.user != null) {
      await _saveUserToFirestore(
        uid: userCredential.user!.uid,
        email: email,
        fullName: fullName,
        phone: phone,
        authProvider: 'phone_password',
      );
    }
    
    return userCredential;
  }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null; // Make sure the user didn't cancel the flow

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);

    if (userCredential.user != null) {
      // Check if user exists in Firestore, if not create them
      final doc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
      if (!doc.exists) {
        await _saveUserToFirestore(
          uid: userCredential.user!.uid,
          email: userCredential.user!.email ?? '',
          fullName: userCredential.user!.displayName ?? 'Google User',
          phone: userCredential.user!.phoneNumber ?? '',
          authProvider: 'google',
        );
      }
    }

    return userCredential;
  }

  Future<void> _saveUserToFirestore({
    required String uid,
    required String email,
    required String fullName,
    required String phone,
    required String authProvider,
  }) async {
    final user = UserEntity(
      uid: uid,
      email: email,
      fullName: fullName,
      phone: phone,
      authProvider: authProvider,
      role: 'user',
      description: '',
    );
    await _firestore.collection('users').doc(uid).set(user.toMap());
  }

  String _phoneToEmail(String phone) {
    // E.g. 1234567890 -> 1234567890@jikirapp.com
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    return '$cleanPhone@jikirapp.com';
  }
}
