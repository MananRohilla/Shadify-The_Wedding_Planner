import '../main.dart';
import '../models/checklist_item.dart';

class ChecklistService {
  Future<List<ChecklistItem>> getChecklistItems() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await supabase
        .from('checklist_items')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((item) => ChecklistItem.fromJson(item))
        .toList();
  }

  Future<ChecklistItem> createChecklistItem({
    required String title,
    String? description,
    required String category,
    DateTime? dueDate,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final response = await supabase
        .from('checklist_items')
        .insert({
          'user_id': userId,
          'title': title,
          'description': description,
          'category': category,
          'due_date': dueDate?.toIso8601String(),
          'is_completed': false,
        })
        .select()
        .single();

    return ChecklistItem.fromJson(response);
  }

  Future<void> updateChecklistItem(ChecklistItem item) async {
    await supabase
        .from('checklist_items')
        .update({
          'title': item.title,
          'description': item.description,
          'category': item.category,
          'is_completed': item.isCompleted,
          'due_date': item.dueDate?.toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', item.id);
  }

  Future<void> toggleComplete(String itemId, bool isCompleted) async {
    await supabase
        .from('checklist_items')
        .update({
          'is_completed': isCompleted,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', itemId);
  }

  Future<void> deleteChecklistItem(String itemId) async {
    await supabase.from('checklist_items').delete().eq('id', itemId);
  }

  Future<void> createDefaultChecklist() async {
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
