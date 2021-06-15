import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/models/models.dart';
import 'package:kang_galon/core/viewmodels/bloc.dart';
import 'package:kang_galon/ui/config/pallette.dart';
import 'package:kang_galon/ui/widgets/widgets.dart';

class ChatsPage extends StatefulWidget {
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late ChatsBloc _chatsBloc;
  late TransactionCurrentBloc _transactionCurrentBloc;
  late TextEditingController _textEditingController;
  late Depot _depot;
  late List<Message> _messages;

  @override
  void initState() {
    _chatsBloc = BlocProvider.of<ChatsBloc>(context);
    _transactionCurrentBloc = BlocProvider.of<TransactionCurrentBloc>(context);

    // init controller
    _textEditingController = TextEditingController();

    // get message
    _chatsBloc.add(ChatGetMessage());

    // set
    _messages = [];
    TransactionState state = _transactionCurrentBloc.state;
    if (state is TransactionFetchCurrentSuccess) {
      _depot = state.transaction.depot!;
    }

    _initNotification();

    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();

    super.dispose();
  }

  void _initNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      _chatsBloc.add(ChatGetMessage());
    });
  }

  void _unFocus() => FocusScope.of(context).unfocus();

  void _chatsListener(BuildContext context, ChatsState state) {
    if (state is ChatsError) {
      showSnackbar(context, state.toString());
    }

    if (state is ChatsSendMessageSuccess) {
      _textEditingController.text = '';
      _chatsBloc.add(ChatGetMessage());
    }

    if (state is ChatsGetMessageSuccess) {
      _messages = state.chats.messages;
    }
  }

  void _sendMessage() {
    _unFocus();

    TransactionState state = _transactionCurrentBloc.state;
    if (state is TransactionFetchCurrentSuccess) {
      if (_textEditingController.text.isNotEmpty) {
        _chatsBloc.add(ChatSendMessage(
          transactionId: state.transaction.id,
          message: _textEditingController.text,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: Padding(
          padding: Pallette.contentPadding,
          child: Column(
            children: [
              HeaderBar(label: 'Chats - ${_depot.name}'),
              Expanded(
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: _unFocus,
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        margin: EdgeInsets.only(bottom: 50.0),
                        child: BlocConsumer<ChatsBloc, ChatsState>(
                          listener: _chatsListener,
                          builder: (context, state) {
                            return ListView.builder(
                              physics: BouncingScrollPhysics(),
                              reverse: true,
                              itemBuilder: (context, index) {
                                Message message = _messages[index];
                                return ChatsBallon(
                                  text: message.message,
                                  isMe: message.isMe,
                                  dateTime: message.createdAt,
                                );
                              },
                              itemCount: _messages.length,
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: _buildChatForm(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatForm() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 1.0,
                    spreadRadius: 1.0,
                    offset: Offset(0, 1),
                  ),
                ],
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: TextFormField(
                controller: _textEditingController,
                maxLines: 1,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
          ),
          MaterialButton(
            child: BlocBuilder<ChatsBloc, ChatsState>(
              builder: (context, state) {
                if (state is ChatsLoading) {
                  return SizedBox(
                    child: CircularProgressIndicator(),
                    width: 25.0,
                    height: 25.0,
                  );
                }

                return Icon(
                  Icons.send,
                  size: 25.0,
                  color: Colors.blue,
                );
              },
            ),
            elevation: 2.0,
            shape: CircleBorder(),
            color: Colors.white,
            padding: EdgeInsets.all(10.0),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
