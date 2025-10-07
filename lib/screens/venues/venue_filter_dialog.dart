import 'package:flutter/material.dart';

class VenueFilterDialog extends StatefulWidget {
  final int? initialBudget;
  final int? initialCapacity;
  final String? initialCity;

  const VenueFilterDialog({
    super.key,
    this.initialBudget,
    this.initialCapacity,
    this.initialCity,
  });

  @override
  State<VenueFilterDialog> createState() => _VenueFilterDialogState();
}

class _VenueFilterDialogState extends State<VenueFilterDialog> {
  late double _budgetValue;
  late double _capacityValue;
  String? _selectedCity;

  final List<String> _cities = [
    'All Cities',
    'Bangalore',
    'Mumbai',
    'Delhi',
    'Jaipur',
    'Udaipur',
    'Goa',
    'Shimla',
    'Kolkata',
  ];

  @override
  void initState() {
    super.initState();
    _budgetValue = widget.initialBudget?.toDouble() ?? 1000000;
    _capacityValue = widget.initialCapacity?.toDouble() ?? 300;
    _selectedCity = widget.initialCity ?? 'All Cities';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Venues'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Maximum Budget',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${_formatBudget(_budgetValue.toInt())}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE91E63),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() => _budgetValue = 1000000);
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
            Slider(
              value: _budgetValue,
              min: 100000,
              max: 2000000,
              divisions: 19,
              activeColor: const Color(0xFFE91E63),
              onChanged: (value) {
                setState(() => _budgetValue = value);
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Minimum Capacity',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_capacityValue.toInt()} guests',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE91E63),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() => _capacityValue = 300);
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
            Slider(
              value: _capacityValue,
              min: 100,
              max: 1000,
              divisions: 18,
              activeColor: const Color(0xFFE91E63),
              onChanged: (value) {
                setState(() => _capacityValue = value);
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'City',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedCity,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: _cities.map((city) {
                return DropdownMenuItem(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedCity = value);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              'budget': _budgetValue.toInt(),
              'capacity': _capacityValue.toInt(),
              'city': _selectedCity == 'All Cities' ? null : _selectedCity,
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE91E63),
            foregroundColor: Colors.white,
          ),
          child: const Text('Apply'),
        ),
      ],
    );
  }

  String _formatBudget(int budget) {
    if (budget >= 100000) {
      return '${(budget / 100000).toStringAsFixed(1)}L';
    }
    return budget.toString();
  }
}
