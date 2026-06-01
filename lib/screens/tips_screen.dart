import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../theme.dart';
import '../strings.dart';

const List<Map<String, dynamic>> kTips = [
  {'title':'Get an Istanbulkart',    'body':'Load a transit card at any kiosk — trams, ferries and buses cost under ₺10 per ride.', 'icon':'🚇', 'tag':'Transport'},
  {'title':'Museum Pass İstanbul',   'body':'Save big with a 5-day pass covering 12+ museums. Students get 50% off the pass itself.','icon':'🎫', 'tag':'Savings'},
  {'title':'Ferry Over Taxi',        'body':'Bosphorus ferries are scenic AND cheap. Kadıköy–Eminönü is the best commute in the city.','icon':'⛴', 'tag':'Transport'},
  {'title':'Eat Like a Local',       'body':'Skip tourist menus. Simit (₺5), kokoreç, and balık-ekmek are street food essentials.','icon':'🥖', 'tag':'Food'},
  {'title':'Free Walking Tours',     'body':'Tip-based tours from Sultanahmet — great for first-timers to orient themselves.','icon':'🚶', 'tag':'Activities'},
  {'title':'Haggle at the Bazaar',   'body':'At the Grand Bazaar, negotiation is expected. Start at 40% of asking price.','icon':'💬', 'tag':'Shopping'},
  {'title':'Best Photo Spots',       'body':'Galata Tower, Pierre Loti Hill, Balat streets, and Çamlıca Hill at sunset.','icon':'📸', 'tag':'Photography'},
  {'title':'Currency Tips',          'body':'Exchange at PTT post offices or Döviz shops — never at the airport.','icon':'💳', 'tag':'Finance'},
  {'title':'Student Museum Free Days','body':'Many Istanbul museums are free for students on the first Sunday of each month.','icon':'🎓', 'tag':'Savings'},
  {'title':'Istanbulkart Discount',  'body':'Students with an e-Devlet verified card get discounted fares automatically.','icon':'🏷',  'tag':'Savings'},
];

class TipsScreen extends StatefulWidget {
  const TipsScreen({super.key});

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  String _activeTag = 'All';
  final List<String> _tags = ['All', 'Transport', 'Savings', 'Food', 'Activities', 'Shopping', 'Photography', 'Finance'];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final c = AppColors.of(state.darkMode);
    final s = AppStrings(state.language);
    final filtered = _activeTag == 'All'
        ? kTips
        : kTips.where((t) => t['tag'] == _activeTag).toList();

    return Scaffold(
      backgroundColor: c.scaffold,
      appBar: AppBar(
        title: Text(s.tipsTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _tags.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final isActive = _activeTag == _tags[i];
                return ChoiceChip(
                  label: Text(s.tagLabel(_tags[i])),
                  selected: isActive,
                  onSelected: (_) => setState(() => _activeTag = _tags[i]),
                  selectedColor: const Color(0xFF1a2744),
                  labelStyle: TextStyle(
                    color: isActive ? Colors.white : c.textSecondary,
                    fontSize: 12, fontWeight: FontWeight.w600,
                  ),
                  backgroundColor: c.surface,
                  side: BorderSide(color: isActive ? Colors.transparent : c.border),
                );
              },
            ),
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: filtered.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) => _buildTipCard(filtered[i], i, c, s),
      ),
    );
  }

  Widget _buildTipCard(Map<String, dynamic> tip, int i, AppColors c, AppStrings s) {
    final gradients = [
      [const Color(0xFFeff6ff), const Color(0xFFbfdbfe)],
      [const Color(0xFFfff7ed), const Color(0xFFfed7aa)],
      [const Color(0xFFecfeff), const Color(0xFFa5f3fc)],
      [const Color(0xFFfffbeb), const Color(0xFFfde68a)],
      [const Color(0xFFfaf5ff), const Color(0xFFe9d5ff)],
      [const Color(0xFFf0fdf4), const Color(0xFFbbf7d0)],
    ];
    final grad = gradients[i % gradients.length];

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: grad, begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Text(tip['icon'] as String, style: const TextStyle(fontSize: 22))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(
                      child: Text(s.tipTitle(tip['title'] as String),
                          style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: c.textPrimary)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFdbeafe),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(s.tagLabel(tip['tag'] as String),
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF1d4ed8))),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  Text(s.tipBody(tip['title'] as String),
                      style: TextStyle(fontSize: 13, color: c.textSecondary, height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
