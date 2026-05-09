import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../widgets/place_card.dart';
import '../widgets/place_detail_sheet.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state  = context.watch<AppState>();
    final places  = state.savedPlaces;
    final visited = places.where((p) => p.isVisited).length;
    final discounts = places.where((p) => p.hasStudentDiscount).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text('My Places'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: places.isEmpty
          ? _buildEmpty()
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildSummary(places.length, visited, discounts)),
                if (discounts > 0)
                  SliverToBoxAdapter(child: _buildDiscountBanner(discounts)),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Dismissible(
                          key: Key(places[i].id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.delete_outline, color: Colors.red),
                          ),
                          onDismissed: (_) {
                            state.toggleSave(places[i]);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Removed from saved'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          child: PlaceCard(
                            place: places[i],
                            variant: CardVariant.list,
                            onTap: () => showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              useSafeArea: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                              ),
                              builder: (_) => PlaceDetailSheet(place: places[i]),
                            ),
                          ),
                        ),
                      ),
                      childCount: places.length,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSummary(int total, int visited, int discounts) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(children: [
        _statBox('$total', 'Saved'),
        const SizedBox(width: 10),
        _statBox('$visited', 'Visited'),
        const SizedBox(width: 10),
        _statBox('$discounts', 'Discounts'),
      ]),
    );
  }

  Widget _statBox(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
        ),
        child: Column(children: [
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1a2744))),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748b))),
        ]),
      ),
    );
  }

  Widget _buildDiscountBanner(int count) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFdcfce7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFa7f3d0)),
      ),
      child: Row(children: [
        const Text('🎓', style: TextStyle(fontSize: 18)),
        const SizedBox(width: 8),
        Text('$count saved place${count > 1 ? 's' : ''} with student discounts',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF065f46))),
      ]),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('No saved places yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1e293b))),
          const SizedBox(height: 8),
          const Text('Tap ♡ on any place to save it here',
              style: TextStyle(fontSize: 14, color: Color(0xFF94a3b8))),
        ],
      ),
    );
  }
}
