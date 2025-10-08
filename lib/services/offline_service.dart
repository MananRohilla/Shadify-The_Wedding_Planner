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
        'allocated_amount': 150000.0,
        'spent_amount': 140000.0,
        'percentage': 30.0,
        'created_at': DateTime.now().subtract(const Duration(days: 10)),
        'updated_at': DateTime.now().subtract(const Duration(days: 5)),
      },
      {
        'id': '2',
        'user_id': 'demo',
        'category': 'Catering',
        'allocated_amount': 125000.0,
        'spent_amount': 80000.0,
        'percentage': 25.0,
        'created_at': DateTime.now().subtract(const Duration(days: 8)),
        'updated_at': DateTime.now().subtract(const Duration(days: 3)),
      },
      {
        'id': '3',
        'user_id': 'demo',
        'category': 'Photography',
        'allocated_amount': 50000.0,
        'spent_amount': 45000.0,
        'percentage': 10.0,
        'created_at': DateTime.now().subtract(const Duration(days: 6)),
        'updated_at': DateTime.now().subtract(const Duration(days: 2)),
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
        'title': 'Hire photographer',
        'description': 'Find and book wedding photographer',
        'category': 'Photography',
        'is_completed': false,
        'due_date': DateTime.now().add(const Duration(days: 21)).toIso8601String(),
        'created_at': DateTime.now().subtract(const Duration(days: 20)),
        'updated_at': DateTime.now().subtract(const Duration(days: 10)),
      },
      {
        'id': '3',
        'user_id': 'demo',
        'title': 'Plan Mehendi ceremony',
        'description': 'Organize mehendi function details',
        'category': 'Mehendi',
        'is_completed': false,
        'due_date': DateTime.now().add(const Duration(days: 15)).toIso8601String(),
        'created_at': DateTime.now().subtract(const Duration(days: 18)),
        'updated_at': DateTime.now().subtract(const Duration(days: 8)),
      },
      {
        'id': '4',
        'user_id': 'demo',
        'title': 'Book catering service',
        'description': 'Select menu and book catering',
        'category': 'Catering',
        'is_completed': false,
        'due_date': DateTime.now().add(const Duration(days: 30)).toIso8601String(),
        'created_at': DateTime.now().subtract(const Duration(days: 15)),
        'updated_at': DateTime.now().subtract(const Duration(days: 5)),
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
      {
        'id': '3',
        'user_id': 'demo',
        'name': 'Michael Brown',
        'email': 'michael@example.com',
        'phone': '+1234567892',
        'rsvp_status': 'confirmed',
        'dietary_restrictions': 'No allergies',
        'plus_one': true,
        'created_at': DateTime.now().subtract(const Duration(days: 10)),
        'updated_at': DateTime.now().subtract(const Duration(days: 1)),
      },
    ],
    'venues': [
      // 10 premium wedding venues with high-quality images
      {
        'id': 'v1',
        'name': 'The Royal Palace Hotel',
        'location': '123 Royal Gardens, Luxury District',
        'city': 'Mumbai',
        'price_min': 200000,
        'price_max': 500000,
        'capacity': 400,
        'description': 'Magnificent palace hotel with ornate ballrooms, crystal chandeliers, and royal architecture. Perfect for grand wedding celebrations.',
        'image_url': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=1200&auto=format&fit=crop',
        'amenities': ['Valet Parking', 'Bridal Suite', 'Live Music Setup', 'Premium Catering', 'Photography Services'],
        'rating': 4.9,
        'created_at': DateTime.now().subtract(const Duration(days: 30)),
      },
      {
        'id': 'v2',
        'name': 'Garden Paradise Resort',
        'location': '456 Nature Valley, Green Hills',
        'city': 'Udaipur',
        'price_min': 150000,
        'price_max': 350000,
        'capacity': 300,
        'description': 'Breathtaking garden resort with lush landscapes, gazebos, and natural beauty. Ideal for outdoor wedding ceremonies.',
        'image_url': 'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?q=80&w=1200&auto=format&fit=crop',
        'amenities': ['Garden Ceremony', 'Gazebo', 'Outdoor Bar', 'Flower Arrangements', 'Lake View'],
        'rating': 4.8,
        'created_at': DateTime.now().subtract(const Duration(days: 25)),
      },
      {
        'id': 'v3',
        'name': 'Heritage Haveli',
        'location': '789 Heritage Street, Old City',
        'city': 'Jaipur',
        'price_min': 180000,
        'price_max': 400000,
        'capacity': 250,
        'description': 'Traditional haveli with authentic Rajasthani architecture, courtyards, and cultural ambiance.',
        'image_url': 'https://images.unsplash.com/photo-1613977257363-707ba9348227?q=80&w=1200&auto=format&fit=crop',
        'amenities': ['Heritage Architecture', 'Courtyard', 'Traditional Decor', 'Folk Music', 'Royal Dining'],
        'rating': 4.7,
        'created_at': DateTime.now().subtract(const Duration(days: 20)),
      },
      {
        'id': 'v4',
        'name': 'Beachside Bliss Resort',
        'location': '321 Coastal Highway, Sunset Beach',
        'city': 'Goa',
        'price_min': 120000,
        'price_max': 280000,
        'capacity': 200,
        'description': 'Stunning beachfront resort with ocean views, sandy beaches, and romantic sunset ceremonies.',
        'image_url': 'https://images.unsplash.com/photo-1537633552985-df8429e8048b?q=80&w=1200&auto=format&fit=crop',
        'amenities': ['Beach Access', 'Ocean View', 'Sunset Deck', 'Beachside Bar', 'Water Sports'],
        'rating': 4.6,
        'created_at': DateTime.now().subtract(const Duration(days: 18)),
      },
      {
        'id': 'v5',
        'name': 'Metropolitan Grand Ballroom',
        'location': '555 Business District, City Center',
        'city': 'Delhi',
        'price_min': 250000,
        'price_max': 600000,
        'capacity': 500,
        'description': 'Ultra-modern ballroom with state-of-the-art facilities, premium services, and luxurious ambiance.',
        'image_url': 'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?q=80&w=1200&auto=format&fit=crop',
        'amenities': ['Grand Ballroom', 'LED Lighting', 'Sound System', 'VIP Lounge', 'Concierge Service'],
        'rating': 4.8,
        'created_at': DateTime.now().subtract(const Duration(days: 15)),
      },
      {
        'id': 'v6',
        'name': 'Mountain View Lodge',
        'location': '777 Hill Station Road, Pine Valley',
        'city': 'Shimla',
        'price_min': 100000,
        'price_max': 250000,
        'capacity': 180,
        'description': 'Cozy mountain lodge with panoramic views, pine forests, and intimate ceremony spaces.',
        'image_url': 'https://images.unsplash.com/photo-1542558368009-1c18c5e95425?q=80&w=1200&auto=format&fit=crop',
        'amenities': ['Mountain View', 'Fireplace', 'Pine Forest', 'Hiking Trails', 'Spa Services'],
        'rating': 4.5,
        'created_at': DateTime.now().subtract(const Duration(days: 12)),
      },
      {
        'id': 'v7',
        'name': 'Lakeside Manor',
        'location': '888 Lakefront Drive, Crystal Lake',
        'city': 'Nainital',
        'price_min': 140000,
        'price_max': 320000,
        'capacity': 220,
        'description': 'Elegant manor overlooking pristine lake with boat access, waterfront ceremonies, and serene atmosphere.',
        'image_url': 'https://images.unsplash.com/photo-1549294413-26f195200c16?q=80&w=1200&auto=format&fit=crop',
        'amenities': ['Lake View', 'Boat Dock', 'Waterfront Deck', 'Private Beach', 'Fishing'],
        'rating': 4.7,
        'created_at': DateTime.now().subtract(const Duration(days: 10)),
      },
      {
        'id': 'v8',
        'name': 'Urban Loft Venue',
        'location': '999 Artistic Quarter, Creative District',
        'city': 'Bangalore',
        'price_min': 80000,
        'price_max': 200000,
        'capacity': 150,
        'description': 'Trendy industrial loft with exposed brick, modern art, and urban sophistication for contemporary weddings.',
        'image_url': 'https://images.unsplash.com/photo-1515184086462-9a6c8ae1c77e?q=80&w=1200&auto=format&fit=crop',
        'amenities': ['Industrial Design', 'Art Gallery', 'Rooftop Access', 'Modern Bar', 'DJ Setup'],
        'rating': 4.4,
        'created_at': DateTime.now().subtract(const Duration(days: 8)),
      },
      {
        'id': 'v9',
        'name': 'Vineyard Estate',
        'location': '234 Wine Country Road, Grape Valley',
        'city': 'Nashik',
        'price_min': 160000,
        'price_max': 380000,
        'capacity': 280,
        'description': 'Picturesque vineyard with rolling hills, wine cellars, and romantic grape arbor ceremonies.',
        'image_url': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?q=80&w=1200&auto=format&fit=crop',
        'amenities': ['Vineyard Tours', 'Wine Tasting', 'Grape Arbor', 'Cellar Dining', 'Harvest Views'],
        'rating': 4.6,
        'created_at': DateTime.now().subtract(const Duration(days: 6)),
      },
      {
        'id': 'v10',
        'name': 'Desert Oasis Resort',
        'location': '567 Dune Drive, Golden Sands',
        'city': 'Jodhpur',
        'price_min': 190000,
        'price_max': 450000,
        'capacity': 350,
        'description': 'Exotic desert resort with sand dunes, camel rides, and traditional Rajasthani hospitality under starlit skies.',
        'image_url': 'https://images.unsplash.com/photo-1571115764595-644a1f56a55c?q=80&w=1200&auto=format&fit=crop',
        'amenities': ['Desert Safari', 'Camel Rides', 'Stargazing', 'Traditional Music', 'Bonfire'],
        'rating': 4.8,
        'created_at': DateTime.now().subtract(const Duration(days: 4)),
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
    
    // Ensure proper user_id assignment
    if (!newDoc.containsKey('user_id') || newDoc['user_id'] == null || newDoc['user_id'] == '') {
      newDoc['user_id'] = MockAuthService.currentUserEmail ?? 'demo';
    }
    
    // Add timestamps if not present
    if (!newDoc.containsKey('created_at')) {
      newDoc['created_at'] = DateTime.now();
    }
    if (!newDoc.containsKey('updated_at')) {
      newDoc['updated_at'] = DateTime.now();
    }
    
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
        collection[index]['updated_at'] = DateTime.now();
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