import 'package:travel_journal/models/user_model.dart';

class UserWithCredentials extends UserModel{
  String? email;
  String? username;

  UserWithCredentials({required super.uid,  this.email,  this.username});

  
}