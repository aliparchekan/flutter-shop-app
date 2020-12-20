import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  void setToken(String tokenValue, String userId, String expiresIn) {
    _token = tokenValue;
    _userId = userId;
    _expiryDate = DateTime.now().add(Duration(seconds: int.parse(expiresIn)));
    notifyListeners();
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signup(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAWdew8fpAlyiMr9joD9fIZlXTv2529F_Q';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      setToken(responseData['idToken'], responseData['localId'],
          responseData['expiresIn']);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signin(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAWdew8fpAlyiMr9joD9fIZlXTv2529F_Q';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      setToken(responseData['idToken'], responseData['localId'],
          responseData['expiresIn']);
    } catch (e) {
      throw e;
    }
  }
}
