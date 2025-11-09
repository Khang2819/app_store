import 'package:shop_core/shop_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/review/review_bloc.dart';
import '../bloc/review/review_state.dart';
import '../widgets/home_appbar.dart';
import '../widgets/review_list.dart';

class AllReviewScreen extends StatelessWidget {
  const AllReviewScreen({super.key});

  List<Review> _filterReviews(List<Review> reviews, int star) {
    return reviews.where((review) => review.rating.floor() == star).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFF8F0), // Thêm màu nền cho đồng bộ
      appBar: const HomeAppbar(title: 'Đánh giá', showBackButton: true),
      body: BlocBuilder<ReviewBloc, ReviewState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xff2A4ECA)),
            );
          }

          return DefaultTabController(
            length: 6,
            child: Column(
              children: [
                const TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.center,
                  labelColor: Color(0xff8B5E3C),
                  unselectedLabelColor: Color(0xffDDB892),
                  indicatorColor: Color(0xff8B5E3C),
                  tabs: [
                    Tab(text: 'Tất cả'),
                    Tab(text: '5 ★'),
                    Tab(text: '4 ★'),
                    Tab(text: '3 ★'),
                    Tab(text: '2 ★'),
                    Tab(text: '1 ★'),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: TabBarView(
                    children: [
                      // Tab Tất cả
                      _buildTabContent(state.reviews),
                      // Tab 5 sao
                      _buildTabContent(_filterReviews(state.reviews, 5)),
                      // Tab 4 sao
                      _buildTabContent(_filterReviews(state.reviews, 4)),
                      // Tab 3 sao
                      _buildTabContent(_filterReviews(state.reviews, 3)),
                      // Tab 2 sao
                      _buildTabContent(_filterReviews(state.reviews, 2)),
                      // Tab 1 sao
                      _buildTabContent(_filterReviews(state.reviews, 1)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabContent(List<Review> reviews) {
    if (reviews.isEmpty) {
      return const Center(
        child: Text(
          'Chưa có đánh giá nào',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ReviewList(reviews: reviews),
    );
  }
}
