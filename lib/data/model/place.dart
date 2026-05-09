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
];
