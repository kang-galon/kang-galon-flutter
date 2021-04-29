import 'package:equatable/equatable.dart';

abstract class ChatsEvent extends Equatable {
  ChatsEvent();
}

class ChatGetMessage extends ChatsEvent {
  @override
  List<Object> get props => [];
}

class ChatSendMessage extends ChatsEvent {
  final String depotPhoneNumber;
  final int transactionId;
  final String message;

  ChatSendMessage({
    this.transactionId,
    this.depotPhoneNumber,
    this.message,
  });

  @override
  List<Object> get props => [transactionId, depotPhoneNumber, message];
}
