import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/blocs/event_state.dart';

class SnackbarBloc extends Bloc<SnackbarEvent, SnackbarState> {
  SnackbarBloc() : super(SnackbarUninitialized());

  @override
  Stream<SnackbarState> mapEventToState(SnackbarEvent event) async* {
    if (event is SnackbarUnauthorized) {
      yield SnackbarUnauthorizedShowing();
    }

    if (event is SnackbarShow) {
      yield SnackbarShowing(message: event.message, isError: event.isError);
    }
  }
}
