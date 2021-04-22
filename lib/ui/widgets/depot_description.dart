import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kang_galon/core/models/models.dart';
import 'package:kang_galon/ui/pages/pages.dart';

class DepotDescription extends StatelessWidget {
  final Depot depot;
  final bool isDistance;

  DepotDescription({@required this.depot, this.isDistance = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(20.0),
          decoration: Style.containerDecoration,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image(
                      width: 100.0,
                      fit: BoxFit.fitWidth,
                      image: depot.image == null
                          ? AssetImage('assets/images/shop.png')
                          : CachedNetworkImageProvider(depot.image),
                    ),
                  ),
                  SizedBox(width: 5.0),
                  Expanded(child: Text(depot.address)),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Text(
                    isDistance ? '${depot.distance} km' : '',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  RatingBar.builder(
                    initialRating: depot.rating,
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
                  Text(
                    depot.rating.toString(),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 20.0),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(20.0),
          decoration: Style.containerDecoration,
          child: Row(
            children: [
              Text('Per galon '),
              Text(
                depot.priceDesc,
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ],
    );
  }
}
