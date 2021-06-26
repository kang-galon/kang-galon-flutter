import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/models/models.dart';
import 'package:kang_galon/core/services/services.dart';
import 'package:kang_galon/core/viewmodels/bloc.dart';

class TransactionDetailBloc extends Bloc<TransactionEvent, TransactionState> {
  final SnackbarBloc _snackbarBloc;
  TransactionDetailBloc(this._snackbarBloc) : super(TransactionEmpty());

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
      _snackbarBloc.add(SnackbarShow(message: 'Ups.. ada yang salah nih'));

      yield TransactionError();
    }
  }
}
