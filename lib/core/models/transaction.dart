//  "id": 1,
//             "client_phone_number": "+6289696133160",
//             "depot_phone_number": "+6289696454545",
//             "client_location": "-0.9320895689490549, 100.43093670765172",
//             "status": 1,
//             "total_price": 10000,
//             "gallon": 2,
//             "rating": 0,
//             "created_at": "2021-04-06 21:56:23",
//             "updated_at": "2021-04-06 21:56:23",
//             "total_price_description": "Rp. 10,000"

class Transaction {
  int id;
  String clientPhoneNumber;
  String depotPhoneNumber;
  String clientLocation;
  int status;
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

class TransactionSuccess extends Transaction {
  List<Transaction> transactions = [];
}
