import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snake_game/main.dart';
import 'package:snake_game/ui/screens/game_screen.dart';
import 'package:snake_game/ui/screens/round_intro_screen.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('home shows round 1 for a fresh profile', (tester) async {
    await tester.pumpWidget(const SnakeApp());
    await tester.pumpAndSettle();

    expect(find.text('SNAKE'), findsOneWidget);
    expect(find.text('ROUND 1'), findsOneWidget);
    expect(find.text('PLAY'), findsOneWidget);
  });

  testWidgets('PLAY → round intro → countdown → arena', (tester) async {
    await tester.pumpWidget(const SnakeApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('PLAY'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(RoundIntroScreen), findsOneWidget);

    // The intro counts down 3s, then swaps in the arena. A live Flame
    // GameWidget never "settles", so use fixed pumps from here on.
    for (var i = 0; i < 40; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.byType(GameScreen), findsOneWidget);
    expect(tester.takeException(), isNull);

    // Unmount so no game-loop timers outlive the test.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
