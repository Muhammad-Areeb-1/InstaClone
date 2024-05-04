import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Adding image to firebase storage
  Future<String> uploadImageToStorage(String childName, Uint8List file, bool isPost) async {

    print('uploadImageToStorage');

    Reference ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);
    
    print('Storage reference created.'); // ........................................
    
    if (isPost) {
      String id = Uuid().v1();
      ref = ref.child(id);
    }

    print('isPost checked'); // ........................................

    UploadTask uploadTask = ref.putData(file);

    print('Got upload task'); // ........................................
    
    TaskSnapshot snap = await uploadTask;
    
    print('Got the snap'); // ........................................

    String downloadURL = await snap.ref.getDownloadURL();

    print('Got downloadURL'); // ........................................

    return downloadURL;
  }
}