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
  static final Map<String, List<Map<String, dynamic>>> _mockData = {
    'budget_items': [
      {
        'id': '1',
        'category': 'Venue',
        'budgetAmount': 5000.0,
        'actualAmount': 4800.0,
        'description': 'Wedding venue rental',
        'createdAt': DateTime.now().subtract(const Duration(days: 10)),
      },
      {
        'id': '2',
        'category': 'Catering',
        'budgetAmount': 3000.0,
        'actualAmount': 0.0,
        'description': 'Food and beverages',
        'createdAt': DateTime.now().subtract(const Duration(days: 8)),
      },
    ],
    'checklist_items': [
      {
        'id': '1',
        'title': 'Book wedding venue',
        'isCompleted': true,
        'dueDate': DateTime.now().subtract(const Duration(days: 30)),
        'category': 'Venue',
        'priority': 'High',
        'createdAt': DateTime.now().subtract(const Duration(days: 45)),
      },
      {
        'id': '2',
        'title': 'Send invitations',
        'isCompleted': false,
        'dueDate': DateTime.now().add(const Duration(days: 14)),
        'category': 'Invitations',
        'priority': 'Medium',
        'createdAt': DateTime.now().subtract(const Duration(days: 20)),
      },
    ],
    'guests': [
      {
        'id': '1',
        'name': 'John Smith',
        'email': 'john@example.com',
        'phone': '+1234567890',
        'rsvpStatus': 'Confirmed',
        'dietaryRestrictions': 'Vegetarian',
        'plusOne': false,
        'createdAt': DateTime.now().subtract(const Duration(days: 15)),
      },
      {
        'id': '2',
        'name': 'Emily Johnson',
        'email': 'emily@example.com',
        'phone': '+1234567891',
        'rsvpStatus': 'Pending',
        'dietaryRestrictions': '',
        'plusOne': true,
        'createdAt': DateTime.now().subtract(const Duration(days: 12)),
      },
    ],
    'venues': [
      {
        'id': '1',
        'name': 'Grand Ballroom',
        'address': '123 Wedding St, City, State',
        'capacity': 200,
        'pricePerPerson': 75.0,
        'description': 'Elegant ballroom with crystal chandeliers',
        'amenities': ['Parking', 'Sound System', 'Dance Floor'],
        'contactInfo': 'contact@grandballroom.com',
        'isBookmarked': true,
        'createdAt': DateTime.now().subtract(const Duration(days: 25)),
      },
      {
        'id': '2',
        'name': 'Garden Paradise',
        'address': '456 Nature Ave, City, State',
        'capacity': 150,
        'pricePerPerson': 60.0,
        'description': 'Beautiful outdoor garden setting',
        'amenities': ['Garden', 'Gazebo', 'Natural Lighting'],
        'contactInfo': 'info@gardenparadise.com',
        'isBookmarked': false,
        'createdAt': DateTime.now().subtract(const Duration(days: 20)),
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