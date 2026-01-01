import 'package:flutter/material.dart';

class Containerbox extends StatefulWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  const Containerbox({
    super.key,
    required this.color,
    required this.title,
    required this.count,
    required this.icon,
  });

  @override
  State<Containerbox> createState() => _ContainerboxState();
}

class _ContainerboxState extends State<Containerbox> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            // ignore: deprecated_member_use
            color: widget.color.withOpacity(isHover ? 0.2 : 0.1),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: widget.color.withOpacity(isHover ? 0.2 : 0.1),
              blurRadius: isHover ? 25 : 10,
              offset: Offset(0, isHover ? 8 : 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Box
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                // ignore: deprecated_member_use
                color: widget.color.withOpacity(0.1),
              ),
              child: Icon(widget.icon, color: widget.color),
            ),

            const SizedBox(width: 12),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${widget.count}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: widget.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
