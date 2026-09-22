import 'package:flutter/material.dart';
import 'package:online_learning_application/utils/appcolor.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Mock data for notifications with added color properties
  final List<Map<String, dynamic>> _notifications = [
    {
      'icon': Icons.rocket_launch_rounded,
      'title': 'New Course Available!',
      'message': 'Master Flutter 3.0 with our new comprehensive course.',
      'time': '2 hours ago',
      'isUnread': true,
      'gradient': const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFFC084FC)]),
    },
    {
      'icon': Icons.local_fire_department_rounded,
      'title': 'Limited Time Offer',
      'message': 'Get 50% off on all Data Science courses. Offer ends soon!',
      'time': '1 day ago',
      'isUnread': true,
      'gradient': const LinearGradient(colors: [Color(0xFFF97316), Color(0xFFFBBF24)]),
    },
    {
      'icon': Icons.system_update_rounded,
      'title': 'App Update',
      'message': 'A new version of DhiGrowth is available. Update now for better performance.',
      'time': '3 days ago',
      'isUnread': false,
      'gradient': const LinearGradient(colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)]),
    },
    {
      'icon': Icons.check_circle_rounded,
      'title': 'Course Completed',
      'message': 'Congratulations! You have completed the UI/UX Design course.',
      'time': '1 week ago',
      'isUnread': false,
      'gradient': const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF34D399)]),
    },
  ];

  void _markAllAsRead() {
    setState(() {
      for (var n in _notifications) {
        n['isUnread'] = false;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Notifications'),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: const Text('Mark all read', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: _notifications.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final notif = _notifications[index];
          return _buildNotificationCard(notif);
        },
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notif) {
    final bool isUnread = notif['isUnread'];
    final LinearGradient gradient = notif['gradient'];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isUnread ? gradient.colors.first.withValues(alpha: 0.15) : Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isUnread ? gradient.colors.first.withValues(alpha: 0.3) : AppColors.border,
          width: isUnread ? 1.5 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (isUnread) {
              setState(() {
                notif['isUnread'] = false;
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon with Gradient Background
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: gradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: gradient.colors.first.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(notif['icon'], color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              notif['title'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            notif['time'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                              color: isUnread ? gradient.colors.first : AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notif['message'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textMid,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Unread Indicator
                if (isUnread)
                  Container(
                    margin: const EdgeInsets.only(left: 12, top: 6),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: gradient.colors.first,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: gradient.colors.first.withValues(alpha: 0.5),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
