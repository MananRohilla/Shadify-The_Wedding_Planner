/// Simple mock services for offline development
/// This allows the app to run without Firebase initialization

class MockAuthService {
  static bool _isLoggedIn = false;
  static String? _currentUserEmail;
  
  static bool get isLoggedIn => _isLoggedIn;
  static String? get currentUserEmail => _currentUserEmail;
  
  static Future<bool> signIn(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Accept any email/password for demo purposes
    if (email.isNotEmpty && password.length >= 6) {
      _isLoggedIn = true;
      _currentUserEmail = email;
      return true;
    }
    
    throw Exception('Invalid email or password');
  }
  
  static Future<bool> signUp(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (email.isNotEmpty && password.length >= 6) {
      _isLoggedIn = true;
      _currentUserEmail = email;
      return true;
    }
    
    throw Exception('Invalid email or password');
  }
  
  static Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _isLoggedIn = false;
    _currentUserEmail = null;
  }
  
  static Future<void> sendPasswordReset(String email) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock success - no actual email sent
  }
}

class MockDataService {
  // Standardized mock data using snake_case keys matching model fromJson
  static final Map<String, List<Map<String, dynamic>>> _mockData = {
    'budget_items': [
      {
        'id': '1',
        'user_id': 'demo',
        'category': 'Venue',
        'allocated_amount': 5000.0,
        'spent_amount': 4800.0,
        'percentage': 30.0,
        'created_at': DateTime.now().subtract(const Duration(days: 10)),
        'updated_at': DateTime.now().subtract(const Duration(days: 5)),
      },
      {
        'id': '2',
        'user_id': 'demo',
        'category': 'Catering',
        'allocated_amount': 3000.0,
        'spent_amount': 0.0,
        'percentage': 25.0,
        'created_at': DateTime.now().subtract(const Duration(days: 8)),
        'updated_at': DateTime.now().subtract(const Duration(days: 3)),
      },
    ],
    'checklist_items': [
      {
        'id': '1',
        'user_id': 'demo',
        'title': 'Book wedding venue',
        'description': 'Research and book the perfect venue',
        'category': 'Venue',
        'is_completed': true,
        'due_date': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
        'created_at': DateTime.now().subtract(const Duration(days: 45)),
        'updated_at': DateTime.now().subtract(const Duration(days: 40)),
      },
      {
        'id': '2',
        'user_id': 'demo',
        'title': 'Send invitations',
        'description': 'Design and send wedding invitations',
        'category': 'Planning',
        'is_completed': false,
        'due_date': DateTime.now().add(const Duration(days: 14)).toIso8601String(),
        'created_at': DateTime.now().subtract(const Duration(days: 20)),
        'updated_at': DateTime.now().subtract(const Duration(days: 10)),
      },
    ],
    'guests': [
      {
        'id': '1',
        'user_id': 'demo',
        'name': 'John Smith',
        'email': 'john@example.com',
        'phone': '+1234567890',
        'rsvp_status': 'confirmed',
        'dietary_restrictions': 'Vegetarian',
        'plus_one': false,
        'created_at': DateTime.now().subtract(const Duration(days: 15)),
        'updated_at': DateTime.now().subtract(const Duration(days: 5)),
      },
      {
        'id': '2',
        'user_id': 'demo',
        'name': 'Emily Johnson',
        'email': 'emily@example.com',
        'phone': '+1234567891',
        'rsvp_status': 'pending',
        'dietary_restrictions': '',
        'plus_one': true,
        'created_at': DateTime.now().subtract(const Duration(days: 12)),
        'updated_at': DateTime.now().subtract(const Duration(days: 2)),
      },
    ],
    'venues': [
      // 8 demo venues with realistic data
      {
        'id': 'v1',
        'name': 'Grand Ballroom',
        'location': '123 Wedding St',
        'city': 'Springfield',
        'price_min': 70000,
        'price_max': 150000,
        'capacity': 250,
        'description': 'Elegant ballroom with crystal chandeliers and premium decor.',
        'image_url': null,
        'amenities': ['Parking', 'Sound System', 'Dance Floor'],
        'rating': 4.8,
        'created_at': DateTime.now().subtract(const Duration(days: 25)),
      },
      {
        'id': 'v2',
        'name': 'Garden Paradise',
        'location': '456 Nature Ave',
        'city': 'Springfield',
        'price_min': 50000,
        'price_max': 120000,
        'capacity': 180,
        'description': 'Lush outdoor garden with gazebo and floral pathways.',
        'image_url': null,
        'amenities': ['Garden', 'Gazebo', 'Outdoor Lighting'],
        'rating': 4.6,
        'created_at': DateTime.now().subtract(const Duration(days: 20)),
      },
      {
        'id': 'v3',
        'name': 'Lakeside Pavilion',
        'location': '789 Lake View Rd',
        'city': 'Lakeshore',
        'price_min': 60000,
        'price_max': 140000,
        'capacity': 200,
        'description': 'Scenic lakeside venue with panoramic water views.',
        'image_url': null,
        'amenities': ['Lake View', 'Fire Pit', 'Catering Area'],
        'rating': 4.7,
        'created_at': DateTime.now().subtract(const Duration(days: 18)),
      },
      {
        'id': 'v4',
        'name': 'Heritage Mansion',
        'location': '12 Royal Crescent',
        'city': 'Oldtown',
        'price_min': 90000,
        'price_max': 200000,
        'capacity': 300,
        'description': 'Historic mansion with vintage architecture and gardens.',
        'image_url': null,
        'amenities': ['Vintage Decor', 'Indoor Hall', 'Garden'],
        'rating': 4.9,
        'created_at': DateTime.now().subtract(const Duration(days: 30)),
      },
      {
        'id': 'v5',
        'name': 'Sunset Terrace',
        'location': '88 Horizon Blvd',
        'city': 'Coastline',
        'price_min': 55000,
        'price_max': 110000,
        'capacity': 160,
        'description': 'Open-air terrace perfect for sunset ceremonies.',
        'image_url': null,
        'amenities': ['Terrace', 'Ocean View', 'Bar Area'],
        'rating': 4.5,
        'created_at': DateTime.now().subtract(const Duration(days: 15)),
      },
      {
        'id': 'v6',
        'name': 'Crystal Hall',
        'location': '501 City Center',
        'city': 'Metro City',
        'price_min': 80000,
        'price_max': 160000,
        'capacity': 220,
        'description': 'Modern hall with state-of-the-art lighting and acoustics.',
        'image_url': null,
        'amenities': ['LED Lighting', 'Audio System', 'Climate Control'],
        'rating': 4.4,
        'created_at': DateTime.now().subtract(const Duration(days: 10)),
      },
      {
        'id': 'v7',
        'name': 'Rustic Barn',
        'location': '77 Country Lane',
        'city': 'Countryside',
        'price_min': 40000,
        'price_max': 90000,
        'capacity': 150,
        'description': 'Charming barn venue with wooden beams and fairy lights.',
        'image_url': null,
        'amenities': ['Barn', 'String Lights', 'Catering Space'],
        'rating': 4.3,
        'created_at': DateTime.now().subtract(const Duration(days: 12)),
      },
      {
        'id': 'v8',
        'name': 'Mountain Retreat',
        'location': '999 Summit Peak',
        'city': 'Highridge',
        'price_min': 65000,
        'price_max': 130000,
        'capacity': 180,
        'description': 'Secluded mountain venue with breathtaking views.',
        'image_url': null,
        'amenities': ['Scenic View', 'Lodge', 'Fireplace'],
        'rating': 4.7,
        'created_at': DateTime.now().subtract(const Duration(days: 8)),
      },
    ],
  };
  
