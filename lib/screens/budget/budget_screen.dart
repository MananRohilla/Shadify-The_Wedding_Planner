import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../models/budget_item.dart';
import '../../services/budget_service.dart';
import 'budget_setup_dialog.dart';
import 'budget_item_dialog.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final _budgetService = BudgetService();
  List<BudgetItem> _budgetItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBudget();
  }

  Future<void> _loadBudget() async {
    setState(() => _isLoading = true);
    try {
      final items = await _budgetService.getBudgetItems();
      if (mounted) {
        setState(() {
          _budgetItems = items;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading budget: $e')),
        );
      }
    }
  }

  Future<void> _showSetupDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const BudgetSetupDialog(),
    );
    if (result == true) _loadBudget();
  }

  Future<void> _showItemDialog(BudgetItem item) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => BudgetItemDialog(item: item),
    );
    if (result == true) _loadBudget();
  }

  @override
  Widget build(BuildContext context) {
    final totalAllocated = _budgetService.calculateTotalAllocated(_budgetItems);
    final totalSpent = _budgetService.calculateTotalSpent(_budgetItems);
    final totalRemaining = _budgetService.calculateTotalRemaining(_budgetItems);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Calculator'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _budgetItems.isEmpty
              ? _buildEmptyState()
              : Column(
                  children: [
                    _buildSummaryCard(
                      totalAllocated,
                      totalSpent,
                      totalRemaining,
                    ),
                    Expanded(child: _buildBudgetList()),
                  ],
                ),
      floatingActionButton: _budgetItems.isEmpty
          ? FloatingActionButton.extended(
              onPressed: _showSetupDialog,
              icon: const Icon(Icons.add),
              label: const Text('Setup Budget'),
            )
          : null,
    );
  }

  Widget _buildSummaryCard(
    double total,
    double spent,
    double remaining,
  ) {
    final spentPercentage = total > 0 ? (spent / total) : 0.0;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF00BCD4),
            const Color(0xFF00ACC1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00BCD4).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem('Total Budget', total),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.3),
              ),
              _buildSummaryItem('Spent', spent),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: spentPercentage,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                spentPercentage > 0.9 ? Colors.red : Colors.white,
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Remaining',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '₹${_formatAmount(remaining)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, double amount) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '₹${_formatAmount(amount)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetList() {
    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _budgetItems.length,
        itemBuilder: (context, index) {
          final item = _budgetItems[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildBudgetItemCard(item),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBudgetItemCard(BudgetItem item) {
    final spentPercentage = item.allocatedAmount > 0
        ? (item.spentAmount / item.allocatedAmount)
        : 0.0;

    final categoryColor = _getCategoryColor(item.category);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showItemDialog(item),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: categoryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _getCategoryIcon(item.category),
                            size: 24,
                            color: categoryColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          item.category,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${item.percentage.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: categoryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Allocated',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '₹${_formatAmount(item.allocatedAmount)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Spent',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '₹${_formatAmount(item.spentAmount)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: spentPercentage > 0.9
                                ? Colors.red
                                : categoryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: spentPercentage,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      spentPercentage > 0.9 ? Colors.red : categoryColor,
                    ),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No budget set up',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your wedding budget to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    const colors = {
      'Venue': Color(0xFFE91E63),
      'Catering': Color(0xFFFF9800),
      'Photography': Color(0xFF9C27B0),
      'Decoration': Color(0xFF4CAF50),
      'Attire': Color(0xFF2196F3),
      'Entertainment': Color(0xFFFF5722),
      'Miscellaneous': Color(0xFF607D8B),
    };
    return colors[category] ?? const Color(0xFFE91E63);
  }

  IconData _getCategoryIcon(String category) {
    const icons = {
      'Venue': Icons.location_city,
      'Catering': Icons.restaurant,
      'Photography': Icons.camera_alt,
      'Decoration': Icons.palette,
      'Attire': Icons.checkroom,
      'Entertainment': Icons.music_note,
      'Miscellaneous': Icons.more_horiz,
    };
    return icons[category] ?? Icons.account_balance_wallet;
  }

  String _formatAmount(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}
