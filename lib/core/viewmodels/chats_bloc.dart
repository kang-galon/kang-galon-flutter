import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/models/models.dart';
import 'package:kang_galon/core/services/services.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  ChatsBloc() : super(ChatsUninitialized());

  @override
  Stream<ChatsState> mapEventToState(ChatsEvent event) async* {
    try {
      if (event is ChatSendMessage) {
        yield ChatsLoading();

        await ChatsService.sendMessage(
            event.depotPhoneNumber, event.transactionId, event.message);

        yield ChatsSendMessageSuccess();
      }

      if (event is ChatGetMessage) {
        yield ChatsLoading();

        Chats chats = await ChatsService.getMessage();

        yield ChatsGetMessageSuccess(chats: chats);
      }
    } catch (e) {
      print('ChatsBloc - $e');

      yield ChatsError();
    }
  }
}
