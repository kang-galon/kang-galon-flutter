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

  Transaction({
    this.id,
    this.depotName,
    this.depotPhoneNumber,
    this.clientPhoneNumber,
    this.clientLocation,
    this.status,
    this.statusDescription,
    this.totalPrice,
    this.totalPriceDescription,
    this.gallon,
    this.rating,
    this.createdAt,
  });
}

class TransactionEmpty extends Transaction {}

class TransactionLoading extends Transaction {}

class TransactionError extends Transaction {}

class TransactionAdd extends Transaction {
  String depotPhoneNumber;
  String clientLocation;
  int gallon;

  TransactionAdd({this.depotPhoneNumber, this.clientLocation, this.gallon});
}

class TransactionFetchList extends Transaction {}

class TransactionFetchListSuccess extends Transaction {
  List<Transaction> transactions = [];

  TransactionFetchListSuccess(this.transactions);

  factory TransactionFetchListSuccess.fromJsonToList(dynamic json) {
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
      ));
    }

    return TransactionFetchListSuccess(transactions);
  }
}

class TransactionFetchDetail extends Transaction {
  int id;

  TransactionFetchDetail({this.id});
}

class TransactionFetchDetailSuccess extends Transaction {
  Depot depot;
  Transaction transaction;

  TransactionFetchDetailSuccess({this.depot, this.transaction});

  factory TransactionFetchDetailSuccess.fromJsonToModel(dynamic json) {
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
    );

    Depot depot = Depot(
      phoneNumber: json['depot']['phone_number'],
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

    return TransactionFetchDetailSuccess(
      transaction: transaction,
      depot: depot,
    );
  }
}

class TransactionSuccess extends Transaction {
  List<Transaction> transactions = [];
}
