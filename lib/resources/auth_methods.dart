import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_clone/models/user.dart' as model;
import 'package:insta_clone/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    print(currentUser.uid);
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  // Sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occurred";

    print(
        'Will try to sign user up.'); // ........................................

    try {
      if (username.isNotEmpty ||
          email.isNotEmpty ||
          password.isNotEmpty ||
          bio.isNotEmpty) {

        print(
            'Trying to sign user up.'); // ........................................
        // Register User
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print('Signed user up.'); // ........................................

        print(cred.user!.uid);

        print('Uploading Profile pic.'); // ........................................

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);
        
        print(photoUrl); // ........................................

        print('Adding user to database'); // ........................................

        // Add user to database
        model.User user = model.User(
          email: email,
          uid: cred.user!.uid,
          username: username,
          photoUrl: photoUrl,
          bio: bio,
          followers: [],
          following: [],
        );

        print('Converted to user instance'); // ........................................

        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
        
        print('User added to firestore.'); // ........................................

        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    
    print(res); // ........................................
    
    return res;
  }

  // Logging user in
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured!";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
