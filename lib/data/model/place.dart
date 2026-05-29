class Place {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double rating;
  final int reviewCount;
  final String category;
  final String? photoUrl;
  final String price;
  final String hours;
  final bool hasStudentDiscount;
  final String? discountText;
  bool isSaved;
  bool isVisited;

  Place({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.reviewCount,
    required this.category,
    this.photoUrl,
    required this.price,
    required this.hours,
    this.hasStudentDiscount = false,
    this.discountText,
    this.isSaved = false,
    this.isVisited = false,
  });

  String get emoji {
    switch (category) {
      case 'food':       return '🍽';
      case 'drinks':     return '☕';
      case 'attractions':return '🏛';
      case 'nightlife':  return '🌙';
      case 'shopping':   return '🛍';
      case 'nature':     return '🌿';
      case 'activities': return '🎯';
      default:           return '📍';
    }
  }

  Map<String, dynamic> toMap() => {
    'placeId':           id,
    'name':              name,
    'address':           address,
    'latitude':          latitude,
    'longitude':         longitude,
    'rating':            rating,
    'reviewCount':       reviewCount,
    'category':          category,
    'photoUrl':          photoUrl,
    'price':             price,
    'hours':             hours,
    'hasStudentDiscount':hasStudentDiscount ? 1 : 0,
    'discountText':      discountText,
    'isVisited':         isVisited ? 1 : 0,
    'savedAt':           DateTime.now().millisecondsSinceEpoch,
  };

  factory Place.fromMap(Map<String, dynamic> m) => Place(
    id:                  m['placeId'] as String,
    name:                m['name'] as String,
    address:             m['address'] as String,
    latitude:            m['latitude'] as double,
    longitude:           m['longitude'] as double,
    rating:              m['rating'] as double,
    reviewCount:         m['reviewCount'] as int,
    category:            m['category'] as String,
    photoUrl:            m['photoUrl'] as String?,
    price:               m['price'] as String,
    hours:               m['hours'] as String,
    hasStudentDiscount:  (m['hasStudentDiscount'] as int) == 1,
    discountText:        m['discountText'] as String?,
    isSaved:             true,
    isVisited:           (m['isVisited'] as int) == 1,
  );

  Place copyWith({bool? isSaved, bool? isVisited}) => Place(
    id: id, name: name, address: address,
    latitude: latitude, longitude: longitude,
    rating: rating, reviewCount: reviewCount, category: category,
    photoUrl: photoUrl, price: price, hours: hours,
    hasStudentDiscount: hasStudentDiscount, discountText: discountText,
    isSaved:   isSaved   ?? this.isSaved,
    isVisited: isVisited ?? this.isVisited,
  );
}