  static List<Map<String, dynamic>> getCollection(String collectionName) {
    return List.from(_mockData[collectionName] ?? []);
  }
  
  static Future<List<Map<String, dynamic>>> getCollectionAsync(String collectionName) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return getCollection(collectionName);
  }
  
  static Future<Map<String, dynamic>?> getDocument(String collectionName, String docId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final collection = _mockData[collectionName] ?? [];
    try {
      return collection.firstWhere((doc) => doc['id'] == docId);
    } catch (e) {
      return null;
    }
  }
  
  static Future<String> addDocument(String collectionName, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    final newDoc = Map<String, dynamic>.from(data);
    newDoc['id'] = newId;
    newDoc['createdAt'] = DateTime.now();
    newDoc['updatedAt'] = DateTime.now();
    
    _mockData[collectionName] ??= [];
    _mockData[collectionName]!.add(newDoc);
    
    return newId;
  }
  
  static Future<void> updateDocument(String collectionName, String docId, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final collection = _mockData[collectionName];
    if (collection != null) {
      final index = collection.indexWhere((doc) => doc['id'] == docId);
      if (index != -1) {
        collection[index].addAll(data);
        collection[index]['updatedAt'] = DateTime.now();
      }
    }
  }
  
  static Future<void> deleteDocument(String collectionName, String docId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final collection = _mockData[collectionName];
    if (collection != null) {
      collection.removeWhere((doc) => doc['id'] == docId);
    }
  }
}