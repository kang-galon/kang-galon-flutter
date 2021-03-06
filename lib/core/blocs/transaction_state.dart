import 'package:equatable/equatable.dart';
import 'package:kang_galon/core/models/models.dart';

abstract class TransactionState extends Equatable {
  TransactionState();
}

class TransactionEmpty extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionLoading extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionError extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionAddSuccess extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionAddFailed extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionFetchListSuccess extends TransactionState {
  final List<Transaction> transactions;

  TransactionFetchListSuccess({required this.transactions});

  @override
  List<Object> get props => [];
}

class TransactionFetchDetailSuccess extends TransactionState {
  final Transaction transaction;

  TransactionFetchDetailSuccess({required this.transaction});

  @override
  List<Object> get props => [transaction];
}

class TransactionFetchCurrentSuccess extends TransactionState {
  final Transaction transaction;

  TransactionFetchCurrentSuccess({required this.transaction});

  @override
  List<Object> get props => [transaction];
}
