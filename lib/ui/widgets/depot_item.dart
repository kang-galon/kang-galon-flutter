import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kang_galon/core/models/depot.dart';

class DepotItem extends StatelessWidget {
  final Depot depot;

  DepotItem({Key key, @required this.depot}) : super(key: key);

  void detailDepotAction() {
    print(depot.image);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: this.detailDepotAction,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: depot.image == null
                    ? Image(
                        width: 70.0,
                        height: 70.0,
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/phone.png'),
                      )
                    : Image.network(
                        depot.image,
                        width: 70.0,
                        height: 70.0,
                        fit: BoxFit.fill,
                      ),
              ),
              SizedBox(width: 10.0),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(depot.name),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15.0,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      this.depot.address,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Text(
                          '${depot.distance} km',
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
            ],
          ),
        ),
      ),
    );
  }
}
