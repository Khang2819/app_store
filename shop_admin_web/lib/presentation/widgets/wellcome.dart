import 'package:flutter/material.dart';

class Wellcome extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? buttonText;
  final IconData? buttonIcon;
  final VoidCallback? onPressed;
  const Wellcome({
    super.key,
    required this.title,
    required this.icon,
    this.buttonText,
    this.buttonIcon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade600, Colors.purple.shade600],
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            // ignore: deprecated_member_use
            color: Colors.blue.withOpacity(0.03),
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.white),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  'Hôm nay: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ],
          ),
          buttonText != null
              ? ElevatedButton.icon(
                onPressed: onPressed,
                label: Text(buttonText!),
                icon: Icon(buttonIcon),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                ),
              )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
