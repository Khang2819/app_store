import 'package:flutter/material.dart';
import 'package:shop_core/shop_core.dart';

class HeaderAdmin extends StatefulWidget {
  const HeaderAdmin({super.key});

  @override
  State<HeaderAdmin> createState() => _HeaderAdminState();
}

class _HeaderAdminState extends State<HeaderAdmin> {
  bool hasNotifications = true;
  int notificationCount = 3;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side - Search bar
          Expanded(
            child: StreamBuilder<DateTime>(
              stream: Timenow.streamTime(),
              builder: (context, snapshot) {
                final now = snapshot.data ?? DateTime.now();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Hiện tại là ",
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          Timenow.getTimeOfDay(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Timenow.getTimeIcon(),
                          color: Timenow.getTimeColor(),
                        ),
                      ],
                    ),
                    Text(
                      Timenow.formatTime(now),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Right side - Actions
          Row(
            children: [
              const SizedBox(width: 16),

              // Notifications
              _buildNotificationButton(),

              const SizedBox(width: 12),

              // Messages
              _buildIconButton(
                icon: Icons.mail_outline,
                onPressed: () {
                  _showComingSoonSnackBar(context, 'Tin nhắn');
                },
              ),

              const SizedBox(width: 12),

              // Settings
              _buildIconButton(
                icon: Icons.settings_outlined,
                onPressed: () {
                  _showComingSoonSnackBar(context, 'Cài đặt');
                },
              ),

              const SizedBox(width: 16),

              // Divider
              Container(height: 32, width: 1, color: Colors.grey[300]),

              const SizedBox(width: 16),

              // Profile
              _buildProfileButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationButton() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: Colors.grey[700],
              size: 22,
            ),
            onPressed: () {
              _showNotificationsMenu(context);
            },
            tooltip: 'Thông báo',
          ),
        ),
        if (hasNotifications)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red.shade400, Colors.red.shade600],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text(
                notificationCount > 9 ? '9+' : '$notificationCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.grey[700], size: 22),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildProfileButton() {
    return InkWell(
      onTap: () {
        _showProfileMenu(context);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.purple.shade400],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.transparent,
                child: Text(
                  'A',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Admin User',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Administrator',
                  style: TextStyle(color: Colors.grey[500], fontSize: 11),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Icon(Icons.keyboard_arrow_down, color: Colors.grey[600], size: 20),
          ],
        ),
      ),
    );
  }

  void _showNotificationsMenu(BuildContext context) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        MediaQuery.of(context).size.width,
        80,
        20,
        0,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: [
        PopupMenuItem(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Thông báo',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        hasNotifications = false;
                        notificationCount = 0;
                      });
                    },
                    child: const Text(
                      'Đánh dấu đã đọc',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              const Divider(),
            ],
          ),
        ),
        ..._buildNotificationItems(),
        PopupMenuItem(
          child: Center(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Xem tất cả'),
            ),
          ),
        ),
      ],
    );
  }

  List<PopupMenuItem> _buildNotificationItems() {
    final notifications = [
      {
        'icon': Icons.person_add,
        'color': Colors.blue,
        'title': 'User mới đăng ký',
        'message': 'Nguyễn Văn A vừa tạo tài khoản',
        'time': '5 phút trước',
      },
      {
        'icon': Icons.shopping_cart,
        'color': Colors.green,
        'title': 'Đơn hàng mới',
        'message': 'Đơn hàng #12345 cần xử lý',
        'time': '15 phút trước',
      },
      {
        'icon': Icons.warning,
        'color': Colors.orange,
        'title': 'Cảnh báo hệ thống',
        'message': 'Dung lượng server đạt 85%',
        'time': '1 giờ trước',
      },
    ];

    return notifications.map((notif) {
      return PopupMenuItem(
        child: Container(
          width: 300,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (notif['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  notif['icon'] as IconData,
                  color: notif['color'] as Color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notif['title'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      notif['message'] as String,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      notif['time'] as String,
                      style: TextStyle(color: Colors.grey[500], fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      );
    }).toList();
  }

  void _showProfileMenu(BuildContext context) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        MediaQuery.of(context).size.width,
        80,
        20,
        0,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: [
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.person_outline, size: 20, color: Colors.grey[700]),
              const SizedBox(width: 12),
              const Text('Tài khoản của tôi'),
            ],
          ),
          onTap: () {
            Future.delayed(Duration.zero, () {
              _showComingSoonSnackBar(context, 'Tài khoản');
            });
          },
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.settings_outlined, size: 20, color: Colors.grey[700]),
              const SizedBox(width: 12),
              const Text('Cài đặt'),
            ],
          ),
          onTap: () {
            Future.delayed(Duration.zero, () {
              _showComingSoonSnackBar(context, 'Cài đặt');
            });
          },
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.help_outline, size: 20, color: Colors.grey[700]),
              const SizedBox(width: 12),
              const Text('Trợ giúp'),
            ],
          ),
          onTap: () {
            Future.delayed(Duration.zero, () {
              _showComingSoonSnackBar(context, 'Trợ giúp');
            });
          },
        ),
        const PopupMenuItem(height: 1, enabled: false, child: Divider()),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.logout, size: 20, color: Colors.red[600]),
              const SizedBox(width: 12),
              Text('Đăng xuất', style: TextStyle(color: Colors.red[600])),
            ],
          ),
          onTap: () {
            Future.delayed(Duration.zero, () {
              _showLogoutDialog(context);
            });
          },
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.logout,
                    color: Colors.red.shade700,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text('Xác nhận đăng xuất'),
              ],
            ),
            content: const Text('Bạn có chắc muốn đăng xuất khỏi hệ thống?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Đã đăng xuất thành công'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Đăng xuất'),
              ),
            ],
          ),
    );
  }

  void _showComingSoonSnackBar(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature đang được phát triển...'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
