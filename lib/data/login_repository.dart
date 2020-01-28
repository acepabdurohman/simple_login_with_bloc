import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepository {

  SharedPreferences sharedPreferences;
  

  Future<TokenResponse> authenticate(String username, String password) async {

    print('call api login');
    
    final _baseUrl = 'https://leumart-api.herokuapp.com';

    Map<String, String> data = {
      "username": username,
      "password": password
    };

    Map<String, String> inputHeader = {
      'Content-Type': 'application/json'
    };

    var url = _baseUrl + '/api/users/login';

    final response = await http.post(url, body: json.encode(data), headers: inputHeader);    

    if (response.statusCode == 200) {
      var loginResponse = json.decode(response.body);
      Map<String, dynamic> token = loginResponse['token'];
      return TokenResponse.fromJson(1, loginResponse['message'], token['access_token']);
    } else {
      var loginResponse = json.decode(response.body);
      return TokenResponse.fromJson(0, loginResponse['message'], null);
    }
  }

  Future<void> saveToken(String token)  async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('accessToken', token);
    return;
  }

  Future<bool> hasToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('accessToken');
    if (token != null) {
      return true;
    }
    return false;
  }

  Future<void> deleteToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('accessToken');
    return;
  }
}

class TokenResponse {
  final int status;
  final String message;
  final String accessToken;  

  TokenResponse({this.status, this.message, this.accessToken});

  factory TokenResponse.fromJson(int status, String message, String token) {
    return TokenResponse(status: status, message: message, accessToken: token);
  }
}