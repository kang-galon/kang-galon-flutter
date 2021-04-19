import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:kang_galon/core/models/models.dart';
import 'package:kang_galon/core/services/api.dart' as api;

class TransactionService {
  Future<void> addTransaction(
      String depotPhoneNumber, String clientLocation, int gallon) async {
    Uri url = api.url('/client/transaction');
    String token = await FirebaseAuth.instance.currentUser.getIdToken();

    var response = await http.post(url, headers: {
      'Authorization': 'Bearer ' + token,
    }, body: {
      'depot_phone_number': depotPhoneNumber,
      'client_location': clientLocation,
      'gallon': gallon.toString(),
    });

    var json = jsonDecode(response.body);
    if (!json['success']) {
      throw Exception(json['message']);
    }
  }

  Future<TransactionFetchListSuccess> getTransactions() async {
    Uri url = api.url('/client/transaction');
    String token = await FirebaseAuth.instance.currentUser.getIdToken();

    var response = await http.get(url, headers: {
      'Authorization': 'Bearer ' + token,
    });

    var json = jsonDecode(response.body);
    if (json['success']) {
      return TransactionFetchListSuccess.fromJsonToList(json['data']);
    } else {
      throw Exception(json['message']);
    }
  }

  Future<TransactionFetchDetailSuccess> getDetailTransactions(int id) async {
    Uri url = api.url('/client/transaction/$id');
    String token = await FirebaseAuth.instance.currentUser.getIdToken();

    var response = await http.get(url, headers: {
      'Authorization': 'Bearer ' + token,
    });

    var json = jsonDecode(response.body);
    if (json['success']) {
      return TransactionFetchDetailSuccess.fromJsonToModel(json['data']);
    } else {
      throw Exception(json['message']);
    }
  }
}
