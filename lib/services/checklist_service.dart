// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../main.dart';
import '../models/checklist_item.dart';
import 'offline_service.dart';

class ChecklistService {
  // final CollectionReference _checklistItemsRef = firestore.collection('checklist_items');

  Future<List<ChecklistItem>> getChecklistItems() async {
    // Using offline mock service for development
    if (!MockAuthService.isLoggedIn) return [];

    final mockData = await MockDataService.getCollectionAsync('checklist_items');
    
    return mockData
        .map((data) => ChecklistItem.fromJson(data))
        .toList();
  }

  Future<ChecklistItem> createChecklistItem({
    required String title,
    String? description,
    required String category,
    DateTime? dueDate,
  }) async {
    if (!MockAuthService.isLoggedIn) throw Exception('User not authenticated');

    final data = {
      'user_id': MockAuthService.currentUserEmail ?? 'demo',
      'title': title,
      'description': description ?? '',
      'category': category,
      'due_date': (dueDate ?? DateTime.now().add(const Duration(days: 7))).toIso8601String(),
      'is_completed': false,
    };

    final docId = await MockDataService.addDocument('checklist_items', data);
    data['id'] = docId;
    return ChecklistItem.fromJson(data);
  }

  Future<void> updateChecklistItem(ChecklistItem item) async {
    if (!MockAuthService.isLoggedIn) throw Exception('User not authenticated');

    final data = {
      'title': item.title,
      'description': item.description,
      'category': item.category,
      'is_completed': item.isCompleted,
      'due_date': item.dueDate?.toIso8601String(),
    };
    
    await MockDataService.updateDocument('checklist_items', item.id, data);
  }

  Future<void> toggleComplete(String itemId, bool isCompleted) async {
    if (!MockAuthService.isLoggedIn) throw Exception('User not authenticated');
    
    await MockDataService.updateDocument('checklist_items', itemId, {
      'is_completed': isCompleted,
    });
  }

  Future<void> deleteChecklistItem(String itemId) async {
    if (!MockAuthService.isLoggedIn) throw Exception('User not authenticated');
    
    await MockDataService.deleteDocument('checklist_items', itemId);
  }

  Future<void> createDefaultChecklist() async {
    if (!MockAuthService.isLoggedIn) throw Exception('User not authenticated');
    
    final defaultItems = [
      {'title': 'Book Wedding Venue', 'category': 'Venue', 'description': 'Research and book the perfect venue'},
      {'title': 'Hire Photographer', 'category': 'Photography', 'description': 'Find and book a professional photographer'},
      {'title': 'Book Catering Service', 'category': 'Catering', 'description': 'Select menu and book caterers'},
      {'title': 'Plan Mehendi Ceremony', 'category': 'Mehendi', 'description': 'Organize mehendi artist and venue'},
      {'title': 'Organize Sangeet Night', 'category': 'Sangeet', 'description': 'Plan music, venue and performances'},
      {'title': 'Book Honeymoon', 'category': 'Honeymoon', 'description': 'Plan and book honeymoon destination'},
      {'title': 'Send Invitations', 'category': 'Planning', 'description': 'Design and send wedding invitations'},
      {'title': 'Buy Wedding Attire', 'category': 'Shopping', 'description': 'Shop for bride and groom outfits'},
    ];

    for (var item in defaultItems) {
      await createChecklistItem(
        title: item['title']!,
        description: item['description'],
        category: item['category']!,
      );
    }
  }
}
