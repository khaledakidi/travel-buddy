import 'package:flutter_test/flutter_test.dart';
import 'package:travel_buddy/data/model/place.dart';

// Pure filtering helper replicated for tests — mirrors AppState.filteredPlaces.
List<Place> filter(List<Place> all, {String cat = 'all', String q = ''}) {
  return all.where((p) {
    final matchCat = cat == 'all' || p.category == cat;
    final matchQ = q.isEmpty ||
        p.name.toLowerCase().contains(q.toLowerCase()) ||
        p.address.toLowerCase().contains(q.toLowerCase());
    return matchCat && matchQ;
  }).toList();
}

void main() {
  group('Category filter (T04)', () {
    test("'all' returns everything", () {
      expect(filter(demoPlaces, cat: 'all').length, demoPlaces.length);
    });

    test("'food' returns only food places", () {
      final result = filter(demoPlaces, cat: 'food');
      expect(result.isNotEmpty, true);
      expect(result.every((p) => p.category == 'food'), true);
    });

    test("'attractions' returns only attractions", () {
      final result = filter(demoPlaces, cat: 'attractions');
      expect(result.every((p) => p.category == 'attractions'), true);
    });
  });

  group('Search filter (T05)', () {
    test("'bazaar' finds Grand Bazaar", () {
      final result = filter(demoPlaces, q: 'bazaar');
      expect(result.any((p) => p.name == 'Grand Bazaar'), true);
    });

    test('case-insensitive match', () {
      final lower = filter(demoPlaces, q: 'galata');
      final upper = filter(demoPlaces, q: 'GALATA');
      expect(lower.length, upper.length);
      expect(lower.isNotEmpty, true);
    });

    test('searches address too', () {
      final result = filter(demoPlaces, q: 'Sultanahmet');
      // Multiple places have Sultanahmet in address
      expect(result.length, greaterThan(1));
    });

    test('empty search returns all', () {
      expect(filter(demoPlaces, q: '').length, demoPlaces.length);
    });
  });

  group('Combined filter', () {
    test('category + search narrow results', () {
      final result = filter(demoPlaces, cat: 'attractions', q: 'sultanahmet');
      expect(result.every((p) =>
          p.category == 'attractions' &&
          p.address.toLowerCase().contains('sultanahmet')), true);
    });
  });
}
