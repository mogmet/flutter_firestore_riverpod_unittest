import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firestore_unittest/providers.dart';
import 'package:flutter_firestore_unittest/user.dart' as app;
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class AUserRepository {
  Future<app.User?> fetchUser(String authId);

  Future<app.User> createUser();
}

class UserRepository implements AUserRepository {
  UserRepository(Reader reader)
      : _firestore = reader(firebaseFirestoreProvider),
        _auth = reader(firebaseAuthProvider);
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference get _collection => _firestore.collection('users');

  DocumentReference _getUserReference(String authId) {
    return _collection.doc(authId);
  }

  @override
  Future<app.User?> fetchUser(String authId) async {
    final snapshot = await _getUserReference(authId).get();
    return app.User.fromSnapshot(snapshot);
  }

  @override
  Future<app.User> createUser() async {
    final authUser = await _auth.signInAnonymously();
    final authId = authUser.user?.uid ?? '';
    final user = app.User(authId: authId, username: 'ワンナイト人狼だいすキッズ');
    await _getUserReference(authId).set(user.toJson());
    return user;
  }
}
