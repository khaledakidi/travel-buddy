import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../data/model/place.dart';
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
    final filtered = state.filteredPlaces(demoPlaces);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearch(state),
            _buildFilterChips(state),
            _buildViewToggle(filtered.length),
            Expanded(child: _buildContent(filtered, state)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF1a2744),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text('TB', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Travel Buddy', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF1a2744))),
              Text('Istanbul · 16 places nearby', style: TextStyle(fontSize: 11, color: Color(0xFF64748b))),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
            color: const Color(0xFF64748b),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch(AppState state) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: TextField(
        controller: _searchCtrl,
        onChanged: (v) {
          state.setSearchQuery(v);
          _buildMarkers();
        },
        decoration: InputDecoration(
          hintText: 'Search places, food, activities...',
          hintStyle: const TextStyle(color: Color(0xFF94a3b8), fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF94a3b8)),
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
          fillColor: const Color(0xFFF1F5F9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildFilterChips(AppState state) {
    return Container(
      color: Colors.white,
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
            label: Text('${cat['icon']} ${cat['label']}'),
            selected: isSelected,
            onSelected: (_) {
              state.setFilter(cat['id']!);
              _buildMarkers();
            },
            selectedColor: const Color(0xFF1a2744),
            checkmarkColor: Colors.white,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF64748b),
              fontSize: 12, fontWeight: FontWeight.w600,
            ),
            backgroundColor: Colors.white,
            side: BorderSide(color: isSelected ? Colors.transparent : const Color(0xFFe2e8f0)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          );
        },
      ),
    );
  }

  Widget _buildViewToggle(int count) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        children: [
          Text('$count place${count != 1 ? 's' : ''}',
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748b), fontWeight: FontWeight.w600)),
          const Spacer(),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'map',  icon: Icon(Icons.map_outlined, size: 16),  label: Text('Map')),
              ButtonSegment(value: 'grid', icon: Icon(Icons.grid_view, size: 16),      label: Text('Grid')),
              ButtonSegment(value: 'list', icon: Icon(Icons.view_list, size: 16),      label: Text('List')),
            ],
            selected: {_viewMode},
            onSelectionChanged: (s) => setState(() => _viewMode = s.first),
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
      onCameraIdle: _buildMarkers,
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
