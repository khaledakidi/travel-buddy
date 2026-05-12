import 'package:flutter_test/flutter_test.dart';
import 'package:travel_buddy/data/db/app_database.dart';
import 'package:travel_buddy/data/model/place.dart';

void main() {
  group('XP → Level (T15: Level up)', () {
    test('Level 1 covers 0–49 XP', () {
      expect(AppDatabase.calcLevel(0),  1);
      expect(AppDatabase.calcLevel(25), 1);
      expect(AppDatabase.calcLevel(49), 1);
    });

    test('Level 2 starts at 50 XP', () {
      expect(AppDatabase.calcLevel(50),  2);
      expect(AppDatabase.calcLevel(149), 2);
    });

    test('Level 3 starts at 150 XP', () {
      expect(AppDatabase.calcLevel(150), 3);
      expect(AppDatabase.calcLevel(299), 3);
    });

    test('Higher levels', () {
      expect(AppDatabase.calcLevel(300), 4);
      expect(AppDatabase.calcLevel(500), 5);
      expect(AppDatabase.calcLevel(9999), 5);
    });

    test('xpForNextLevel thresholds', () {
      expect(AppDatabase.xpForNextLevel(1), 50);
      expect(AppDatabase.xpForNextLevel(2), 150);
      expect(AppDatabase.xpForNextLevel(3), 300);
      expect(AppDatabase.xpForNextLevel(4), 500);
    });
  });

  group('Place model (T13: Discount badges)', () {
    test('Demo data has 16 Istanbul places', () {
      expect(demoPlaces.length, 16);
    });

    test('Discount places carry discountText', () {
      final discounts = demoPlaces.where((p) => p.hasStudentDiscount);
      expect(discounts.isNotEmpty, true);
      for (final p in discounts) {
        expect(p.discountText, isNotNull);
        expect(p.discountText!.isNotEmpty, true);
      }
    });

    test('Every place has a non-empty emoji per category', () {
      for (final p in demoPlaces) {
        expect(p.emoji.isNotEmpty, true);
      }
    });

    test('Category coverage — proposal lists 7 categories', () {
      final cats = demoPlaces.map((p) => p.category).toSet();
      // At minimum: food, drinks, attractions, shopping, nature, activities, nightlife
      expect(cats.contains('food'), true);
      expect(cats.contains('attractions'), true);
      expect(cats.contains('shopping'), true);
      expect(cats.contains('nightlife'), true);
      expect(cats.contains('nature'), true);
    });
  });

  group('Place serialization (T07: Saved tab persistence)', () {
    test('toMap → fromMap roundtrip preserves fields', () {
      final original = demoPlaces.first;
      final map = original.toMap();
      final restored = Place.fromMap(map);
      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.rating, original.rating);
      expect(restored.category, original.category);
      expect(restored.hasStudentDiscount, original.hasStudentDiscount);
    });

    test('copyWith preserves identity but updates flags', () {
      final p = demoPlaces.first;
      final visited = p.copyWith(isVisited: true);
      expect(visited.id, p.id);
      expect(visited.isVisited, true);
      expect(p.isVisited, false); // original untouched
    });
  });
}
