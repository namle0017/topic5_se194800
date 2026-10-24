import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notification_practice/game_state.dart';
import 'package:notification_practice/main.dart';

void main() {
  testWidgets('shows samples, adds, and clears to empty state',
      (tester) async {
    final state = GameState.instance;
    await tester.pumpWidget(const MyApp());
    expect(find.text('THÔNG BÁO'), findsOneWidget);
    expect(find.text('Nạp tiền thành công'), findsOneWidget);
    expect(find.text('Thắng cược'), findsOneWidget);

    state.addNotification(GameNotification(
      title: 'Mới',
      message: 'm',
      type: GameNotificationType.bet,
      createdAt: DateTime(2099, 1, 2, 3, 4, 5),
    ));
    await tester.pump();
    expect(find.text('Mới'), findsOneWidget);
    expect(find.textContaining('02/01/2099 03:04:05'), findsOneWidget);

    state.clearNotifications();
    await tester.pump();
    expect(find.text('Chưa có thông báo nào'), findsOneWidget);
  });

  testWidgets('one item, colors, read/remove, sort, scroll', (tester) async {
    final state = GameState.instance..clearNotifications();
    await tester.pumpWidget(const MyApp());

    // Một thông báo + đúng icon/màu theo loại.
    state.addNotification(GameNotification(
        title: 'Win', message: 'w', type: GameNotificationType.win));
    await tester.pump();
    expect(find.byType(Card), findsOneWidget);
    final icon = tester.widget<Icon>(find.byIcon(Icons.emoji_events));
    expect(icon.color, Colors.amberAccent);

    // Đánh dấu đã đọc, rồi xóa.
    await tester.tap(find.text('Win'));
    await tester.pump();
    expect(state.notifications.single.isRead, isTrue);
    await tester.tap(find.byTooltip('Xóa'));
    await tester.pump();
    expect(find.text('Chưa có thông báo nào'), findsOneWidget);

    // Sắp xếp theo thời gian.
    state.addNotification(GameNotification(
        title: 'Old', message: '', type: GameNotificationType.bet,
        createdAt: DateTime(2020)));
    state.addNotification(GameNotification(
        title: 'New', message: '', type: GameNotificationType.bet,
        createdAt: DateTime(2030)));
    expect(state.notifications.first.title, 'New');
    state.toggleSortOrder();
    expect(state.notifications.first.title, 'Old');
    state.toggleSortOrder();

    // Cuộn khi danh sách dài: Item 0 cũ nhất, nằm cuối danh sách.
    for (var i = 0; i < 30; i++) {
      state.addNotification(GameNotification(
          title: 'Item $i', message: '', type: GameNotificationType.deposit,
          createdAt: DateTime(2000, 1, 1, 0, 0, i)));
    }
    await tester.pump();
    expect(find.text('Item 0'), findsNothing);
    await tester.scrollUntilVisible(find.text('Item 0'), 300);
    expect(find.text('Item 0'), findsOneWidget);
  });
}
