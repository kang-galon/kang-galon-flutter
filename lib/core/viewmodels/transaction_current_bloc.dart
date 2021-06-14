import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/models/models.dart';
import 'package:kang_galon/core/services/services.dart';

class TransactionCurrentBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionService _transactionService = TransactionService();

  TransactionCurrentBloc() : super(TransactionEmpty());

  @override
  Stream<TransactionState> mapEventToState(TransactionEvent event) async* {
    try {
      if (event is TransactionFetchCurrent) {
        yield TransactionLoading();

        Transaction transaction =
            await _transactionService.getCurrentTransactions();

        if (transaction == null) {
          yield TransactionEmpty();
        } else {
          yield TransactionFetchCurrentSuccess(transaction: transaction);
        }
      }

      if (event is TransactionDenyCurrent) {
        yield TransactionLoading();

        await _transactionService.denyCurrentTransaction();

        yield TransactionEmpty();
      }
    } catch (e) {
      print(e);
      yield TransactionError();
    }
  }
}
