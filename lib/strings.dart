/// Simple two-language string table (English / Turkish).
/// Logic keys (category ids, tip tags) stay in English — only the
/// displayed labels are translated, so filtering still works.
class AppStrings {
  final String lang; // 'en' or 'tr'
  const AppStrings(this.lang);

  bool get isTr => lang == 'tr';
  String _t(String en, String tr) => isTr ? tr : en;

  // ── Navigation ──
  String get navExplore => _t('Explore', 'Keşfet');
  String get navSaved   => _t('Saved', 'Kayıtlı');
  String get navTips    => _t('Tips', 'İpuçları');
  String get navProfile => _t('Profile', 'Profil');

  // ── Explore ──
  String get brandSubtitle => _t('Istanbul', 'İstanbul');
  String placesNearby(int n) =>
      isTr ? 'İstanbul · $n yakın yer' : 'Istanbul · $n places nearby';
  String get searchHint =>
      _t('Search places, food, activities...', 'Yer, yemek, aktivite arayın...');
  String placeCount(int n) => isTr ? '$n yer' : '$n place${n != 1 ? 's' : ''}';
  String get viewMap  => _t('Map', 'Harita');
  String get viewGrid => _t('Grid', 'Izgara');
  String get viewList => _t('List', 'Liste');

  String categoryLabel(String id) {
    switch (id) {
      case 'all':         return _t('All Places', 'Tüm Yerler');
      case 'food':        return _t('Food', 'Yemek');
      case 'drinks':      return _t('Drinks', 'İçecekler');
      case 'attractions': return _t('Attractions', 'Gezilecek');
      case 'activities':  return _t('Activities', 'Aktiviteler');
      case 'nightlife':   return _t('Nightlife', 'Gece Hayatı');
      case 'shopping':    return _t('Shopping', 'Alışveriş');
      case 'nature':      return _t('Nature', 'Doğa');
      default:            return id;
    }
  }

  // ── Saved ──
  String get savedTitle    => _t('My Places', 'Yerlerim');
  String get statSaved     => _t('Saved', 'Kayıtlı');
  String get statVisited   => _t('Visited', 'Ziyaret');
  String get statDiscounts => _t('Discounts', 'İndirimler');
  String get statShared    => _t('Shared', 'Paylaşılan');
  String discountBanner(int n) => isTr
      ? 'öğrenci indirimli $n kayıtlı yer'
      : '$n saved place${n > 1 ? 's' : ''} with student discounts';
  String get emptyTitle => _t('No saved places yet', 'Henüz kayıtlı yer yok');
  String get emptyHint  => _t(
      'Tap ♡ on any place to save it here',
      'Kaydetmek için herhangi bir yerde ♡ simgesine dokunun');
  String get removedFromSaved => _t('Removed from saved', 'Kayıtlılardan kaldırıldı');

  // ── Tips ──
  String get tipsTitle => _t('Travel Tips', 'Seyahat İpuçları');
  String tagLabel(String tag) {
    switch (tag) {
      case 'All':         return _t('All', 'Tümü');
      case 'Transport':   return _t('Transport', 'Ulaşım');
      case 'Savings':     return _t('Savings', 'Tasarruf');
      case 'Food':        return _t('Food', 'Yemek');
      case 'Activities':  return _t('Activities', 'Aktiviteler');
      case 'Shopping':    return _t('Shopping', 'Alışveriş');
      case 'Photography': return _t('Photography', 'Fotoğraf');
      case 'Finance':     return _t('Finance', 'Finans');
      default:            return tag;
    }
  }

  String tipTitle(String en) => isTr ? (_tipTitleTr[en] ?? en) : en;
  String tipBody(String en) => isTr ? (_tipBodyTr[en] ?? en) : en;

  static const Map<String, String> _tipTitleTr = {
    'Get an Istanbulkart': 'İstanbulkart Edinin',
    'Museum Pass İstanbul': 'Müze Kart İstanbul',
    'Ferry Over Taxi': 'Taksi Yerine Vapur',
    'Eat Like a Local': 'Yerel Gibi Yiyin',
    'Free Walking Tours': 'Ücretsiz Yürüyüş Turları',
    'Haggle at the Bazaar': 'Çarşıda Pazarlık Yapın',
    'Best Photo Spots': 'En İyi Fotoğraf Noktaları',
    'Currency Tips': 'Döviz İpuçları',
    'Student Museum Free Days': 'Öğrenci Müze Ücretsiz Günleri',
    'Istanbulkart Discount': 'İstanbulkart İndirimi',
  };

