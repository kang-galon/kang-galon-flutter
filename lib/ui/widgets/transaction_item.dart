import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kang_galon/core/models/models.dart';
import 'package:kang_galon/ui/config/pallette.dart';
import 'package:shimmer/shimmer.dart';

class TransactionItem extends StatelessWidget {
  final Transaction? transaction;
  final VoidCallback? onTap;
  final bool isLoading;

  TransactionItem({
    required this.transaction,
    required this.onTap,
  }) : this.isLoading = false;

  TransactionItem.loading()
      : this.transaction = null,
        this.onTap = null,
        this.isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Stack(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 7.0, vertical: 10.0),
            decoration: Pallette.containerDecoration,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            transaction!.depotName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                          Icon(Icons.chevron_right),
                        ],
                      ),
                const SizedBox(height: 5.0),
                isLoading
                    ? Shimmer.fromColors(
                        baseColor: Pallette.shimmerBaseColor,
                        highlightColor: Pallette.shimmerHighlightColor,
                        child: Container(
                          height: 30.0,
                          decoration: BoxDecoration(
                            color: Pallette.shimmerBaseColor,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction!.statusDescription,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            children: [
                              Text(transaction!.createdAt),
                              const Spacer(),
                              RatingBar.builder(
                                initialRating: transaction!.rating,
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
                              Text(transaction!.rating.toString()),
                            ],
                          ),
                        ],
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
