import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/models/models.dart';
import 'package:kang_galon/core/services/transaction_service.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionService _transactionService = TransactionService();

  TransactionBloc() : super(TransactionEmpty());

  @override
  Stream<TransactionState> mapEventToState(TransactionEvent event) async* {
    if (event is TransactionAdd) {
      yield TransactionLoading();

      try {
        bool isSuccess = await _transactionService.addTransaction(
          event.depotPhoneNumber,
          event.clientLocation,
          event.gallon,
        );

        if (isSuccess) {
          yield TransactionAddSuccess();
        } else {
          yield TransactionAddFailed();
        }
      } catch (e) {
        print(e);
        yield TransactionError();
      }
    }

    if (event is TransactionFetchList) {
      yield TransactionLoading();

      try {
        List<Transaction> transactions =
            await _transactionService.getTransactions();

        if (transactions.isEmpty) {
          yield TransactionEmpty();
        } else {
          yield TransactionFetchListSuccess(transactions: transactions);
        }
      } catch (e) {
        print(e);
        yield TransactionError();
      }
    }
  }
}
