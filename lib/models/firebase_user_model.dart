import 'package:travel_journal/models/user_model.dart';

class FireStoreUser extends UserModel{
  String? email;
  String? username;

  FireStoreUser({required super.uid,  this.email,  this.username});

  static Future<FireStoreUser ?> fromMap(Object? documentData) {
    documentData as Map<String, dynamic>;
    return Future.value(FireStoreUser(
      uid: documentData['uid'],
      email: documentData['email'],
      username: documentData['username'],
    ));
  }

  

  // static UserWithCredentials fromDocumentSnapshot(DocumentSnapshot<Object?> documentSnapshot) {}

  
}