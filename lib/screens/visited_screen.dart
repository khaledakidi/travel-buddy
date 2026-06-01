import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../theme.dart';
import '../strings.dart';
import '../widgets/place_card.dart';
import '../widgets/place_detail_sheet.dart';

class VisitedScreen extends StatelessWidget {
  const VisitedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final c = AppColors.of(state.darkMode);
    final s = AppStrings(state.language);
    final visited = state.savedPlaces.where((p) => p.isVisited).toList();

    return Scaffold(
      backgroundColor: c.scaffold,
      appBar: AppBar(title: Text(s.visitedTitle)),
      body: visited.isEmpty
          ? _buildEmpty(c, s)
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF16a34a), Color(0xFF15803d)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(children: [
                    const Text('✅', style: TextStyle(fontSize: 22)),
                    const SizedBox(width: 10),
                    Text(s.visitedCountLabel(visited.length),
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                  ]),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                    itemCount: visited.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => PlaceCard(
                      place: visited[i],
                      variant: CardVariant.list,
                      onTap: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        builder: (_) => PlaceDetailSheet(place: visited[i]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmpty(AppColors c, AppStrings s) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 64, color: c.textMuted.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(s.visitedEmptyTitle,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: c.textPrimary)),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(s.visitedEmptyHint,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: c.textMuted)),
          ),
        ],
      ),
    );
  }
}
