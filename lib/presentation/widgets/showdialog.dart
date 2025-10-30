import 'package:flutter/material.dart';

class AppDialog {
  static Future<void> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Hủy', style: TextStyle(fontSize: 16)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onConfirm();
              },
              child: const Text(
                'Xác nhận',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }
}
