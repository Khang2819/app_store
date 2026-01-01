import 'package:flutter/material.dart';

class Fiterchip extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final String currentValue;
  const Fiterchip({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.currentValue,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentValue == value;
    Color color = Colors.grey;
    if (value == 'active') color = Colors.green;
    if (value == 'inactive') color = Colors.orange;
    if (value == 'banned') color = Colors.red;
    if (value == 'all') color = Colors.blue;
    return InkWell(
      onTap: () {},
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
