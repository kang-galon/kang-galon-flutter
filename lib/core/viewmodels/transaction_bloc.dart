import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/models/transaction.dart';
import 'package:kang_galon/core/services/transaction_service.dart';

class TransactionBloc extends Bloc<Transaction, Transaction> {
  final TransactionService transactionService = TransactionService();

  TransactionBloc() : super(TransactionEmpty());

  @override
  Stream<Transaction> mapEventToState(Transaction transaction) async* {
    if (transaction is TransactionAdd) {
      yield TransactionLoading();

      try {
        await transactionService.addTransaction(
          transaction.depotPhoneNumber,
          transaction.clientLocation,
          transaction.gallon,
        );
        yield TransactionSuccess();
      } catch (e) {
        yield TransactionError();
      }
    }
  }
}
