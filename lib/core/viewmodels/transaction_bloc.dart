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

    if (transaction is TransactionFetchList) {
      yield TransactionLoading();

      try {
        TransactionFetchListSuccess transactionFetchSuccess =
            await transactionService.getTransactions();

        if (transactionFetchSuccess.transactions.isEmpty) {
          yield TransactionEmpty();
        } else {
          yield transactionFetchSuccess;
        }
      } catch (e) {
        yield TransactionError();
      }
    }

    if (transaction is TransactionFetchDetail) {
      yield TransactionLoading();

      try {
        TransactionFetchDetailSuccess transactionFetchDetailSuccess =
            await transactionService.getDetailTransactions(transaction.id);

        yield transactionFetchDetailSuccess;
      } catch (e) {
        yield TransactionError();
      }
    }
  }
}
