import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userID;
  DateTime _expiryDate;
Timer _authTimer;
  String get userId{
    return _userID;
  }
  bool get isAuth{
    return token!=null;
    notifyListeners();
  }
  String get token{
    if(_expiryDate!=null&&_expiryDate.isAfter(DateTime.now())&&_token!=null){
      return _token;
      notifyListeners();
    }
    return null;
  }

  Future<void> _authenticate(String email,String password,String urlSegment)async{
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCFOMXRwzEm_WVDwPPBfyoiYH1gXr4ZMT8';
    try{
      final response=await http.post(url,
          body: jsonEncode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));
//      print(json.encode(response.body));

      final responseDate=json.decode(response.body);//decode not encode
      print(responseDate);
      if(responseDate["error"]!=null){
        print('in http exception');
throw HttpException(responseDate['error']['message']);
      }
      _token=responseDate['idToken'];
      _userID=responseDate['localId'];
      _expiryDate=DateTime.now().add(Duration(seconds: int.parse(responseDate['expiresIn'])));
//      _autoLogOut();
      notifyListeners();
    }catch(e){
     throw e;
    }
  }
  Future<void> singUp(String email, String password) async {
return _authenticate(email, password, 'signUp');
//her we put return because we have Future void and without return the app will not wait  not async
  }
  Future<void> login(String email,String password)async{
  return _authenticate(email, password, 'signInWithPassword');

  }
  void  logOut(){
    _token=null;
    _userID=null;
    _expiryDate=null;
    notifyListeners();
    if(_authTimer!=null){
      _authTimer.cancel();
      _authTimer=null;
    }
    notifyListeners();
  }
  void _autoLogOut(){
    if(_authTimer!=null){
      _authTimer.cancel();
    }
    final   timeToExpiry=_expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer=Timer(Duration(seconds: 3),logOut);
  }
}
