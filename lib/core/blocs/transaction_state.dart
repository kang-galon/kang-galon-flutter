import 'package:equatable/equatable.dart';
import 'package:kang_galon/core/models/models.dart';

abstract class TransactionState extends Equatable {
  TransactionState();
}

class TransactionEmpty extends TransactionState {
  @override
  List<Object> get props => [];

  @override
  String toString() {
    return 'Anda belum memiliki transaksi';
  }
}

class TransactionLoading extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionError extends TransactionState {
  @override
  List<Object> get props => [];

  @override
  String toString() {
    return 'Ups.. ada yang salah nih';
  }
}

class TransactionAddSuccess extends TransactionState {
  @override
  List<Object> get props => [];

  @override
  String toString() {
    return 'Checkout berhasil, silahkan menunggu';
  }
}

class TransactionFetchListSuccess extends TransactionState {
  final List<Transaction> transactions;

  TransactionFetchListSuccess({this.transactions});

  @override
  List<Object> get props => [];
}

class TransactionFetchDetailSuccess extends TransactionState {
  final Transaction transaction;

  TransactionFetchDetailSuccess({this.transaction});

  @override
  List<Object> get props => [transaction];
}
