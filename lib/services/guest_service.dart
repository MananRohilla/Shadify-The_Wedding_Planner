import '../models/guest.dart';
import 'offline_service.dart';

class GuestService {
  Future<List<Guest>> getGuests() async {
    if (!MockAuthService.isLoggedIn) return [];
    
    final mockData = await MockDataService.getCollectionAsync('guests');
    return mockData.map((data) => Guest.fromJson(data)).toList();
  }

  Future<String> addGuest(Guest guest) async {
    if (!MockAuthService.isLoggedIn) throw Exception('User not authenticated');

    final data = guest.toJson();
    data.remove('id'); // Remove id as it will be generated
    
    // Ensure proper field mapping
    data['user_id'] = MockAuthService.currentUserEmail ?? 'demo';
    data['created_at'] = DateTime.now();
    data['updated_at'] = DateTime.now();

    return await MockDataService.addDocument('guests', data);
  }

  Future<void> updateGuest(Guest guest) async {
    if (!MockAuthService.isLoggedIn) throw Exception('User not authenticated');
    
    if (guest.id.isEmpty) throw Exception('Guest ID is required');

    final data = guest.toJson();
    data.remove('id'); // Don't update the ID
    data['updated_at'] = DateTime.now();

    await MockDataService.updateDocument('guests', guest.id, data);
  }

  Future<void> updateRSVPStatus(String guestId, String status) async {
    if (!MockAuthService.isLoggedIn) throw Exception('User not authenticated');

    await MockDataService.updateDocument('guests', guestId, {
      'rsvp_status': status.toLowerCase(),
      'updated_at': DateTime.now(),
    });
  }

  Future<void> deleteGuest(String guestId) async {
    if (!MockAuthService.isLoggedIn) throw Exception('User not authenticated');

    await MockDataService.deleteDocument('guests', guestId);
  }

  int getTotalGuestCount(List<Guest> guests) {
    int total = guests.length;
    // Add plus ones
    for (var guest in guests) {
      if (guest.plusOne) total++;
    }
    return total;
  }

  Map<String, int> getRSVPStats(List<Guest> guests) {
    final stats = <String, int>{
      'confirmed': 0,
      'declined': 0,
      'pending': 0,
    };

    for (var guest in guests) {
      final status = guest.rsvpStatus.toLowerCase();
      if (stats.containsKey(status)) {
        stats[status] = stats[status]! + 1;
        if (guest.plusOne && status == 'confirmed') {
          stats[status] = stats[status]! + 1; // Add plus one
        }
      }
    }

    return stats;
  }
}
