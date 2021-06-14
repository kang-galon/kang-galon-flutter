import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/models/models.dart';
import 'package:kang_galon/core/viewmodels/bloc.dart';
import 'package:kang_galon/ui/config/pallette.dart';
import 'package:kang_galon/ui/pages/pages.dart';
import 'package:kang_galon/ui/widgets/widgets.dart';

class ChatsPage extends StatelessWidget {
  static const String routeName = '/chats';
  final TextEditingController _textEditingController = TextEditingController();
  List<Message> _messages = [];

  void _sendMessage(
    BuildContext context,
    ChatsBloc chatsBloc,
    TransactionCurrentBloc transactionCurrentBloc,
  ) {
    FocusScope.of(context).unfocus();

    TransactionState current = transactionCurrentBloc.state;
    if (current is TransactionFetchCurrentSuccess) {
      if (_textEditingController.text.isNotEmpty) {
        chatsBloc.add(ChatSendMessage(
          depotPhoneNumber: current.transaction.depot.phoneNumber,
          transactionId: current.transaction.id,
          message: _textEditingController.text,
        ));
      }
    }

    // getToken();
  }

  void getToken() async {
    print(await FirebaseAuth.instance.currentUser.getIdToken());
  }

  @override
  Widget build(BuildContext context) {
    ChatsBloc chatsBloc = BlocProvider.of<ChatsBloc>(context);
    TransactionCurrentBloc transactionCurrentBloc =
        BlocProvider.of<TransactionCurrentBloc>(context);

    // get message
    chatsBloc.add(ChatGetMessage());

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Padding(
        padding: Pallette.contentPadding,
        child: Column(
          children: [
            HeaderBar(label: 'Chats Depot'),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.only(bottom: 50.0),
                    child: BlocConsumer<ChatsBloc, ChatsState>(
                      listener: (context, state) {
                        if (state is ChatsError) {
                          showSnackbar(context, state.toString());
                        }

                        if (state is ChatsSendMessageSuccess) {
                          _textEditingController.text = '';
                        }

                        if (state is ChatsGetMessageSuccess) {
                          _messages = state.chats.messages;
                        }
                      },
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
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
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
                            onPressed: () => _sendMessage(
                                context, chatsBloc, transactionCurrentBloc),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatsBallon extends StatelessWidget {
  final String text;
  final String dateTime;
  final bool isMe;

  ChatsBallon({
    @required this.text,
    @required this.dateTime,
    this.isMe = false,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            margin: EdgeInsets.only(bottom: 10.0),
            decoration: BoxDecoration(
              color: Colors.blue.shade300,
              borderRadius: BorderRadius.only(
                topLeft: isMe ? Radius.circular(10.0) : Radius.circular(0.0),
                topRight: isMe ? Radius.circular(0.0) : Radius.circular(10.0),
                bottomLeft: Radius.circular(13.0),
                bottomRight: Radius.circular(13.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text),
                SizedBox(height: 10.0),
                Text(
                  dateTime,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

List<Map<String, bool>> dataChats = [
  {"Heyaa 1": true},
  {"Heyaa 2": false},
  {"Heyaa 3": true},
  {"Heyaa 4": true},
  {"Heyaa 5": false},
  {"Heyaa 6": false},
  {"Heyaa 7": false},
  {"Heyaa 8": true},
  {"Heyaa 9": true},
  {"Heyaa 10": false},
];
