import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:kang_galon/core/models/models.dart';
import 'package:kang_galon/core/services/services.dart';

class DepotService {
  static Future<List<Depot>> getDepots(
      double latitude, double longitude) async {
    Uri uri = url(
      '/client/depot',
      {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
      },
    );

    var token = await FirebaseAuth.instance.currentUser!.getIdToken();
    var response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer ' + token},
    );

    var json = jsonDecode(response.body);
    if (json['success']) {
      return Depot.fromJsonToList(json['data']);
    } else {
      throw Exception(json['message']);
    }
  }
}
