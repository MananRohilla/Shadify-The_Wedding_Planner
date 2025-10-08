// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../main.dart';
import '../models/checklist_item.dart';
import 'offline_service.dart';

class ChecklistService {
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
      'is_completed': false,
      'due_date': dueDate?.toIso8601String(),
      'created_at': DateTime.now(),
      'updated_at': DateTime.now(),
    };

    final docId = await MockDataService.addDocument('checklist_items', data);
    
    // Return the created item
    final createdData = Map<String, dynamic>.from(data);
    createdData['id'] = docId;
    
    return ChecklistItem.fromJson(createdData);
  }

  Future<void> updateChecklistItem(ChecklistItem item) async {
    if (!MockAuthService.isLoggedIn) throw Exception('User not authenticated');
    
    if (item.id.isEmpty) throw Exception('Item ID is required');

    final data = item.toJson();
    data.remove('id'); // Don't update the ID
    data['updated_at'] = DateTime.now();

    await MockDataService.updateDocument('checklist_items', item.id, data);
  }

  Future<void> toggleComplete(String itemId, bool isCompleted) async {
    if (!MockAuthService.isLoggedIn) throw Exception('User not authenticated');

    await MockDataService.updateDocument('checklist_items', itemId, {
      'is_completed': isCompleted,
      'updated_at': DateTime.now(),
    });
  }

  Future<void> deleteChecklistItem(String itemId) async {
    if (!MockAuthService.isLoggedIn) throw Exception('User not authenticated');

    await MockDataService.deleteDocument('checklist_items', itemId);
  }

  Future<void> createDefaultChecklist() async {
    if (!MockAuthService.isLoggedIn) throw Exception('User not authenticated');

    final defaultItems = [
      {'title': 'Book Wedding Venue', 'category': 'Venue', 'description': 'Research and book the perfect wedding venue'},
      {'title': 'Hire Wedding Photographer', 'category': 'Photography', 'description': 'Find and book professional wedding photographer'},
      {'title': 'Plan Catering Menu', 'category': 'Catering', 'description': 'Select menu and book catering service'},
      {'title': 'Organize Mehendi Ceremony', 'category': 'Mehendi', 'description': 'Plan mehendi function with decorations and arrangements'},
      {'title': 'Arrange Sangeet Night', 'category': 'Sangeet', 'description': 'Organize sangeet ceremony with music and dance'},
      {'title': 'Send Wedding Invitations', 'category': 'Planning', 'description': 'Design and send wedding invitations to guests'},
      {'title': 'Buy Wedding Attire', 'category': 'Shopping', 'description': 'Shop for bride and groom wedding outfits'},
      {'title': 'Book Honeymoon', 'category': 'Honeymoon', 'description': 'Plan and book honeymoon destination'},
    ];

    for (var item in defaultItems) {
      await createChecklistItem(
        title: item['title']!,
        description: item['description'],
        category: item['category']!,
        dueDate: DateTime.now().add(Duration(days: 30 + defaultItems.indexOf(item) * 7)),
      );
    }
  }
}
