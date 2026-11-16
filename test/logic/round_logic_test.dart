import 'package:flutter_test/flutter_test.dart';
import 'package:snake_game/game/logic/round_logic.dart';

void main() {
  group('RoundLogic.goalForRound', () {
    test('round 1 goal is 20', () {
      expect(RoundLogic.goalForRound(1), 20);
    });

    test('goal increases by 18 each round', () {
      expect(RoundLogic.goalForRound(2), 38);
      expect(RoundLogic.goalForRound(3), 56);
    });
  });

  group('RoundLogic.arenaSizeForRound', () {
    test('round 1 uses base size', () {
      expect(RoundLogic.arenaSizeForRound(1), 2000);
    });

    test('size is capped at 5000', () {
      expect(RoundLogic.arenaSizeForRound(999), 5000);
    });

    test('size never goes below minimum', () {
      expect(RoundLogic.arenaSizeForRound(1), greaterThanOrEqualTo(2000));
    });
  });

  group('RoundLogic.botCountForRound', () {
    test('starts at 3 bots', () {
      expect(RoundLogic.botCountForRound(1), 3);
    });

    test('capped at 12 bots', () {
      expect(RoundLogic.botCountForRound(999), 12);
    });

    test('count never drops below minimum', () {
      for (int i = 1; i <= 20; i++) {
        expect(RoundLogic.botCountForRound(i), greaterThanOrEqualTo(3));
      }
    });
  });

  group('RoundLogic.botDifficultyMixForRound', () {
    test('round 1 is all easy bots', () {
      final mix = RoundLogic.botDifficultyMixForRound(1);
      expect(mix[1], 0); // normal
      expect(mix[2], 0); // hard
    });

    test('mix totals match bot count', () {
      for (int i = 1; i <= 15; i++) {
        final mix = RoundLogic.botDifficultyMixForRound(i);
        final total = mix.reduce((a, b) => a + b);
        expect(
          total,
          RoundLogic.botCountForRound(i),
          reason: 'round $i mix total mismatch',
        );
      }
    });
  });

  group('RoundLogic.stageLabel', () {
    test('round 1 is Hatchling', () {
      expect(RoundLogic.stageLabel(1), 'Hatchling');
    });

    test('round 13 is Apex', () {
      expect(RoundLogic.stageLabel(13), 'Apex');
    });

    test('round 21+ is Endless', () {
      expect(RoundLogic.stageLabel(21), 'Endless');
      expect(RoundLogic.stageLabel(100), 'Endless');
    });
  });
}
