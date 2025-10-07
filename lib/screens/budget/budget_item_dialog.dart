import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/budget_item.dart';
import '../../services/budget_service.dart';

class BudgetItemDialog extends StatefulWidget {
  final BudgetItem item;

  const BudgetItemDialog({super.key, required this.item});

  @override
  State<BudgetItemDialog> createState() => _BudgetItemDialogState();
}

class _BudgetItemDialogState extends State<BudgetItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _spentController = TextEditingController();
  final _budgetService = BudgetService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _spentController.text = widget.item.spentAmount.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _spentController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final spentAmount = double.parse(_spentController.text);
      await _budgetService.updateBudgetItem(
        widget.item.copyWith(
          spentAmount: spentAmount,
          updatedAt: DateTime.now(),
        ),
      );

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Budget updated successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Update ${widget.item.category} Budget'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(
                'Allocated Amount',
                '₹${widget.item.allocatedAmount.toStringAsFixed(0)}',
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                'Remaining',
                '₹${widget.item.remainingAmount.toStringAsFixed(0)}',
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _spentController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Spent Amount (₹)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter spent amount';
                  }
                  final spent = double.tryParse(value);
                  if (spent == null || spent < 0) {
                    return 'Please enter a valid amount';
                  }
                  if (spent > widget.item.allocatedAmount) {
                    return 'Spent exceeds allocated budget';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleUpdate,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00BCD4),
            foregroundColor: Colors.white,
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Update'),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00BCD4),
          ),
        ),
      ],
    );
  }
}
