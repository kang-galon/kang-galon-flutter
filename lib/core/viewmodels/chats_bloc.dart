import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/models/models.dart';
import 'package:kang_galon/core/services/services.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  final ChatsService chatsService = ChatsService();

  ChatsBloc() : super(ChatsUninitialized());

  @override
  Stream<ChatsState> mapEventToState(ChatsEvent event) async* {
    if (event is ChatSendMessage) {
      try {
        yield ChatsLoading();

        await chatsService.sendMessage(
            event.depotPhoneNumber, event.transactionId, event.message);

        yield ChatsSendMessageSuccess();
      } catch (e) {
        print(e);
        yield ChatsError();
      }
    }

    if (event is ChatGetMessage) {
      try {
        yield ChatsLoading();

        Chats chats = await chatsService.getMessage();

        yield ChatsGetMessageSuccess(chats: chats);
      } catch (e) {
        print(e);
        yield ChatsError();
      }
    }
  }
}
