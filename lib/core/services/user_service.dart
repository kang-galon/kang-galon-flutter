import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:kang_galon/core/services/services.dart';

class UserService {
  Future<void> register(
      String phoneNumber, String name, String uid, String token) async {
    Uri uri = url('/client/register');

    var response = await http.post(
      uri,
      body: {
        'phone_number': phoneNumber,
        'name': name,
        'uid': uid,
        'token': token,
      },
    );

    var json = jsonDecode(response.body);
    if (!json['success']) {
      throw Exception(json['message']);
    }
  }

  Future<bool> isUserExist(String phoneNumber) async {
    Uri uri = url('/client/check-user');
    var response = await http.post(
      uri,
      body: {'phone_number': phoneNumber},
    );

    var json = jsonDecode(response.body);
    if (!json['success']) {
      throw Exception(json['message']);
    }

    return response.statusCode == 200;
  }

  Future<void> updateProfile(String name) async {
    Uri uri = url('/client');
    var token = await FirebaseAuth.instance.currentUser.getIdToken();

    var response = await http.patch(
      uri,
      headers: {'Authorization': 'Bearer ' + token},
      body: {'name': name},
    );

    var json = jsonDecode(response.body);
    if (!json['success']) {
      throw Exception(json['message']);
    }
  }
}
