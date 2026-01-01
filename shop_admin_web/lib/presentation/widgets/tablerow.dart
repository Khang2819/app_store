import 'package:flutter/material.dart';

class TableRowItem extends StatefulWidget {
  final int index;
  final int totalUsers;
  final Widget child;

  const TableRowItem({
    super.key,
    required this.index,
    required this.totalUsers,
    required this.child,
  });

  @override
  State<TableRowItem> createState() => _TableRowItemState();
}

class _TableRowItemState extends State<TableRowItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          (widget.index / widget.totalUsers) * 0.5,
          1.0,
          curve: Curves.easeOut,
        ),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - animation.value)),
          child: Opacity(opacity: animation.value, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
          color:
              widget.index % 2 == 0
                  ? Colors.transparent
                  // ignore: deprecated_member_use
                  : Colors.grey[50]?.withOpacity(0.3),
        ),
        child: widget.child,
      ),
    );
  }
}
