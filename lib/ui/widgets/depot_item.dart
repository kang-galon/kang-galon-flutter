import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kang_galon/core/models/depot.dart';

class DepotItem extends StatelessWidget {
  final Depot depot;
  final Function onTap;

  DepotItem({
    @required this.depot,
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
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Image(
                  width: 70.0,
                  height: 70.0,
                  fit: BoxFit.fill,
                  image: depot.image == null
                      ? AssetImage('assets/images/shop.png')
                      : CachedNetworkImageProvider(depot.image),
                ),
              ),
              const SizedBox(width: 10.0),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(depot.name),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15.0,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      this.depot.address,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Icon(
                          Icons.room,
                          size: 20.0,
                          color: Colors.blueGrey,
                        ),
                        const SizedBox(width: 2.0),
                        Text(
                          '${depot.distance} km',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
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
                        const SizedBox(width: 5.0),
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
