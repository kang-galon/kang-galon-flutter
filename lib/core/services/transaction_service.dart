import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:kang_galon/core/models/models.dart';
import 'package:kang_galon/core/services/services.dart';

class TransactionService {
  static Future<bool> addTransaction(
      String depotPhoneNumber, String clientLocation, int gallon) async {
    Uri uri = url('/client/transaction');
    String token = await FirebaseAuth.instance.currentUser!.getIdToken();

    var response = await http.post(uri, headers: {
      'Authorization': 'Bearer ' + token,
    }, body: {
      'depot_phone_number': depotPhoneNumber,
      'client_location': clientLocation,
      'gallon': gallon.toString(),
    });

    var json = jsonDecode(response.body);
    return json['success'];
  }

  static Future<List<Transaction>> getTransactions() async {
    Uri uri = url('/client/transaction');
    String token = await FirebaseAuth.instance.currentUser!.getIdToken();

    var response = await http.get(uri, headers: {
      'Authorization': 'Bearer ' + token,
    });

    var json = jsonDecode(response.body);
    if (json['success']) {
      return Transaction.fromJsonToList(json['data']);
    } else {
      throw Exception(json['message']);
    }
  }

  static Future<Transaction> getDetailTransactions(int id) async {
    Uri uri = url('/client/transaction/$id');
    String token = await FirebaseAuth.instance.currentUser!.getIdToken();

    var response = await http.get(uri, headers: {
      'Authorization': 'Bearer ' + token,
    });

    var json = jsonDecode(response.body);
    if (json['success']) {
      return Transaction.fromJson(json['data']);
    } else {
      throw Exception(json['message']);
    }
  }

  static Future<Transaction?> getCurrentTransactions() async {
    Uri uri = url('/client/transaction/current');
    String token = await FirebaseAuth.instance.currentUser!.getIdToken();

    var response = await http.get(uri, headers: {
      'Authorization': 'Bearer ' + token,
    });

    var json = jsonDecode(response.body);
    if (json['success']) {
      return Transaction.fromJson(json['data']);
    } else {
      return null;
    }
  }

  static Future<void> denyCurrentTransaction() async {
    Uri uri = url('/client/transaction/current/deny');
    String token = await FirebaseAuth.instance.currentUser!.getIdToken();

    var response = await http.post(uri, headers: {
      'Authorization': 'Bearer ' + token,
    });

    var json = jsonDecode(response.body);
    if (!json['success']) {
      throw Exception(json['message']);
    }
  }
}
