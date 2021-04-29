import 'package:equatable/equatable.dart';
import 'package:kang_galon/core/models/models.dart';

abstract class ChatsState extends Equatable {
  ChatsState();
}

class ChatsUninitialized extends ChatsState {
  @override
  List<Object> get props => [];
}

class ChatsLoading extends ChatsState {
  @override
  List<Object> get props => [];
}

class ChatsError extends ChatsState {
  @override
  List<Object> get props => [];

  @override
  String toString() {
    return 'Ups.. ada yang salah nih';
  }
}

class ChatsSendMessageSuccess extends ChatsState {
  final Depot depot;
  final List<Chats> chats;

  ChatsSendMessageSuccess({this.depot, this.chats});

  @override
  List<Object> get props => [depot, chats];
}

class ChatsGetMessageSuccess extends ChatsState {
  final Chats chats;

  ChatsGetMessageSuccess({this.chats});

  @override
  List<Object> get props => [];
}
