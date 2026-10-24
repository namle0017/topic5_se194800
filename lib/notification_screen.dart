import 'package:flutter/material.dart';

import 'game_state.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  // Câu 8
  (IconData, Color) _styleFor(GameNotificationType type) => switch (type) {
        GameNotificationType.deposit =>
          (Icons.account_balance_wallet, Colors.greenAccent),
        GameNotificationType.bet => (Icons.sports_esports, Colors.cyanAccent),
        GameNotificationType.win => (Icons.emoji_events, Colors.amberAccent),
        GameNotificationType.loss =>
          (Icons.sentiment_dissatisfied, Colors.orangeAccent),
        GameNotificationType.system => (Icons.info, Colors.purpleAccent),
      };

  // Câu 9
  String _formatDate(DateTime dateTime) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    final date =
        '${twoDigits(dateTime.day)}/${twoDigits(dateTime.month)}/${dateTime.year}';
    final time =
        '${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}:${twoDigits(dateTime.second)}';
    return '$date $time';
  }

  @override
  Widget build(BuildContext context) {
    final state = GameState.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('THÔNG BÁO'),
        centerTitle: true,
        backgroundColor: const Color(0xFF141E30),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Đổi thứ tự sắp xếp',
            icon: const Icon(Icons.sort),
            onPressed: state.toggleSortOrder,
          ),
          IconButton(
            tooltip: 'Xóa tất cả',
            icon: const Icon(Icons.delete_sweep),
            onPressed: state.clearNotifications,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Thêm thông báo thử',
        onPressed: () => state.addNotification(GameNotification(
          title: 'Thông báo mới',
          message: 'Thông báo thêm lúc ứng dụng đang chạy.',
          type: GameNotificationType.values[
              DateTime.now().second % GameNotificationType.values.length],
        )),
        child: const Icon(Icons.add),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF141E30), Color(0xFF243B55)],
          ),
        ),
        // Câu 10
        child: AnimatedBuilder(
          animation: state,
          builder: (context, _) {
            final notifications = state.notifications;
            if (notifications.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.notifications_none,
                        size: 64, color: Colors.white54),
                    SizedBox(height: 12),
                    Text(
                      'Chưa có thông báo nào',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                final (icon, color) = _styleFor(notification.type);
                final read = notification.isRead;
                return Opacity(
                  opacity: read ? 0.55 : 1,
                  child: Card(
                    color: Colors.white.withValues(alpha: 0.09),
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: color.withValues(alpha: 0.45)),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      onTap: () => state.toggleRead(notification),
                      leading: CircleAvatar(
                        backgroundColor: color.withValues(alpha: 0.18),
                        child: Icon(icon, color: color),
                      ),
                      title: Text(
                        notification.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight:
                              read ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          '${notification.message}\n${_formatDate(notification.createdAt)}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                      trailing: IconButton(
                        tooltip: 'Xóa',
                        icon: const Icon(Icons.close, color: Colors.white54),
                        onPressed: () => state.removeNotification(notification),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
