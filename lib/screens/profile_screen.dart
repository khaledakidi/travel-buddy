import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../data/db/app_database.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final saved    = state.savedPlaces.length;
    final visited  = state.visitedCount;
    final sharedC  = state.shared;
    final xp       = state.xp;
    final level    = state.level;
    final streak   = state.streak;
    final nextXP   = AppDatabase.xpForNextLevel(level);
    final progress = xp / nextXP;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(title: const Text('Profile'), backgroundColor: Colors.white, elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Profile card ──────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1a2744), Color(0xFF334155)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(children: [
                  Container(
                    width: 56, height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: const Center(child: Text('👤', style: TextStyle(fontSize: 26))),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const Text('Traveler',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                          const SizedBox(width: 8),
                          if (streak > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFf59e0b).withOpacity(0.25),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text('🔥 $streak',
                                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                            ),
                        ]),
                        Text('Istanbul · Level $level',
                            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
                        const SizedBox(height: 6),
                        // XP progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress.clamp(0.0, 1.0),
                            backgroundColor: Colors.white.withOpacity(0.2),
                            valueColor: const AlwaysStoppedAnimation(Color(0xFFf59e0b)),
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('$xp / $nextXP XP',
                            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 10)),
                      ],
                    ),
                  ),
                ]),
                const SizedBox(height: 16),
                // Stats row
                Row(children: [
                  _statBox('$saved',   'Saved'),
                  _statBox('$visited', 'Visited'),
                  _statBox('$sharedC', 'Shared'),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Achievements ─────────────────────────────
          _sectionLabel('ACHIEVEMENTS'),
          const SizedBox(height: 8),
          _buildBadges(state),
          const SizedBox(height: 16),

          // ── Preferences ──────────────────────────────
          _sectionLabel('PREFERENCES'),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 1,
            child: Column(children: [
              SwitchListTile(
                value: state.studentMode,
                onChanged: state.setStudentMode,
                title: const Text('Student Mode', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('Show student discounts and budget options'),
                secondary: const Icon(Icons.school_outlined, color: Color(0xFF16a34a)),
                activeColor: const Color(0xFF2563eb),
              ),
              const Divider(height: 0),
              SwitchListTile(
                value: true,
                onChanged: (_) {},
                title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('Get alerts for nearby deals'),
                secondary: const Icon(Icons.notifications_outlined, color: Color(0xFF64748b)),
                activeColor: const Color(0xFF2563eb),
              ),
            ]),
          ),
          const SizedBox(height: 16),

          // ── General ───────────────────────────────────
          _sectionLabel('GENERAL'),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 1,
            child: Column(children: [
              _settingRow(Icons.language_outlined, 'Language', 'English'),
              const Divider(height: 0),
              _settingRow(Icons.brightness_6_outlined, 'Appearance', 'Light'),
              const Divider(height: 0),
              _settingRow(Icons.star_outline, 'Rate App', ''),
              const Divider(height: 0),
              _settingRow(Icons.mail_outline, 'Contact Us', ''),
            ]),
          ),
          const SizedBox(height: 24),

          const Center(
            child: Text('Travel Buddy v1.0  ·  Made with ❤️',
                style: TextStyle(fontSize: 12, color: Color(0xFF94a3b8))),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _statBox(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(children: [
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.6))),
        ]),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(text,
        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700,
            color: Color(0xFF94a3b8), letterSpacing: 0.8));
  }

  Widget _buildBadges(AppState state) {
    final badges = [
      {'label': 'First Visit',     'icon': '🏆', 'desc': 'Visit your first place',  'unlocked': state.hasFirstVisit,     'color': const Color(0xFFf59e0b)},
      {'label': '5 Saved',         'icon': '❤️',  'desc': 'Save 5 places',          'unlocked': state.hasFiveSaved,      'color': const Color(0xFF2563eb)},
      {'label': 'Foodie',          'icon': '🍽',  'desc': 'Visit 5 food places',     'unlocked': state.hasFoodie,         'color': const Color(0xFFea580c)},
      {'label': 'Culture Vulture', 'icon': '🏛',  'desc': 'Visit 5 attractions',     'unlocked': state.hasCultureVulture, 'color': const Color(0xFF7c3aed)},
      {'label': 'Night Owl',       'icon': '🌙',  'desc': 'Visit 3 nightlife spots', 'unlocked': state.hasNightOwl,       'color': const Color(0xFF0891b2)},
      {'label': 'Budget Pro',      'icon': '💰',  'desc': 'Use 5 student discounts', 'unlocked': state.hasBudgetPro,      'color': const Color(0xFF16a34a)},
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: badges.map((b) {
        final unlocked = b['unlocked'] as bool;
        final color    = b['color'] as Color;
        return Tooltip(
          message: b['desc'] as String,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: unlocked ? color.withOpacity(0.12) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: unlocked ? color.withOpacity(0.4) : const Color(0xFFe2e8f0)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(b['icon'] as String,
                  style: TextStyle(fontSize: 16, color: unlocked ? null : const Color(0xFFcbd5e1))),
              const SizedBox(width: 6),
              Text(b['label'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: unlocked ? color : const Color(0xFFcbd5e1),
                  )),
            ]),
          ),
        );
      }).toList(),
    );
  }

  Widget _settingRow(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF64748b), size: 22),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      trailing: value.isNotEmpty
          ? Text(value, style: const TextStyle(color: Color(0xFF94a3b8), fontSize: 13))
          : const Icon(Icons.chevron_right, color: Color(0xFF94a3b8)),
    );
  }
}
