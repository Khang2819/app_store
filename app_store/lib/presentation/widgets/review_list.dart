import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:shop_core/shop_core.dart';

class ReviewList extends StatelessWidget {
  final List<Review> reviews;
  const ReviewList({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 0,
          // ignore: deprecated_member_use
          color: Colors.white.withOpacity(0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            title: Text(
              review.userName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(review.comment),
            trailing: RatingBarIndicator(
              rating: review.rating,
              itemBuilder:
                  (context, index) =>
                      const Icon(Icons.star, color: Colors.amber),
              itemCount: 5,
              itemSize: 16,
            ),
          ),
        );
      },
    );
  }
}
