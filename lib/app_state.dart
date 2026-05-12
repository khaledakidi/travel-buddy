import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/db/app_database.dart';
import '../data/model/place.dart';

class AppState extends ChangeNotifier {
  // Saved places
  List<Place> _savedPlaces = [];
  List<Place> get savedPlaces => _savedPlaces;

  // Active filter
  String _activeFilter = 'all';
  String get activeFilter => _activeFilter;

  // Search query
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  // Student mode
  bool _studentMode = true;
  bool get studentMode => _studentMode;

  // User stats
  int _xp    = 0;
  int _level = 1;
  int _streak = 0;
  int _shared = 0;
  int get xp     => _xp;
  int get level  => _level;
  int get streak => _streak;
  int get shared => _shared;

  AppState() {
    _load();
  }

  Future<void> _load() async {
    await _loadSavedPlaces();
    await _loadStats();
    await _loadPrefs();
  }

  Future<void> _loadSavedPlaces() async {
    _savedPlaces = await AppDatabase.getSavedPlaces();
    notifyListeners();
  }

  Future<void> _loadStats() async {
    final s = await AppDatabase.getUserStats();
    _xp     = s['xp'] as int;
    _level  = s['level'] as int;
    _streak = s['streak'] as int;
    _shared = (s['shared'] as int?) ?? 0;
    notifyListeners();
  }

  Future<void> recordShare() async {
    await AppDatabase.incrementShare();
    await _loadStats();
  }

  // ── Badge unlock logic (single source of truth) ──

  int get visitedCount => _savedPlaces.where((p) => p.isVisited).length;
  int get foodVisits        => _savedPlaces.where((p) => p.isVisited && p.category == 'food').length;
  int get attractionVisits  => _savedPlaces.where((p) => p.isVisited && p.category == 'attractions').length;
  int get nightlifeVisits   => _savedPlaces.where((p) => p.isVisited && p.category == 'nightlife').length;
  int get discountsUsed     => _savedPlaces.where((p) => p.isVisited && p.hasStudentDiscount).length;

  bool get hasFirstVisit     => visitedCount >= 1;
  bool get hasFiveSaved      => _savedPlaces.length >= 5;
  bool get hasFoodie         => foodVisits >= 5;
  bool get hasCultureVulture => attractionVisits >= 5;
  bool get hasNightOwl       => nightlifeVisits >= 3;
  bool get hasBudgetPro      => discountsUsed >= 5;

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _studentMode = prefs.getBool('studentMode') ?? true;
    notifyListeners();
  }

  // ── Filters ──────────────────────────────────────

  void setFilter(String filter) {
    _activeFilter = filter;
    notifyListeners();
  }

  void setSearchQuery(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  List<Place> filteredPlaces(List<Place> all) {
    return all.where((p) {
      final matchCat = _activeFilter == 'all' || p.category == _activeFilter;
      final matchQ   = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.address.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchCat && matchQ;
    }).toList();
  }

  // ── Save / Unsave ────────────────────────────────

  bool isSaved(String id) => _savedPlaces.any((p) => p.id == id);

  Future<void> toggleSave(Place place) async {
    if (isSaved(place.id)) {
      await AppDatabase.unsavePlace(place.id);
      _savedPlaces.removeWhere((p) => p.id == place.id);
    } else {
      final toSave = place.copyWith(isSaved: true);
      await AppDatabase.savePlace(toSave);
      _savedPlaces.insert(0, toSave);
    }
    await _loadStats();
    notifyListeners();
  }

  // ── Mark Visited ─────────────────────────────────

  bool isVisited(String id) => _savedPlaces.any((p) => p.id == id && p.isVisited);

  Future<void> markVisited(String placeId) async {
    if (!isSaved(placeId)) return;
    await AppDatabase.markVisited(placeId);
    final idx = _savedPlaces.indexWhere((p) => p.id == placeId);
    if (idx != -1) {
      _savedPlaces[idx] = _savedPlaces[idx].copyWith(isVisited: true);
    }
    await _loadStats();
    notifyListeners();
  }

  // ── Settings ─────────────────────────────────────

  Future<void> setStudentMode(bool value) async {
    _studentMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('studentMode', value);
    notifyListeners();
  }
}
