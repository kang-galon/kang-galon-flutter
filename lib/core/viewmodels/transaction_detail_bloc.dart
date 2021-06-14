import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/models/models.dart';
import 'package:kang_galon/core/services/services.dart';

class TransactionDetailBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionDetailBloc() : super(TransactionEmpty());

  @override
  Stream<TransactionState> mapEventToState(TransactionEvent event) async* {
    try {
      if (event is TransactionFetchDetail) {
        yield TransactionLoading();

        Transaction transaction =
            await TransactionService.getDetailTransactions(event.id);

        yield TransactionFetchDetailSuccess(transaction: transaction);
      }
    } catch (e) {
      print('TransactionDetail - $e');

      yield TransactionError();
    }
  }
}
