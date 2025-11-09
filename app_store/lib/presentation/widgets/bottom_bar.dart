import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_detail/product_detail_bloc.dart';
import '../bloc/product_detail/product_detail_event.dart';

class BottomBar extends StatelessWidget {
  final int quantity;
  final String productId;
  const BottomBar({super.key, required this.quantity, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0).copyWith(bottom: 24),
      decoration: BoxDecoration(
        color: Color(0xffFFF8F1),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  context.read<ProductDetailBloc>().add(
                    QuantityChanged(quantity - 1),
                  );
                },
                icon: Icon(Icons.remove_circle_outline),
                color: Colors.grey,
              ),
              Text(
                '$quantity',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              IconButton(
                onPressed: () {
                  context.read<ProductDetailBloc>().add(
                    QuantityChanged(quantity + 1),
                  );
                },
                icon: Icon(Icons.add_circle_outline),
                color: Colors.grey,
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () {
              context.read<ProductDetailBloc>().add(
                AddToCart(productId: productId, quantity: quantity),
              );
            },
            icon: Icon(Icons.shopping_cart_outlined),
            label: Text('Thêm vào giỏ hàng'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Color(0xff7F5539),
            ),
          ),
        ],
      ),
    );
  }
}
