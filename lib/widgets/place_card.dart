import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../data/model/place.dart';

enum CardVariant { grid, list }

class PlaceCard extends StatefulWidget {
  final Place place;
  final CardVariant variant;
  final VoidCallback onTap;

  const PlaceCard({
    super.key,
    required this.place,
    required this.variant,
    required this.onTap,
  });

  @override
  State<PlaceCard> createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _heartCtrl;
  late Animation<double> _heartAnim;

  @override
  void initState() {
    super.initState();
    _heartCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heartAnim = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(_heartCtrl);
  }

  @override
  void dispose() {
    _heartCtrl.dispose();
    super.dispose();
  }

  void _toggleSave(AppState state) {
    _heartCtrl.forward(from: 0);
    state.toggleSave(widget.place);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(state.isSaved(widget.place.id)
          ? '❤️ Saved to your places!'
          : '📍 Removed from saved'),
      duration: const Duration(seconds: 1),
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final saved   = state.isSaved(widget.place.id);
    final visited = state.isVisited(widget.place.id);

    return widget.variant == CardVariant.grid
        ? _buildGrid(state, saved, visited)
        : _buildList(state, saved, visited);
  }

  Widget _buildGrid(AppState state, bool saved, bool visited) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Image placeholder
                Container(
                  height: 110,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _bgColor(widget.place.category),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Center(
                    child: Text(widget.place.emoji, style: const TextStyle(fontSize: 44)),
                  ),
                ),
                // Heart button
                Positioned(
                  top: 8, right: 8,
                  child: ScaleTransition(
                    scale: _heartAnim,
                    child: GestureDetector(
                      onTap: () => _toggleSave(state),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          saved ? Icons.favorite : Icons.favorite_border,
                          color: saved ? Colors.red : Colors.grey,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                // Discount badge
                if (widget.place.hasStudentDiscount)
                  Positioned(
                    top: 8, left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.green[700],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('🎓 Discount',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
                // Visited badge
                if (visited)
                  Positioned(
                    bottom: 8, left: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                      child: const Icon(Icons.check, color: Colors.white, size: 14),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.place.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Color(0xFFf59e0b), size: 13),
                      const SizedBox(width: 2),
                      Text('${widget.place.rating}',
                          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 4),
                      Text('· ${widget.place.price}',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748b))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(AppState state, bool saved, bool visited) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      color: _bgColor(widget.place.category),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(child: Text(widget.place.emoji, style: const TextStyle(fontSize: 24))),
                  ),
                  if (visited)
                    Positioned(
                      bottom: 0, right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                        child: const Icon(Icons.check, color: Colors.white, size: 10),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.place.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 3),
                    Row(children: [
                      const Icon(Icons.star, color: Color(0xFFf59e0b), size: 12),
                      const SizedBox(width: 2),
                      Text('${widget.place.rating}',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 6),
                      Text(widget.place.address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11, color: Color(0xFF94a3b8))),
                    ]),
                    if (widget.place.hasStudentDiscount) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFdcfce7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('🎓 ${widget.place.discountText}',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF065f46))),
                      ),
                    ],
                  ],
                ),
              ),
              ScaleTransition(
                scale: _heartAnim,
                child: IconButton(
                  icon: Icon(
                    saved ? Icons.favorite : Icons.favorite_border,
                    color: saved ? Colors.red : Colors.grey,
                  ),
                  onPressed: () => _toggleSave(state),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _bgColor(String category) {
    switch (category) {
      case 'food':        return const Color(0xFFFFF7ED);
      case 'drinks':      return const Color(0xFFECFEFF);
      case 'attractions': return const Color(0xFFFAF5FF);
      case 'nightlife':   return const Color(0xFFFDF4FF);
      case 'shopping':    return const Color(0xFFFDF2F8);
      case 'nature':      return const Color(0xFFF0FDF4);
      case 'activities':  return const Color(0xFFFFFBEB);
      default:            return const Color(0xFFF1F5F9);
    }
  }
}
