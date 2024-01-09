import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_journal/models/user_model.dart';

class UserWithCredentials extends UserModel{
  String? email;
  String? username;

  UserWithCredentials({required super.uid,  this.email,  this.username});

  static Future<UserWithCredentials?> fromMap(Object? documentData) {
    documentData as Map<String, dynamic>;
    return Future.value(UserWithCredentials(
      uid: documentData['uid'],
      email: documentData['email'],
      username: documentData['username'],
    ));
  }

  

  // static UserWithCredentials fromDocumentSnapshot(DocumentSnapshot<Object?> documentSnapshot) {}

  
}