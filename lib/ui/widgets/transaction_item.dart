import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kang_galon/core/models/models.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final Function onTap;

  TransactionItem({
    @required this.transaction,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    transaction.depotName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                  Icon(Icons.chevron_right),
                ],
              ),
              SizedBox(height: 5.0),
              Text(
                transaction.statusDescription,
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Text(transaction.createdAt),
                  Spacer(),
                  RatingBar.builder(
                    initialRating: transaction.rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemSize: 15.0,
                    itemCount: 5,
                    ignoreGestures: true,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (double value) {},
                  ),
                  SizedBox(width: 5.0),
                  Text(transaction.rating.toString()),
                ],
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
