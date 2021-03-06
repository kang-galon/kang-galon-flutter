import 'package:equatable/equatable.dart';

abstract class TransactionEvent extends Equatable {
  TransactionEvent();
}

class TransactionAdd extends TransactionEvent {
  final String depotPhoneNumber;
  final String clientLocation;
  final int gallon;

  TransactionAdd(
      {required this.depotPhoneNumber,
      required this.clientLocation,
      required this.gallon});

  @override
  List<Object> get props => [depotPhoneNumber, clientLocation, gallon];
}

class TransactionFetchList extends TransactionEvent {
  @override
  List<Object> get props => [];
}

class TransactionFetchDetail extends TransactionEvent {
  final int id;

  TransactionFetchDetail({required this.id});

  @override
  List<Object> get props => [id];
}

class TransactionFetchCurrent extends TransactionEvent {
  @override
  List<Object> get props => [];
}

class TransactionDenyCurrent extends TransactionEvent {
  @override
  List<Object> get props => [];
}

class TransactionRatingCurrent extends TransactionEvent {
  final int rating;

  TransactionRatingCurrent({required this.rating});

  @override
  List<Object> get props => [];
}
