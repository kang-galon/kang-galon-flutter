import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/models/models.dart';
import 'package:kang_galon/core/services/services.dart';
import 'package:kang_galon/core/viewmodels/bloc.dart';

class TransactionCurrentBloc extends Bloc<TransactionEvent, TransactionState> {
  final SnackbarBloc _snackbarBloc;
  TransactionCurrentBloc(this._snackbarBloc) : super(TransactionEmpty());

  @override
  Stream<TransactionState> mapEventToState(TransactionEvent event) async* {
    try {
      if (event is TransactionFetchCurrent) {
        yield TransactionLoading();

        Transaction? transaction =
            await TransactionService.getCurrentTransactions();

        if (transaction == null) {
          yield TransactionEmpty();
        } else {
          yield TransactionFetchCurrentSuccess(transaction: transaction);
        }
      }

      if (event is TransactionDenyCurrent) {
        yield TransactionLoading();

        await TransactionService.denyCurrentTransaction();

        yield TransactionEmpty();
      }

      if (event is TransactionRatingCurrent) {
        yield TransactionLoading();

        await TransactionService.ratingCurrentTransaction(event.rating * 2);

        yield TransactionEmpty();
      }
    } catch (e) {
      print('TransactionCurrent - $e');
      _snackbarBloc.add(SnackbarShow(message: 'Ups.. ada yang salah nih'));

      yield TransactionError();
    }
  }
}