  static const Map<String, String> _tipBodyTr = {
    'Get an Istanbulkart':
        'Herhangi bir büfeden ulaşım kartı alın — tramvay, vapur ve otobüs her biniş için ₺10\'un altında.',
    'Museum Pass İstanbul':
        '12\'den fazla müzeyi kapsayan 5 günlük kartla çok tasarruf edin. Öğrenciler kartın kendisinde %50 indirim alır.',
    'Ferry Over Taxi':
        'Boğaz vapurları hem manzaralı hem ucuz. Kadıköy–Eminönü şehrin en güzel yolculuğu.',
    'Eat Like a Local':
        'Turist menülerini atlayın. Simit (₺5), kokoreç ve balık-ekmek vazgeçilmez sokak lezzetleri.',
    'Free Walking Tours':
        'Sultanahmet\'ten bahşiş esaslı turlar — şehri ilk kez keşfedenler için ideal.',
    'Haggle at the Bazaar':
        'Kapalıçarşı\'da pazarlık beklenir. İstenen fiyatın %40\'ından başlayın.',
    'Best Photo Spots':
        'Galata Kulesi, Pierre Loti Tepesi, Balat sokakları ve gün batımında Çamlıca Tepesi.',
    'Currency Tips':
        'PTT şubelerinde veya döviz bürolarında bozdurun — asla havaalanında değil.',
    'Student Museum Free Days':
        'Birçok İstanbul müzesi her ayın ilk pazar günü öğrencilere ücretsizdir.',
    'Istanbulkart Discount':
        'e-Devlet onaylı kart sahibi öğrenciler otomatik olarak indirimli ücret öder.',
  };

  // ── Profile ──
  String get profileTitle => _t('Profile', 'Profil');
  String get traveler      => _t('Traveler', 'Gezgin');
  String levelLabel(int n) => isTr ? 'İstanbul · Seviye $n' : 'Istanbul · Level $n';
  String get achievements  => _t('ACHIEVEMENTS', 'BAŞARIMLAR');
  String get preferences   => _t('PREFERENCES', 'TERCİHLER');
  String get general       => _t('GENERAL', 'GENEL');
  String get studentMode   => _t('Student Mode', 'Öğrenci Modu');
  String get studentModeSub => _t(
      'Show student discounts and budget options',
      'Öğrenci indirimlerini ve bütçe seçeneklerini göster');
  String get notifications  => _t('Notifications', 'Bildirimler');
  String get notificationsSub =>
      _t('Get alerts for nearby deals', 'Yakındaki fırsatlar için uyarı al');
  String get language    => _t('Language', 'Dil');
  String get languageVal => _t('English', 'Türkçe');
  String get appearance  => _t('Appearance', 'Görünüm');
  String appearanceVal(bool dark) =>
      dark ? _t('Dark', 'Koyu') : _t('Light', 'Açık');
  String get rateApp    => _t('Rate App', 'Uygulamayı Değerlendir');
  String get contactUs  => _t('Contact Us', 'Bize Ulaşın');
  String get version    => _t('Travel Buddy v1.0  ·  Made with ❤️',
      'Travel Buddy v1.0  ·  ❤️ ile yapıldı');

  String badgeLabel(String en) => isTr ? (_badgeLabelTr[en] ?? en) : en;
  String badgeDesc(String en) => isTr ? (_badgeDescTr[en] ?? en) : en;

  static const Map<String, String> _badgeLabelTr = {
    'First Visit': 'İlk Ziyaret',
    '5 Saved': '5 Kayıt',
    'Foodie': 'Gurme',
    'Culture Vulture': 'Kültür Tutkunu',
    'Night Owl': 'Gece Kuşu',
    'Budget Pro': 'Bütçe Ustası',
  };
  static const Map<String, String> _badgeDescTr = {
    'Visit your first place': 'İlk yerinizi ziyaret edin',
    'Save 5 places': '5 yer kaydedin',
    'Visit 5 food places': '5 yemek yeri ziyaret edin',
    'Visit 5 attractions': '5 gezilecek yer ziyaret edin',
    'Visit 3 nightlife spots': '3 gece mekanı ziyaret edin',
    'Use 5 student discounts': '5 öğrenci indirimi kullanın',
  };

  // ── Detail sheet ──
  String get priceFree       => _t('Free', 'Ücretsiz');
  String get studentAdvantage => _t('Student Advantage', 'Öğrenci Avantajı');
  String get visitedThisPlace =>
      _t("You've visited this place!", 'Burayı ziyaret ettiniz!');
  String get markVisited => _t('Mark as Visited  +10 XP', 'Ziyaret Edildi  +10 XP');
  String get savePlace   => _t('Save Place', 'Yeri Kaydet');
  String get savedLabel  => _t('Saved', 'Kayıtlı');
  String get share       => _t('Share', 'Paylaş');
  String get getDirections => _t('Get Directions', 'Yol Tarifi Al');
  String get discountTag => _t('🎓 Discount', '🎓 İndirim');

  // ── Snackbars ──
  String get snackSaved   => _t('❤️ Saved to your places!', '❤️ Yerlerinize kaydedildi!');
  String get snackRemoved => _t('📍 Removed from saved', '📍 Kayıtlılardan kaldırıldı');
  String get snackSavedShort => _t('❤️ Saved!', '❤️ Kaydedildi!');
  String get snackVisited => _t('✅ Marked as visited! +10 XP', '✅ Ziyaret edildi olarak işaretlendi! +10 XP');
  String get snackShared  => _t('📤 Shared! +5 XP', '📤 Paylaşıldı! +5 XP');
}
