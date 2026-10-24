import 'package:flutter/foundation.dart';

/// Câu 3 (+ Câu 14: thêm `system`).
enum GameNotificationType { deposit, bet, win, loss, system }

class GameNotification {
  GameNotification({
    required this.title,
    required this.message,
    required this.type,
    DateTime? createdAt,
    this.isRead = false,
  }) : createdAt = createdAt ?? DateTime.now();

  final String title;
  final String message;
  final GameNotificationType type;
  final DateTime createdAt;
  bool isRead;
}

/// Câu 4: Singleton + ChangeNotifier.
class GameState extends ChangeNotifier {
  GameState._() {
    _seedSamples();
  }

  static final GameState instance = GameState._();

  final List<GameNotification> notifications = [];
  bool newestFirst = true;

  void addNotification(GameNotification notification) {
    notifications.add(notification);
    _sort();
    notifyListeners();
  }

  // ---- Câu 14 ----
  void removeNotification(GameNotification notification) {
    notifications.remove(notification);
    notifyListeners();
  }

  void clearNotifications() {
    notifications.clear();
    notifyListeners();
  }

  void toggleRead(GameNotification notification) {
    notification.isRead = !notification.isRead;
    notifyListeners();
  }

  void toggleSortOrder() {
    newestFirst = !newestFirst;
    _sort();
    notifyListeners();
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  void _sort() {
    notifications.sort((a, b) => newestFirst
        ? b.createdAt.compareTo(a.createdAt)
        : a.createdAt.compareTo(b.createdAt));
  }

  /// Câu 11: dữ liệu mẫu, đủ các loại.
  void _seedSamples() {
    final now = DateTime.now();
    notifications.addAll([
      GameNotification(
        title: 'Nạp tiền thành công',
        message: 'Tài khoản đã được cộng 500.000đ.',
        type: GameNotificationType.deposit,
        createdAt: now.subtract(const Duration(minutes: 40)),
      ),
      GameNotification(
        title: 'Đặt cược thành công',
        message: 'Đã ghi nhận cược ngựa số 3 với số tiền 100.000đ.',
        type: GameNotificationType.bet,
        createdAt: now.subtract(const Duration(minutes: 30)),
      ),
      GameNotification(
        title: 'Thắng cược',
        message: 'Bạn nhận được 250.000đ tiền thưởng.',
        type: GameNotificationType.win,
        createdAt: now.subtract(const Duration(minutes: 20)),
      ),
      GameNotification(
        title: 'Thua cược',
        message: 'Bạn không nhận được tiền thưởng từ lượt cược này.',
        type: GameNotificationType.loss,
        createdAt: now.subtract(const Duration(minutes: 10)),
      ),
      GameNotification(
        title: 'Thông báo hệ thống',
        message: 'Hệ thống bảo trì lúc 02:00 sáng mai.',
        type: GameNotificationType.system,
        createdAt: now,
      ),
    ]);
    _sort();
  }
}
