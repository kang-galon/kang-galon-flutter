import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kang_galon/core/models/depot.dart';
import 'package:kang_galon/ui/config/pallette.dart';
import 'package:shimmer/shimmer.dart';

class DepotItem extends StatelessWidget {
  final Depot depot;
  final Function onTap;
  final bool isContainer;
  final bool isLoading;

  DepotItem({
    @required this.depot,
    @required this.onTap,
    this.isContainer = false,
  }) : this.isLoading = false;

  DepotItem.loading({this.isContainer = false})
      : this.depot = null,
        this.onTap = null,
        this.isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isContainer
          ? const EdgeInsets.symmetric(vertical: 5.0)
          : const EdgeInsets.all(0.0),
      child: Stack(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
            decoration: isContainer ? Pallette.containerDecoration : null,
            child: Row(
              children: [
                isLoading
                    ? Shimmer.fromColors(
                        baseColor: Pallette.shimmerBaseColor,
                        highlightColor: Pallette.shimmerHighlightColor,
                        child: Container(
                          width: 70.0,
                          height: 70.0,
                          decoration: BoxDecoration(
                            color: Pallette.shimmerBaseColor,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      )
                    : ClipRRect(
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
                      isLoading
                          ? Shimmer.fromColors(
                              baseColor: Pallette.shimmerBaseColor,
                              highlightColor: Pallette.shimmerHighlightColor,
                              child: Container(
                                height: 15.0,
                                decoration: BoxDecoration(
                                  color: Pallette.shimmerBaseColor,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            )
                          : Row(
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
                      isLoading
                          ? Shimmer.fromColors(
                              baseColor: Pallette.shimmerBaseColor,
                              highlightColor: Pallette.shimmerHighlightColor,
                              child: Container(
                                height: 25.0,
                                decoration: BoxDecoration(
                                  color: Pallette.shimmerBaseColor,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            )
                          : Text(
                              this.depot.address,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                      const SizedBox(height: 10.0),
                      isLoading
                          ? Shimmer.fromColors(
                              baseColor: Pallette.shimmerBaseColor,
                              highlightColor: Pallette.shimmerHighlightColor,
                              child: Container(
                                height: 15.0,
                                decoration: BoxDecoration(
                                  color: Pallette.shimmerBaseColor,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            )
                          : Row(
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
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isLoading ? () {} : onTap,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
