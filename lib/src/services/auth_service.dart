

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:productos_app/src/models/models.dart';
import 'package:productos_app/src/ui/pages/pages.dart';

class AuthService extends ChangeNotifier{
  Dio dio = Dio();

  final String _signUp = "https://identitytoolkit.googleapis.com";
  final String _signIn = "https://identitytoolkit.googleapis.com";
  final _firebaseToken = "AIzaSyD08T1aWCVYdlyIgxc9Q7EisTki5gRYwj0";
  final secureStorage  = const FlutterSecureStorage(); 
  bool _validating = false;

  bool _validEmail    = true;
  bool _validPassword = true;

  bool get validating => _validating;
  bool get validEmail => _validEmail;
  bool get validPassword => _validPassword;

  set validEmail(bool value){
    _validEmail = value;
    notifyListeners();
  }

  set validPassword(bool value){
    _validPassword = value;
    notifyListeners();
  }
  
  Future<String> signUp(NewUser newUser) async {
    try{
      _validating = true;
      notifyListeners();
      final request = await dio.post('$_signUp/v1/accounts:signUp', 
        data: jsonEncode(newUser.toMap()),
        queryParameters: {
        "key":_firebaseToken,
      });
      Auth authData = Auth.fromMap(request.data);
      await secureStorage.write(key: "id_token", value: authData.idToken);
      _validating = false;
      notifyListeners();
      return authData.idToken;
    } on DioError catch(e){
      AuthError authError =  AuthError.fromMap(e.response!.data['error']);
      _validating = false;
      notifyListeners();
      return authError.message;
    }
  }

  Future<String> signIn(User user) async {
    try{
      _validating = true;
      notifyListeners();
      final response = await dio.post('$_signIn/v1/accounts:signInWithPassword',
        data: jsonEncode(user.toMap()),
        queryParameters: {
          "key":_firebaseToken
        }
      );
      AuthLogin authLogin = AuthLogin.fromMap(response.data);
      _validating = false;
      notifyListeners();
      return authLogin.registered.toString();
      
    }on DioError catch(e){
      AuthError authError = AuthError.fromMap(e.response?.data['error']);
      _validating = false;
      notifyListeners();
      return authError.message;
    }
  }

  Future<bool> logOut() async {
    try{
      await secureStorage.delete(key: "id_token");
      return true;
    } on Exception catch(e){
      print("error trying to delete token $e ❌");
      return false;
    }
  } 
  Future<String> readToken() async => await secureStorage.read(key: "id_token") ?? 'no-token';
}