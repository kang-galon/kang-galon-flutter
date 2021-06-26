import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/models/models.dart';
import 'package:kang_galon/core/services/transaction_service.dart';
import 'package:kang_galon/core/viewmodels/bloc.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final SnackbarBloc _snackbarBloc;
  TransactionBloc(this._snackbarBloc) : super(TransactionEmpty());

  @override
  Stream<TransactionState> mapEventToState(TransactionEvent event) async* {
    try {
      if (event is TransactionAdd) {
        yield TransactionLoading();

        bool isSuccess = await TransactionService.addTransaction(
          event.depotPhoneNumber,
          event.clientLocation,
          event.gallon,
        );

        if (isSuccess) {
          yield TransactionAddSuccess();
        } else {
          yield TransactionAddFailed();
        }
      }

      if (event is TransactionFetchList) {
        yield TransactionLoading();

        List<Transaction> transactions =
            await TransactionService.getTransactions();

        if (transactions.isEmpty) {
          yield TransactionEmpty();
        } else {
          yield TransactionFetchListSuccess(transactions: transactions);
        }
      }
    } catch (e) {
      print('TransactionBloc - $e');
      _snackbarBloc.add(SnackbarShow(message: 'Ups.. ada yang salah nih'));

      yield TransactionError();
    }
  }
}
