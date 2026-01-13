import 'package:flutter/material.dart';

class Fiterchip extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final String currentValue;
  final VoidCallback? onTap;
  const Fiterchip({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.currentValue,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentValue == value;
    Color color = Colors.grey;
    if (value == 'user') color = Colors.green;
    if (value == 'admin') color = Colors.orange;
    if (value == 'banned') color = Colors.red;
    if (value == 'all') color = Colors.blue;

    if (value == 'in_stock') color = Colors.green; // Còn hàng -> Xanh
    if (value == 'out_of_stock') color = Colors.red; // Hết hàng -> Đỏ
    if (value == 'best_seller') color = Colors.purple;

    if (value == 'pending') color = Colors.orange; // Chờ xử lý -> Cam
    if (value == 'shipping') color = Colors.cyan; // Đang giao -> Xanh lơ
    if (value == 'delivered') color = Colors.green; // Hoàn thành -> Xanh lá
    if (value == 'cancelled') color = Colors.red;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient:
              isSelected
                  // ignore: deprecated_member_use
                  ? LinearGradient(colors: [color.withOpacity(0.8), color])
                  : null,
          color: isSelected ? null : Colors.grey[100],
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
