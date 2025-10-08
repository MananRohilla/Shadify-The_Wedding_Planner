// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../main.dart';
import '../models/budget_item.dart';
import 'offline_service.dart';

class BudgetService {
  // Using offline mock service for development
  
  Future<List<BudgetItem>> getBudgetItems() async {
    if (!MockAuthService.isLoggedIn) return [];

    final mockData = await MockDataService.getCollectionAsync('budget_items');
    
    return mockData
        .map((data) => BudgetItem.fromJson(data))
        .toList();
  }

  Future<String> addBudgetItem(BudgetItem item) async {
    if (!MockAuthService.isLoggedIn) throw Exception('User not authenticated');

    final data = item.toJson();
    data.remove('id'); // Remove id as it will be generated
    
    final docId = await MockDataService.addDocument('budget_items', data);
    return docId;
  }

  Future<void> updateBudgetItem(BudgetItem item) async {
    if (!MockAuthService.isLoggedIn) throw Exception('User not authenticated');
    if (item.id.isEmpty) throw Exception('Item ID is required');

    final data = item.toJson();
    data.remove('id'); // Don't update the ID field
    
    await MockDataService.updateDocument('budget_items', item.id, data);
  }

  Future<void> deleteBudgetItem(String itemId) async {
    if (!MockAuthService.isLoggedIn) throw Exception('User not authenticated');

    await MockDataService.deleteDocument('budget_items', itemId);
  }

  Future<void> createDefaultBudget(double totalBudget) async {
    if (!MockAuthService.isLoggedIn) throw Exception('User not authenticated');
    
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
      final budgetItem = BudgetItem(
        id: '',
        userId: MockAuthService.currentUserEmail ?? '',
        category: entry.key,
        allocatedAmount: allocatedAmount,
        spentAmount: 0.0,
        percentage: entry.value,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await addBudgetItem(budgetItem);
    }
  }

  Future<double> getTotalBudget() async {
    final items = await getBudgetItems();
    return items.fold<double>(0.0, (sum, item) => sum + item.allocatedAmount);
  }

  Future<double> getTotalSpent() async {
    final items = await getBudgetItems();
    return items.fold<double>(0.0, (sum, item) => sum + item.spentAmount);
  }

  Future<double> getRemainingBudget() async {
    final totalBudget = await getTotalBudget();
    final totalSpent = await getTotalSpent();
    return totalBudget - totalSpent;
  }

  // Helper methods needed by UI
  double calculateTotalAllocated(List<BudgetItem> items) {
    return items.fold(0.0, (sum, item) => sum + item.allocatedAmount);
  }

  double calculateTotalSpent(List<BudgetItem> items) {
    return items.fold(0.0, (sum, item) => sum + item.spentAmount);
  }

  double calculateTotalRemaining(List<BudgetItem> items) {
    return calculateTotalAllocated(items) - calculateTotalSpent(items);
  }
}
