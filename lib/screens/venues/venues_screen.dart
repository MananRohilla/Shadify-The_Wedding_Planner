import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../models/venue.dart';
import '../../services/venue_service.dart';
import '../../widgets/venue_card.dart';
import 'venue_filter_dialog.dart';

class VenuesScreen extends StatefulWidget {
  const VenuesScreen({super.key});

  @override
  State<VenuesScreen> createState() => _VenuesScreenState();
}

class _VenuesScreenState extends State<VenuesScreen> {
  final _venueService = VenueService();
  List<Venue> _venues = [];
  bool _isLoading = true;

  int? _maxBudget;
  int? _minCapacity;
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    _loadVenues();
  }

  Future<void> _loadVenues() async {
    setState(() => _isLoading = true);
    try {
      final venues = await _venueService.getVenues(
        maxBudget: _maxBudget,
        minCapacity: _minCapacity,
        city: _selectedCity,
      );
      if (mounted) {
        setState(() {
          _venues = venues;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading venues: $e')),
        );
      }
    }
  }

  Future<void> _showFilterDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => VenueFilterDialog(
        initialBudget: _maxBudget,
        initialCapacity: _minCapacity,
        initialCity: _selectedCity,
      ),
    );

    if (result != null) {
      setState(() {
        _maxBudget = result['budget'];
        _minCapacity = result['capacity'];
        _selectedCity = result['city'];
      });
      await _loadVenues();
    }
  }

  void _clearFilters() {
    setState(() {
      _maxBudget = null;
      _minCapacity = null;
      _selectedCity = null;
    });
    _loadVenues();
  }

  bool get _hasActiveFilters =>
      _maxBudget != null || _minCapacity != null || _selectedCity != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wedding Venues'),
        actions: [
          if (_hasActiveFilters)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearFilters,
              tooltip: 'Clear filters',
            ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_hasActiveFilters) _buildActiveFiltersChips(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _venues.isEmpty
                    ? _buildEmptyState()
                    : _buildVenuesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFiltersChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        children: [
          if (_maxBudget != null)
            Chip(
              label: Text('Budget: ≤ ₹${_formatBudget(_maxBudget!)}'),
              deleteIcon: const Icon(Icons.close, size: 18),
              onDeleted: () {
                setState(() => _maxBudget = null);
                _loadVenues();
              },
            ),
          if (_minCapacity != null)
            Chip(
              label: Text('Capacity: ≥ $_minCapacity'),
              deleteIcon: const Icon(Icons.close, size: 18),
              onDeleted: () {
                setState(() => _minCapacity = null);
                _loadVenues();
              },
            ),
          if (_selectedCity != null)
            Chip(
              label: Text('City: $_selectedCity'),
              deleteIcon: const Icon(Icons.close, size: 18),
              onDeleted: () {
                setState(() => _selectedCity = null);
                _loadVenues();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildVenuesList() {
    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _venues.length,
        itemBuilder: (context, index) {
          final venue = _venues[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: VenueCard(venue: venue),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_city,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No venues found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _hasActiveFilters
                ? 'Try adjusting your filters'
                : 'No venues available',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          if (_hasActiveFilters) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _clearFilters,
              child: const Text('Clear Filters'),
            ),
          ],
        ],
      ),
    );
  }

  String _formatBudget(int budget) {
    if (budget >= 100000) {
      return '${(budget / 100000).toStringAsFixed(1)}L';
    }
    return budget.toString();
  }
}
