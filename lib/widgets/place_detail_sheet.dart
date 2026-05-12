import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_state.dart';
import '../data/model/place.dart';

class PlaceDetailSheet extends StatelessWidget {
  final Place place;
  const PlaceDetailSheet({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    final state   = context.watch<AppState>();
    final saved   = state.isSaved(place.id);
    final visited = state.isVisited(place.id);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (_, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: ListView(
          controller: scrollCtrl,
          padding: EdgeInsets.zero,
          children: [
            // Drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 4),
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Hero image
            Container(
              height: 160,
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              decoration: BoxDecoration(
                color: _bgColor(place.category),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(child: Text(place.emoji, style: const TextStyle(fontSize: 64))),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(place.name,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1e293b))),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: place.price == 'Free'
                              ? const Color(0xFFdcfce7)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(place.price,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: place.price == 'Free'
                                  ? const Color(0xFF16a34a)
                                  : const Color(0xFF64748b),
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Rating row
                  Row(children: [
                    ...List.generate(5, (i) => Icon(
                      i < place.rating.floor() ? Icons.star : Icons.star_border,
                      color: const Color(0xFFf59e0b), size: 16,
                    )),
                    const SizedBox(width: 6),
                    Text('${place.rating}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                    Text(' (${(place.reviewCount / 1000).toStringAsFixed(1)}k)',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF94a3b8))),
                  ]),
                  const SizedBox(height: 14),

                  // Info chips
                  Row(children: [
                    _chip(Icons.location_on_outlined, place.address.split(',').first),
                    const SizedBox(width: 8),
                    _chip(Icons.access_time, place.hours),
                  ]),
                  const SizedBox(height: 14),

                  // Student discount banner
                  if (place.hasStudentDiscount) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFdcfce7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFa7f3d0)),
                      ),
                      child: Row(children: [
                        const Text('🎓', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Student Advantage',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF065f46))),
                              Text(place.discountText ?? '',
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF047857))),
                            ],
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 14),
                  ],

                  // Visited status
                  if (visited)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFdcfce7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(children: [
                        Icon(Icons.check_circle, color: Color(0xFF16a34a), size: 18),
                        SizedBox(width: 8),
                        Text("You've visited this place!", style: TextStyle(color: Color(0xFF16a34a), fontWeight: FontWeight.w600)),
                      ]),
                    ),

                  // Mark visited button
                  if (!visited && saved) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await state.markVisited(place.id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('✅ Marked as visited! +10 XP'),
                                backgroundColor: Color(0xFF16a34a),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Mark as Visited  +10 XP'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7c3aed),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],

                  // Save + Share row
                  Row(children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          state.toggleSave(place);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(saved ? '📍 Removed from saved' : '❤️ Saved!'),
                            duration: const Duration(seconds: 1),
                          ));
                        },
                        icon: Icon(saved ? Icons.favorite : Icons.favorite_border),
                        label: Text(saved ? 'Saved' : 'Save Place'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: saved ? const Color(0xFFfef2f2) : const Color(0xFF2563eb),
                          foregroundColor: saved ? const Color(0xFFdc2626) : Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          await _share(place);
                          await state.recordShare();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('📤 Shared! +5 XP'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.share),
                        label: const Text('Share'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 10),

                  // Directions button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _openDirections(place),
                      icon: const Icon(Icons.directions),
                      label: const Text('Get Directions'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF16a34a),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(children: [
        Icon(icon, size: 14, color: const Color(0xFF64748b)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
      ]),
    );
  }

  Future<void> _share(Place p) async {
    final text =
        'Check out ${p.name}!\n'
        '📍 ${p.address}\n'
        '⭐ ${p.rating}/5\n'
        '${p.hasStudentDiscount ? "🎓 ${p.discountText}\n" : ""}'
        'https://maps.google.com/?q=${p.latitude},${p.longitude}';
    await Share.share(text, subject: 'Travel Buddy — ${p.name}');
  }

  Future<void> _openDirections(Place p) async {
    final uri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${p.latitude},${p.longitude}');
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Color _bgColor(String category) {
    switch (category) {
      case 'food':        return const Color(0xFFFFF7ED);
      case 'drinks':      return const Color(0xFFECFEFF);
      case 'attractions': return const Color(0xFFFAF5FF);
      case 'nightlife':   return const Color(0xFFFDF4FF);
      case 'shopping':    return const Color(0xFFFDF2F8);
      case 'nature':      return const Color(0xFFF0FDF4);
      default:            return const Color(0xFFFFFBEB);
    }
  }
}
