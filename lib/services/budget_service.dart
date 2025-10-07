import '../main.dart';
import '../models/budget_item.dart';

class BudgetService {
  Future<List<BudgetItem>> getBudgetItems() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await supabase
        .from('budget_items')
        .select()
        .eq('user_id', userId)
        .order('category');

    return (response as List).map((item) => BudgetItem.fromJson(item)).toList();
  }

  Future<BudgetItem> createBudgetItem({
    required String category,
    required double allocatedAmount,
    required double percentage,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final response = await supabase
        .from('budget_items')
        .insert({
          'user_id': userId,
          'category': category,
          'allocated_amount': allocatedAmount,
          'spent_amount': 0,
          'percentage': percentage,
        })
        .select()
        .single();

    return BudgetItem.fromJson(response);
  }

  Future<void> updateBudgetItem(BudgetItem item) async {
    await supabase.from('budget_items').update({
      'allocated_amount': item.allocatedAmount,
      'spent_amount': item.spentAmount,
      'percentage': item.percentage,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', item.id);
  }

  Future<void> deleteBudgetItem(String itemId) async {
    await supabase.from('budget_items').delete().eq('id', itemId);
  }

  Future<void> createDefaultBudget(double totalBudget) async {
    final defaultCategories = {
      'Venue': 30.0,
      'Catering': 25.0,
      'Photography': 10.0,
      'Decoration': 15.0,
      'Attire': 10.0,
      'Entertainment': 5.0,
      'Miscellaneous': 5.0,
    };

    for (var entry in defaultCategories.entries) {
      final allocatedAmount = (totalBudget * entry.value) / 100;
      await createBudgetItem(
        category: entry.key,
        allocatedAmount: allocatedAmount,
        percentage: entry.value,
      );
    }
  }

  double calculateTotalAllocated(List<BudgetItem> items) {
    return items.fold(0, (sum, item) => sum + item.allocatedAmount);
  }

  double calculateTotalSpent(List<BudgetItem> items) {
    return items.fold(0, (sum, item) => sum + item.spentAmount);
  }

  double calculateTotalRemaining(List<BudgetItem> items) {
    return calculateTotalAllocated(items) - calculateTotalSpent(items);
  }
}
