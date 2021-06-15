import 'package:equatable/equatable.dart';

abstract class ChatsEvent extends Equatable {
  ChatsEvent();
}

class ChatGetMessage extends ChatsEvent {
  @override
  List<Object> get props => [];
}

class ChatSendMessage extends ChatsEvent {
  final int transactionId;
  final String message;

  ChatSendMessage({
    required this.transactionId,
    required this.message,
  });

  @override
  List<Object> get props => [transactionId, message];
}
