import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/models/models.dart';
import 'package:kang_galon/core/services/services.dart';

class TransactionDetailBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionService _transactionService = TransactionService();

  TransactionDetailBloc() : super(TransactionEmpty());

  @override
  Stream<TransactionState> mapEventToState(TransactionEvent event) async* {
    if (event is TransactionFetchDetail) {
      yield TransactionLoading();

      try {
        Transaction transaction =
            await _transactionService.getDetailTransactions(event.id);

        yield TransactionFetchDetailSuccess(transaction: transaction);
      } catch (e) {
        yield TransactionError();
      }
    }
  }
}