// Hardcoded Istanbul places for demo (replaces Places API until P4)
final List<Place> demoPlaces = [
  Place(id:'1', name:'Sultanahmet Mosque',   address:'Sultanahmet, Istanbul',  latitude:41.0054, longitude:28.9768, rating:4.8, reviewCount:48200, category:'attractions', price:'Free',  hours:'8:30–17:00', hasStudentDiscount:true,  discountText:'Free entry with student ID'),
  Place(id:'2', name:'Grand Bazaar',         address:'Beyazıt, Istanbul',      latitude:41.0107, longitude:28.9682, rating:4.5, reviewCount:62100, category:'shopping',    price:'Free',  hours:'9:00–19:00', hasStudentDiscount:false),
  Place(id:'3', name:'Hafız Mustafa 1864',   address:'Sirkeci, Istanbul',      latitude:41.0112, longitude:28.9744, rating:4.7, reviewCount:31400, category:'food',        price:'\$\$',  hours:'7:00–1:00',  hasStudentDiscount:false),
  Place(id:'4', name:'Mandabatmaz',          address:'Beyoğlu, Istanbul',      latitude:41.0335, longitude:28.9768, rating:4.6, reviewCount:8900,  category:'drinks',      price:'\$',   hours:'9:00–23:00', hasStudentDiscount:true,  discountText:'10% off with student card'),
  Place(id:'5', name:'Basilica Cistern',     address:'Sultanahmet, Istanbul',  latitude:41.0084, longitude:28.9779, rating:4.7, reviewCount:42300, category:'attractions', price:'\$\$', hours:'9:00–19:00', hasStudentDiscount:true,  discountText:'50% off entry'),
  Place(id:'6', name:'Karaköy Güllüoğlu',   address:'Karaköy, Istanbul',      latitude:41.0214, longitude:28.9771, rating:4.6, reviewCount:19200, category:'food',        price:'\$',   hours:'7:00–23:00', hasStudentDiscount:false),
  Place(id:'7', name:'Kadıköy Market',       address:'Kadıköy, Istanbul',      latitude:40.9903, longitude:29.0260, rating:4.4, reviewCount:15600, category:'food',        price:'\$',   hours:'6:00–20:00', hasStudentDiscount:true,  discountText:'Budget-friendly area'),
  Place(id:'8', name:'Pierre Loti Hill',     address:'Eyüpsultan, Istanbul',   latitude:41.0534, longitude:28.9392, rating:4.5, reviewCount:11300, category:'nature',      price:'\$',   hours:'8:00–22:00', hasStudentDiscount:true,  discountText:'50% off cable car'),
  Place(id:'9', name:'Istanbul Modern',      address:'Karaköy, Istanbul',      latitude:41.0262, longitude:28.9835, rating:4.3, reviewCount:9800,  category:'attractions', price:'\$\$', hours:'10:00–18:00',hasStudentDiscount:true,  discountText:'Free with student ID'),
  Place(id:'10',name:'Bebek Sahili',         address:'Bebek, Istanbul',        latitude:41.0770, longitude:29.0440, rating:4.4, reviewCount:7200,  category:'drinks',      price:'\$\$', hours:'All day',     hasStudentDiscount:false),
  Place(id:'11',name:'Topkapı Palace',       address:'Sultanahmet, Istanbul',  latitude:41.0115, longitude:28.9834, rating:4.7, reviewCount:52100, category:'attractions', price:'\$\$', hours:'9:00–18:00', hasStudentDiscount:true,  discountText:'50% off entry'),
  Place(id:'12',name:'Balat Neighborhood',   address:'Balat, Istanbul',        latitude:41.0302, longitude:28.9489, rating:4.5, reviewCount:13400, category:'activities',  price:'Free',  hours:'Always open', hasStudentDiscount:false),
  Place(id:'13',name:'Galata Tower',         address:'Karaköy, Istanbul',      latitude:41.0256, longitude:28.9741, rating:4.6, reviewCount:38700, category:'attractions', price:'\$\$', hours:'8:30–23:00', hasStudentDiscount:true,  discountText:'40% off entry'),
  Place(id:'14',name:'Ortaköy Square',       address:'Ortaköy, Istanbul',      latitude:41.0477, longitude:29.0275, rating:4.3, reviewCount:11200, category:'nightlife',   price:'\$',   hours:'10:00–2:00', hasStudentDiscount:false),
  Place(id:'15',name:"Princes' Islands Ferry",address:'Eminönü, Istanbul',     latitude:40.8756, longitude:29.0892, rating:4.6, reviewCount:22500, category:'nature',      price:'\$',   hours:'From 6:30',  hasStudentDiscount:true,  discountText:'50% off ferry ticket'),
  Place(id:'16',name:'Miniaturk',            address:'Eyüpsultan, Istanbul',   latitude:41.0631, longitude:28.9487, rating:4.3, reviewCount:8100,  category:'activities',  price:'\$',   hours:'9:00–18:00', hasStudentDiscount:true,  discountText:'30% off entry'),

  // ── Food (extended) ────────────────────────────────────────
  Place(id:'17',name:'Çiya Sofrası',          address:'Kadıköy, Istanbul',      latitude:40.9913, longitude:29.0288, rating:4.7, reviewCount:14200, category:'food',        price:'\$\$', hours:'12:00–22:00',hasStudentDiscount:false),
  Place(id:'18',name:'Mikla Restaurant',       address:'Beyoğlu, Istanbul',      latitude:41.0367, longitude:28.9777, rating:4.6, reviewCount:5400,  category:'food',        price:'\$\$\$',hours:'18:00–23:00',hasStudentDiscount:false),
  Place(id:'19',name:'Sultanahmet Köftecisi',  address:'Sultanahmet, Istanbul',  latitude:41.0094, longitude:28.9778, rating:4.4, reviewCount:21300, category:'food',        price:'\$',   hours:'10:00–22:00',hasStudentDiscount:true,  discountText:'15% off with student ID'),
  Place(id:'20',name:'Develi Kebap',           address:'Samatya, Istanbul',      latitude:41.0006, longitude:28.9344, rating:4.5, reviewCount:9100,  category:'food',        price:'\$\$', hours:'11:00–23:00',hasStudentDiscount:false),
  Place(id:'21',name:'Pandeli',                address:'Eminönü, Istanbul',      latitude:41.0166, longitude:28.9707, rating:4.3, reviewCount:6700,  category:'food',        price:'\$\$', hours:'12:00–17:00',hasStudentDiscount:true,  discountText:'10% off lunch menu'),

  // ── Drinks ────────────────────────────────────────────────
  Place(id:'22',name:'Kronotrop Coffee',       address:'Cihangir, Istanbul',     latitude:41.0322, longitude:28.9836, rating:4.6, reviewCount:4800,  category:'drinks',      price:'\$\$', hours:'8:00–22:00', hasStudentDiscount:true,  discountText:'Free wifi study spot'),
  Place(id:'23',name:'Federal Coffee Company', address:'Karaköy, Istanbul',      latitude:41.0244, longitude:28.9769, rating:4.5, reviewCount:6200,  category:'drinks',      price:'\$\$', hours:'8:00–21:00', hasStudentDiscount:false),
  Place(id:'24',name:'Set Üstü Çay Bahçesi',   address:'Çengelköy, Istanbul',    latitude:41.0552, longitude:29.0593, rating:4.7, reviewCount:12100, category:'drinks',      price:'\$',   hours:'10:00–23:00',hasStudentDiscount:true,  discountText:'Cheap tea, Bosphorus view'),
  Place(id:'25',name:'Ministry of Coffee',     address:'Kadıköy, Istanbul',      latitude:40.9924, longitude:29.0254, rating:4.6, reviewCount:3900,  category:'drinks',      price:'\$\$', hours:'8:30–22:00', hasStudentDiscount:true,  discountText:'10% off with student card'),

  // ── Attractions ───────────────────────────────────────────
  Place(id:'26',name:'Hagia Sophia',            address:'Sultanahmet, Istanbul',  latitude:41.0086, longitude:28.9802, rating:4.8, reviewCount:84200, category:'attractions', price:'Free', hours:'9:00–21:00', hasStudentDiscount:false),
  Place(id:'27',name:'Dolmabahçe Palace',       address:'Beşiktaş, Istanbul',     latitude:41.0391, longitude:29.0001, rating:4.6, reviewCount:36400, category:'attractions', price:'\$\$', hours:'9:00–16:00', hasStudentDiscount:true,  discountText:'60% off entry'),
  Place(id:'28',name:'Süleymaniye Mosque',      address:'Fatih, Istanbul',        latitude:41.0162, longitude:28.9639, rating:4.8, reviewCount:18900, category:'attractions', price:'Free', hours:'9:00–18:00', hasStudentDiscount:false),
  Place(id:'29',name:'Chora Church Museum',     address:'Edirnekapı, Istanbul',   latitude:41.0316, longitude:28.9395, rating:4.7, reviewCount:7300,  category:'attractions', price:'\$\$', hours:'9:00–17:00', hasStudentDiscount:true,  discountText:'50% off entry'),
  Place(id:'30',name:'Pera Museum',             address:'Beyoğlu, Istanbul',      latitude:41.0314, longitude:28.9744, rating:4.5, reviewCount:9700,  category:'attractions', price:'\$\$', hours:'10:00–19:00',hasStudentDiscount:true,  discountText:'Free entry on Fridays'),
  Place(id:'31',name:'Rumeli Fortress',         address:'Sarıyer, Istanbul',      latitude:41.0843, longitude:29.0563, rating:4.6, reviewCount:11200, category:'attractions', price:'\$',   hours:'9:00–16:30', hasStudentDiscount:true,  discountText:'50% off entry'),

  // ── Nightlife ─────────────────────────────────────────────
  Place(id:'32',name:'Klein Bar',               address:'Karaköy, Istanbul',      latitude:41.0247, longitude:28.9805, rating:4.4, reviewCount:2800,  category:'nightlife',   price:'\$\$', hours:'19:00–3:00', hasStudentDiscount:false),
  Place(id:'33',name:'Babylon Bomonti',         address:'Şişli, Istanbul',        latitude:41.0578, longitude:28.9868, rating:4.5, reviewCount:8900,  category:'nightlife',   price:'\$\$', hours:'20:00–4:00', hasStudentDiscount:true,  discountText:'30% off cover charge'),
  Place(id:'34',name:'Mikla Sky Bar',           address:'Beyoğlu, Istanbul',      latitude:41.0367, longitude:28.9777, rating:4.7, reviewCount:6100,  category:'nightlife',   price:'\$\$\$',hours:'18:00–2:00', hasStudentDiscount:false),
  Place(id:'35',name:'360 Istanbul',            address:'Beyoğlu, Istanbul',      latitude:41.0347, longitude:28.9774, rating:4.4, reviewCount:14500, category:'nightlife',   price:'\$\$\$',hours:'18:00–3:00', hasStudentDiscount:false),

  // ── Shopping ──────────────────────────────────────────────
  Place(id:'36',name:'Spice Bazaar',            address:'Eminönü, Istanbul',      latitude:41.0165, longitude:28.9706, rating:4.5, reviewCount:43200, category:'shopping',    price:'Free', hours:'8:00–19:30', hasStudentDiscount:false),
  Place(id:'37',name:'İstinye Park',            address:'Sarıyer, Istanbul',      latitude:41.1108, longitude:29.0285, rating:4.5, reviewCount:18700, category:'shopping',    price:'Free', hours:'10:00–22:00',hasStudentDiscount:false),
  Place(id:'38',name:'Çukurcuma Antiques',      address:'Beyoğlu, Istanbul',      latitude:41.0335, longitude:28.9794, rating:4.4, reviewCount:3400,  category:'shopping',    price:'\$\$', hours:'10:00–19:00',hasStudentDiscount:false),
  Place(id:'39',name:'Akmerkez Mall',           address:'Etiler, Istanbul',       latitude:41.0769, longitude:29.0226, rating:4.4, reviewCount:9300,  category:'shopping',    price:'Free', hours:'10:00–22:00',hasStudentDiscount:true,  discountText:'Student deals at select stores'),

  // ── Nature ────────────────────────────────────────────────
  Place(id:'40',name:'Emirgan Park',            address:'Sarıyer, Istanbul',      latitude:41.1089, longitude:29.0539, rating:4.7, reviewCount:21400, category:'nature',      price:'Free', hours:'Always open', hasStudentDiscount:false),
  Place(id:'41',name:'Belgrad Forest',          address:'Sarıyer, Istanbul',      latitude:41.1747, longitude:28.9853, rating:4.6, reviewCount:14800, category:'nature',      price:'Free', hours:'Always open', hasStudentDiscount:false),
  Place(id:'42',name:'Gülhane Park',            address:'Sultanahmet, Istanbul',  latitude:41.0125, longitude:28.9817, rating:4.6, reviewCount:24700, category:'nature',      price:'Free', hours:'6:00–22:30', hasStudentDiscount:false),
  Place(id:'43',name:'Yıldız Park',             address:'Beşiktaş, Istanbul',     latitude:41.0469, longitude:29.0118, rating:4.5, reviewCount:8900,  category:'nature',      price:'Free', hours:'7:00–22:00', hasStudentDiscount:false),
  Place(id:'44',name:'Maiden\'s Tower View',    address:'Üsküdar, Istanbul',      latitude:41.0211, longitude:29.0041, rating:4.5, reviewCount:19200, category:'nature',      price:'Free', hours:'Always open', hasStudentDiscount:false),

  // ── Activities ────────────────────────────────────────────
  Place(id:'45',name:'Bosphorus Cruise',        address:'Eminönü, Istanbul',      latitude:41.0173, longitude:28.9744, rating:4.7, reviewCount:32100, category:'activities',  price:'\$\$', hours:'10:00–18:00',hasStudentDiscount:true,  discountText:'30% off with student ID'),
  Place(id:'46',name:'Hamam Çemberlitaş',       address:'Çemberlitaş, Istanbul',  latitude:41.0095, longitude:28.9712, rating:4.6, reviewCount:9300,  category:'activities',  price:'\$\$', hours:'6:00–0:00',  hasStudentDiscount:true,  discountText:'20% off student package'),
  Place(id:'47',name:'Whirling Dervishes Show', address:'Sirkeci, Istanbul',      latitude:41.0140, longitude:28.9772, rating:4.4, reviewCount:6800,  category:'activities',  price:'\$\$', hours:'19:30 daily',hasStudentDiscount:true,  discountText:'25% off with student ID'),
  Place(id:'48',name:'Galata Mevlevihanesi',    address:'Beyoğlu, Istanbul',      latitude:41.0282, longitude:28.9778, rating:4.5, reviewCount:3700,  category:'activities',  price:'\$',   hours:'9:00–16:30', hasStudentDiscount:true,  discountText:'50% off entry'),
  Place(id:'49',name:'Vialand Theme Park',      address:'Eyüpsultan, Istanbul',   latitude:41.0792, longitude:28.9116, rating:4.3, reviewCount:11900, category:'activities',  price:'\$\$', hours:'11:00–22:00',hasStudentDiscount:true,  discountText:'Group/student rates'),
  Place(id:'50',name:'Üsküdar Walking Tour',    address:'Üsküdar, Istanbul',      latitude:41.0258, longitude:29.0167, rating:4.6, reviewCount:4500,  category:'activities',  price:'Free', hours:'Self-guided', hasStudentDiscount:false),
];
