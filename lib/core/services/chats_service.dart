import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:kang_galon/core/models/models.dart';
import 'package:kang_galon/core/services/services.dart';
import 'package:http/http.dart' as http;

class ChatsService {
  static Future<Chats> getMessage() async {
    Uri uri = url('/client/chats');
    String token = await FirebaseAuth.instance.currentUser!.getIdToken();

    var response =
        await http.get(uri, headers: {'Authorization': 'Bearer $token'});

    var json = jsonDecode(response.body);
    if (json['success']) {
      return Chats.fromJson(json['data']);
    } else {
      throw Exception(json['message']);
    }
  }

  static Future<void> sendMessage(
      String depotPhoneNumber, int transactionId, String message) async {
    Uri uri = url('/client/chats/send');
    String token = await FirebaseAuth.instance.currentUser!.getIdToken();

    var response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'to': depotPhoneNumber,
        'transaction_id': transactionId.toString(),
        'message': message
      },
    );

    var json = jsonDecode(response.body);
    if (!json['success']) {
      throw Exception(json['message']);
    }
  }
}
