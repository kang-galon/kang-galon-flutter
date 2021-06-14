import 'package:kang_galon/core/models/models.dart';

class Transaction {
  final int id;
  final String depotName;
  final String depotPhoneNumber;
  final String clientPhoneNumber;
  final String clientLocation;
  final int status;
  final String statusDescription;
  final int totalPrice;
  final String totalPriceDescription;
  final int gallon;
  final double rating;
  final String createdAt;
  final Depot? depot;

  Transaction({
    required this.id,
    required this.depotName,
    required this.depotPhoneNumber,
    required this.clientPhoneNumber,
    required this.clientLocation,
    required this.status,
    required this.statusDescription,
    required this.totalPrice,
    required this.totalPriceDescription,
    required this.gallon,
    required this.rating,
    required this.createdAt,
    required this.depot,
  });

  static List<Transaction> fromJsonToList(dynamic json) {
    List<Transaction> transactions = [];

    for (var transaction in json) {
      transactions.add(Transaction(
        id: transaction['id'],
        depotName: transaction['depot_name'],
        depotPhoneNumber: transaction['depot_phone_number'],
        clientPhoneNumber: transaction['client_phone_number'],
        clientLocation: transaction['client_location'],
        status: transaction['status'],
        statusDescription: transaction['status_description'],
        totalPrice: transaction['total_price'],
        totalPriceDescription: transaction['total_price_description'],
        gallon: transaction['gallon'],
        rating: double.parse(transaction['rating'].toString()),
        createdAt: transaction['created_at'],
        depot: null,
      ));
    }

    return transactions;
  }

  static Transaction fromJsonToModel(dynamic json) {
    Depot depot = Depot(
      phoneNumber: json['depot']['phone_number'],
      name: json['depot']['name'],
      image: json['depot']['image'],
      latitude: json['depot']['latitude'],
      longitude: json['depot']['longitude'],
      address: json['depot']['address'],
      rating: double.parse(json['depot']['rating'].toString()),
      price: json['depot']['price'],
      priceDesc: json['depot']['price_description'],
      isOpen: json['depot']['is_open'] == 1 ? true : false,
      isOpenDesc: json['depot']['is_open_description'],
    );

    Transaction transaction = Transaction(
      id: json['id'],
      depotName: json['depot_name'],
      depotPhoneNumber: json['depot_phone_number'],
      clientPhoneNumber: json['client_phone_number'],
      clientLocation: json['client_location'],
      status: json['status'],
      statusDescription: json['status_description'],
      totalPrice: json['total_price'],
      totalPriceDescription: json['total_price_description'],
      gallon: json['gallon'],
      rating: double.parse(json['rating'].toString()),
      createdAt: json['created_at'],
      depot: depot,
    );

    return transaction;
  }
}
