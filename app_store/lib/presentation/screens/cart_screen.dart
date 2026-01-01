import 'package:go_router/go_router.dart';
import 'package:shop_core/l10n/app_localizations.dart';
import 'package:bloc_app/presentation/bloc/cart/cart_bloc.dart';
import 'package:bloc_app/presentation/bloc/cart/cart_state.dart';
import 'package:bloc_app/presentation/widgets/cart_item_card.dart';
import 'package:bloc_app/presentation/widgets/home_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cart/cart_event.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    // ✅ Load cart khi vào màn hình
    context.read<CartBloc>().add(LoadCart());
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Color(0xffFFF8F0),
      appBar: HomeAppbar(title: language.cart),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          // Trạng thái Loading
          if (state is CartLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xff2A4ECA)),
            );
          }

          // Trạng thái Lỗi
          if (state is CartError) {
            return Center(
              child: Text(
                'Lỗi: ${state.message}',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          // Trạng thái Trống
          if (state is CartEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    language.cart_empty,
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                ],
              ),
            );
          }

          // Trạng thái Đã tải (CartLoaded)
          if (state is CartLoaded) {
            return Column(
              children: [
                // Danh sách sản phẩm
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return CartItemCard(item: item);
                    },
                  ),
                ),
                // Thanh tổng tiền và Checkout
                _buildSummary(context, state.totalPrice, language),
              ],
            );
          }

          // Trạng thái mặc định (không bao giờ xảy ra)
          return const Center(child: Text('Trạng thái không xác định'));
        },
      ),
    );
  }

  Widget _buildSummary(
    BuildContext context,
    int totalPrice,
    AppLocalizations language,
  ) {
    String formatPrice(int price) {
      return '${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ';
    }

    return Container(
      padding: const EdgeInsets.all(
        16.0,
      ).copyWith(bottom: MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Tổng tiền
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                language.total,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                formatPrice(totalPrice),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          // Nút Checkout
          ElevatedButton(
            onPressed: () {
              context.push('/checkout', extra: totalPrice);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff7F5539), // Màu từ bottom_bar
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              language.checkout,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
