import 'package:equatable/equatable.dart';

abstract class TransactionEvent extends Equatable {
  TransactionEvent();
}

class TransactionAdd extends TransactionEvent {
  final String depotPhoneNumber;
  final String clientLocation;
  final int gallon;

  TransactionAdd({this.depotPhoneNumber, this.clientLocation, this.gallon});

  @override
  List<Object> get props => [depotPhoneNumber, clientLocation, gallon];
}

class TransactionFetchList extends TransactionEvent {
  @override
  List<Object> get props => [];
}

class TransactionFetchDetail extends TransactionEvent {
  final int id;

  TransactionFetchDetail({this.id});

  @override
  List<Object> get props => [id];
}
