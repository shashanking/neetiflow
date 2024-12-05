import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';

@module
@Environment(Environment.prod)
abstract class FirebaseInjectableModule {
  @singleton
  @Named('firestore')
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  @singleton
  @Named('firebaseAuth')
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @singleton
  @Named('firebaseStorage')
  FirebaseStorage get firebaseStorage => FirebaseStorage.instance;
}
