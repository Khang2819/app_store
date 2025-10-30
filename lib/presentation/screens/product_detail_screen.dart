import 'package:bloc_app/data/models/product_model.dart';
import 'package:bloc_app/presentation/widgets/home_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';

import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../bloc/navigation/navigation_bloc.dart';
import '../bloc/navigation/navigation_event.dart';
import '../bloc/product_detail/product_detail_bloc.dart';
// THÊM IMPORT NÀY
import '../bloc/product_detail/product_detail_event.dart';
import '../bloc/product_detail/product_detail_state.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/imagrecarousel.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductDetailBloc, ProductDetailState>(
      listener: (context, state) {
        if (state.addToCartSuccess) {
          // 1. Tải lại giỏ hàng
          context.read<CartBloc>().add(LoadCart());
          // 2. Chuyển sang tab giỏ hàng (tab index 2)
          context.read<NavigationBloc>().add(const TabChanged(tabIndex: 2));
          // 3. Đóng màn hình chi tiết sản phẩm
          context.pop();
          // 4. Reset trạng thái để không bị lặp lại
          context.read<ProductDetailBloc>().add(ResetAddToCartStatus());
        }

        // (Tùy chọn) Hiển thị lỗi nếu có
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi: ${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
          // 4. Reset trạng thái lỗi
          context.read<ProductDetailBloc>().add(ResetAddToCartStatus());
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xffFFF8F0),
        appBar: const HomeAppbar(
          title: 'Chi tiết sản phẩm',
          showBackButton: true,
        ),
        body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
          builder: (context, state) {
            if (state.isLoading && state.product == null) {
              // Chỉ loading toàn màn hình khi chưa có data
              return const Center(
                child: CircularProgressIndicator(color: Color(0xff2A4ECA)),
              );
            }

            // Tính toán rating trung bình
            final double averageRating =
                state.reviews.isNotEmpty
                    ? state.reviews
                            .map((r) => r.rating)
                            .reduce((a, b) => a + b) /
                        state.reviews.length
                    : 0.0;

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Imagecarousel(product: product),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Đơn giá: ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: _formatPrice(product.price),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Sử dụng rating trung bình từ state
                          if (averageRating > 0)
                            Row(
                              children: [
                                Text(
                                  averageRating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                RatingBarIndicator(
                                  rating: averageRating,
                                  itemBuilder:
                                      (context, index) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                  itemCount: 5,
                                  itemSize: 20,
                                  direction: Axis.horizontal,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '(${state.reviews.length} đánh giá)',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          Divider(color: Colors.grey[300]),
                          const SizedBox(height: 10),
                          const Text(
                            'Mô tả sản phẩm',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            product.description.isNotEmpty
                                ? product.description
                                : 'Chưa có mô tả cho sản phẩm này.',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                          Divider(color: Colors.grey[300]),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Bình luận khách hàng',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Nút "Xem tất cả" có thể ẩn đi nếu muốn
                              // TextButton(
                              //   onPressed: () {},
                              //   child: const Text(
                              //     'Xem tất cả',
                              //     style: TextStyle(color: Color(0xff2A4ECA)),
                              //   ),
                              // ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // ===== BẮT ĐẦU PHẦN CẬP NHẬT LOGIC REVIEW =====

                          // 1. Hiển thị danh sách reviews
                          if (state.reviews.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                              ),
                              child: Center(
                                child: Text(
                                  'Chưa có đánh giá nào',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ),
                            )
                          else
                            // Hiển thị các review
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.reviews.length,
                              itemBuilder: (context, index) {
                                final review = state.reviews[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  elevation: 0,
                                  color: Colors.white.withOpacity(0.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      review.userName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(review.comment),
                                    trailing: RatingBarIndicator(
                                      rating: review.rating,
                                      itemBuilder:
                                          (context, index) => const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                      itemCount: 5,
                                      itemSize: 16,
                                    ),
                                  ),
                                );
                              },
                            ),

                          const SizedBox(height: 16),

                          // 2. Hiển thị Form nhập hoặc Thông báo
                          if (state.canReview)
                            _ReviewInputSection(productId: product.id)
                          else
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.yellow[100],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.orange.shade200,
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Colors.orange,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      "Chỉ khách hàng đã mua sản phẩm này mới có thể đánh giá.",
                                      style: TextStyle(color: Colors.black87),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // ===== KẾT THÚC PHẦN CẬP NHẬT LOGIC REVIEW =====
                          const SizedBox(height: 16),
                          Divider(color: Colors.grey[300]),
                          const Text(
                            'Các sản phẩm có liên quan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // (Thêm code hiển thị sản phẩm liên quan ở đây)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<ProductDetailBloc, ProductDetailState>(
          builder: (context, state) {
            return BottomBar(quantity: state.quantity, productId: product.id);
          },
        ),
      ),
    );
  }

  String _formatPrice(int price) {
    return '${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ';
  }
}

/// Widget con cho form nhập review
class _ReviewInputSection extends StatefulWidget {
  final String productId;
  const _ReviewInputSection({required this.productId});

  @override
  State<_ReviewInputSection> createState() => _ReviewInputSectionState();
}

class _ReviewInputSectionState extends State<_ReviewInputSection> {
  final TextEditingController _commentController = TextEditingController();
  double _currentRating = 5.0; // Điểm rating mặc định

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitReview() {
    if (_commentController.text.isEmpty) {
      // (Bạn có thể hiển thị thông báo lỗi nếu cần)
      return;
    }
    // Gửi event lên BLoC
    context.read<ProductDetailBloc>().add(
      AddReview(
        productId: widget.productId,
        rating: _currentRating,
        comment: _commentController.text,
      ),
    );
    // Xóa text và ẩn bàn phím
    _commentController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Viết đánh giá của bạn',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            // Thanh chọn sao
            RatingBar.builder(
              initialRating: _currentRating,
              minRating: 1,
              direction: Axis.horizontal,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder:
                  (context, _) => const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) {
                setState(() {
                  _currentRating = rating;
                });
              },
            ),
            const SizedBox(height: 12),
            // Ô nhập bình luận
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Nhập bình luận của bạn...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            // Nút Gửi
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _submitReview,
                icon: const Icon(Icons.send),
                label: const Text('Gửi đánh giá'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2A4ECA),
                  foregroundColor: Colors.white, // Thêm màu chữ cho nút
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
