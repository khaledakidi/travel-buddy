import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../data/model/place.dart';
import '../theme.dart';
import '../strings.dart';
import '../widgets/place_card.dart';
import '../widgets/place_detail_sheet.dart';

const List<Map<String, String>> kCategories = [
  {'id': 'all',         'label': 'All Places',  'icon': '🌍'},
  {'id': 'food',        'label': 'Food',        'icon': '🍽'},
  {'id': 'drinks',      'label': 'Drinks',      'icon': '☕'},
  {'id': 'attractions', 'label': 'Attractions', 'icon': '🏛'},
  {'id': 'activities',  'label': 'Activities',  'icon': '🎯'},
  {'id': 'nightlife',   'label': 'Nightlife',   'icon': '🌙'},
  {'id': 'shopping',    'label': 'Shopping',    'icon': '🛍'},
  {'id': 'nature',      'label': 'Nature',      'icon': '🌿'},
];

// Default Istanbul center
const LatLng kIstanbul = LatLng(41.0082, 28.9784);

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  final TextEditingController _searchCtrl = TextEditingController();
  String _viewMode = 'map'; // 'map' | 'grid' | 'list'
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _requestLocation();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _requestLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) return;

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() => _currentPosition = pos);

    _mapController?.animateCamera(CameraUpdate.newLatLng(
      LatLng(pos.latitude, pos.longitude),
    ));

    _buildMarkers();
  }

  void _buildMarkers() {
    final state = context.read<AppState>();
    final filtered = state.filteredPlaces(demoPlaces);
    setState(() {
      _markers = filtered.map((p) {
        return Marker(
          markerId: MarkerId(p.id),
          position: LatLng(p.latitude, p.longitude),
          infoWindow: InfoWindow(
            title: p.name,
            snippet: '${p.emoji} ${p.category} · ⭐ ${p.rating}',
            onTap: () => _showDetail(p),
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            _hueForCategory(p.category),
          ),
        );
      }).toSet();
    });
  }

  double _hueForCategory(String cat) {
    switch (cat) {
      case 'food':        return BitmapDescriptor.hueOrange;
      case 'drinks':      return BitmapDescriptor.hueCyan;
      case 'attractions': return BitmapDescriptor.hueViolet;
      case 'nightlife':   return BitmapDescriptor.hueBlue;
      case 'shopping':    return BitmapDescriptor.hueRose;
      case 'nature':      return BitmapDescriptor.hueGreen;
      default:            return BitmapDescriptor.hueRed;
    }
  }

  void _showDetail(Place place) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => PlaceDetailSheet(place: place),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final c = AppColors.of(state.darkMode);
    final s = AppStrings(state.language);
    final filtered = state.filteredPlaces(demoPlaces);

    return Scaffold(
      backgroundColor: c.scaffold,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(c, s, filtered.length),
            _buildSearch(state, c, s),
            _buildFilterChips(state, c, s),
            _buildViewToggle(filtered.length, c, s),
            Expanded(child: _buildContent(filtered, state)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppColors c, AppStrings s, int count) {
    return Container(
      color: c.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset('assets/images/logo.png', width: 40, height: 40,
                errorBuilder: (_, __, ___) => Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1a2744),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text('TB', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    )),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Travel Buddy', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: c.textPrimary)),
              Text(s.placesNearby(count), style: TextStyle(fontSize: 11, color: c.textSecondary)),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
            color: c.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildSearch(AppState state, AppColors c, AppStrings s) {
    return Container(
      color: c.surface,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: TextField(
        controller: _searchCtrl,
        style: TextStyle(color: c.textPrimary),
        onChanged: (v) {
          state.setSearchQuery(v);
          _buildMarkers();
        },
        decoration: InputDecoration(
          hintText: s.searchHint,
          hintStyle: TextStyle(color: c.textMuted, fontSize: 14),
          prefixIcon: Icon(Icons.search, color: c.textMuted),
          suffixIcon: _searchCtrl.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    _searchCtrl.clear();
                    state.setSearchQuery('');
                    _buildMarkers();
                  },
                )
              : null,
          filled: true,
          fillColor: c.searchFill,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildFilterChips(AppState state, AppColors c, AppStrings s) {
    return Container(
      color: c.surface,
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: kCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final cat = kCategories[i];
          final isSelected = state.activeFilter == cat['id'];
          return FilterChip(
            label: Text('${cat['icon']} ${s.categoryLabel(cat['id']!)}'),
            selected: isSelected,
            onSelected: (_) {
              state.setFilter(cat['id']!);
              _buildMarkers();
            },
            selectedColor: const Color(0xFF1a2744),
            checkmarkColor: Colors.white,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : c.textSecondary,
              fontSize: 12, fontWeight: FontWeight.w600,
            ),
            backgroundColor: c.surface,
            side: BorderSide(color: isSelected ? Colors.transparent : c.border),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          );
        },
      ),
    );
  }

  Widget _buildViewToggle(int count, AppColors c, AppStrings s) {
    return Container(
      color: c.surface,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        children: [
          Text(s.placeCount(count),
              style: TextStyle(fontSize: 13, color: c.textSecondary, fontWeight: FontWeight.w600)),
          const Spacer(),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'map',  icon: const Icon(Icons.map_outlined, size: 16),  label: Text(s.viewMap)),
              ButtonSegment(value: 'grid', icon: const Icon(Icons.grid_view, size: 16),      label: Text(s.viewGrid)),
              ButtonSegment(value: 'list', icon: const Icon(Icons.view_list, size: 16),      label: Text(s.viewList)),
            ],
            selected: {_viewMode},
            onSelectionChanged: (sel) => setState(() => _viewMode = sel.first),
            style: const ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(List<Place> places, AppState state) {
    if (_viewMode == 'map') return _buildMap(places);
    if (_viewMode == 'grid') return _buildGrid(places);
    return _buildList(places);
  }

  Widget _buildMap(List<Place> places) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _currentPosition != null
            ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
            : kIstanbul,
        zoom: 13,
      ),
      onMapCreated: (c) {
        _mapController = c;
        _buildMarkers();
      },
      myLocationEnabled: _currentPosition != null,
      myLocationButtonEnabled: true,
      markers: _markers,
      mapType: MapType.normal,
    );
  }

  Widget _buildGrid(List<Place> places) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12,
        childAspectRatio: 0.82,
      ),
      itemCount: places.length,
      itemBuilder: (_, i) => PlaceCard(
        place: places[i],
        variant: CardVariant.grid,
        onTap: () => _showDetail(places[i]),
      ),
    );
  }

  Widget _buildList(List<Place> places) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: places.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => PlaceCard(
        place: places[i],
        variant: CardVariant.list,
        onTap: () => _showDetail(places[i]),
      ),
    );
  }
}
