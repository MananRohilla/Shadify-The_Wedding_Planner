import '../models/venue.dart';
import 'offline_service.dart';

class VenueService {
  Future<List<Venue>> getVenues({
    int? maxBudget,
    int? minCapacity, 
    String? city,
  }) async {
    final mockData = await MockDataService.getCollectionAsync('venues');
    var venues = mockData.map((data) => Venue.fromJson(data)).toList();
    
    // Apply filters
    if (maxBudget != null) {
      venues = venues.where((venue) => venue.priceMin <= maxBudget).toList();
    }
    
    if (minCapacity != null) {
      venues = venues.where((venue) => venue.capacity >= minCapacity).toList();
    }
    
    if (city != null && city.isNotEmpty) {
      venues = venues.where((venue) => venue.city.toLowerCase().contains(city.toLowerCase())).toList();
    }
    
    return venues;
  }

  Future<String> addVenue(Venue venue) async {
    if (!MockAuthService.isLoggedIn) throw Exception('User not authenticated');
    final data = venue.toJson();
    data.remove('id');
    final docId = await MockDataService.addDocument('venues', data);
    return docId;
  }

  Future<void> updateVenue(Venue venue) async {
    if (!MockAuthService.isLoggedIn) throw Exception('User not authenticated');
    if (venue.id.isEmpty) throw Exception('Venue ID is required');
    final data = venue.toJson();
    data.remove('id');
    await MockDataService.updateDocument('venues', venue.id, data);
  }

  Future<void> deleteVenue(String venueId) async {
    if (!MockAuthService.isLoggedIn) throw Exception('User not authenticated');
    await MockDataService.deleteDocument('venues', venueId);
  }
}
