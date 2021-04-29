import 'package:kang_galon/core/models/models.dart';

class Chats {
  final Depot depot;
  final List<Message> messages;

  Chats({this.depot, this.messages});

  factory Chats.fromJson(dynamic json) {
    Depot depot = Depot(
      phoneNumber: json['depot']['phone_number'],
      image: json['depot']['image'],
      latitude: json['depot']['latitude'],
      longitude: json['depot']['longitude'],
      address: json['depot']['address'],
      rating: double.parse(json['depot']['rating'].toString()),
      price: json['depot']['price'],
      priceDesc: json['depot']['price_description'],
      isOpen: json['depot']['is_open'] == 1 ? true : false,
      isOpenDesc: json['depot']['is_open_description'],
    );

    List<Message> messages = [];
    for (var chat in json['chats']) {
      messages.add(Message(
        message: chat['message'],
        isMe: chat['is_me'],
        createdAt: chat['created_at'],
      ));
    }

    return Chats(depot: depot, messages: messages);
  }
}

class Message {
  final String message;
  final bool isMe;
  final String createdAt;

  Message({this.message, this.isMe, this.createdAt});
}
