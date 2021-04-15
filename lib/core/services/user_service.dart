import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:kang_galon/core/models/user.dart' as My;
import 'package:kang_galon/core/services/api.dart' as api;

class UserService {
  Future<My.User> register(
      String phoneNumber, String name, String uid, String token) async {
    Uri url = api.url('/client/register');

    var response = await http.post(
      url,
      body: {
        'phone_number': phoneNumber,
        'name': name,
        'uid': uid,
        'token': token,
      },
    );

    var json = jsonDecode(response.body);
    if (json['success']) {
      return My.User(
        phoneNumber: json['data']['phone_number'],
        name: json['data']['name'],
      );
    } else {
      throw Exception(json['message']);
    }
  }

  Future<bool> isUserExist(String phoneNumber) async {
    Uri url = api.url('/client/check-user');
    var response = await http.post(
      url,
      body: {'phone_number': phoneNumber},
    );

    return response.statusCode == 200;
  }

  Future<void> updateProfile(String name) async {
    Uri url = api.url('/client');
    var token = await FirebaseAuth.instance.currentUser.getIdToken();

    var response = await http.patch(
      url,
      headers: {'Authorization': 'Bearer ' + token},
      body: {'name': name},
    );

    var json = jsonDecode(response.body);
    if (!json['success']) {
      throw Exception(json['message']);
    }
  }
}
