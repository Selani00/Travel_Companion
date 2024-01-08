import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService{
  static String userIdKey = "USERIDKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userPicKey = "USERPICKEY";
  static String userDispalyNameKey = "USERDISPLAYNAMEKEY";

  Future<bool> saveUserId(String getuserId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userIdKey,getuserId);
  }

  Future<bool> saveUserName(String getuserName) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userNameKey,getuserName);
  }

  Future<bool> saveUserEmail(String getuserEmail) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userEmailKey,getuserEmail);
  }

  Future<bool> saveUserPic(String getuserPic) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userPicKey,getuserPic);
  } 

  Future<bool> saveUserDisplayName(String getuserDisplayName) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userDispalyNameKey,getuserDisplayName);
  }

  //get data

  Future<String?> getUserId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?> getUserName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  Future<String?> getUserEmail() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  Future<String?> getUserPic() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userPicKey);
  }

  Future<String?> getUserDisplayName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userDispalyNameKey);
  }

  


}