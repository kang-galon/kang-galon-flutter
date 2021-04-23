import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kang_galon/core/models/models.dart';
import 'package:kang_galon/ui/pages/pages.dart';
import 'package:kang_galon/ui/widgets/home_button.dart';

class TransactionCurrent extends StatelessWidget {
  final Transaction transaction;
  final Function() onTapPhone;
  final Function() onTapChat;

  const TransactionCurrent({
    @required this.transaction,
    @required this.onTapPhone,
    @required this.onTapChat,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image(
                width: 100.0,
                fit: BoxFit.fitWidth,
                image: transaction.depot.image == null
                    ? AssetImage('assets/images/shop.png')
                    : CachedNetworkImageProvider(transaction.depot.image),
              ),
            ),
            SizedBox(width: 5.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(transaction.depot.address),
                  SizedBox(height: 30.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text('${transaction.createdAt}'),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 20.0),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          width: MediaQuery.of(context).size.width,
          decoration: Style.containerDecoration,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                transaction.depotName,
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                transaction.statusDescription,
                style: TextStyle(fontSize: 15.0),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HomeButton(
              label: 'Telepon',
              icon: Icons.phone,
              onPressed: onTapPhone,
            ),
            HomeButton(
              label: 'Chat',
              icon: Icons.chat,
              onPressed: onTapChat,
            ),
          ],
        ),
      ],
    );
  }
}
