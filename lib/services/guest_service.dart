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
    data.remove('id');
    final docId = await MockDataService.addDocument('guests', data);
    return docId;
  }

  Future<void> updateGuest(Guest guest) async {
    if (!MockAuthService.isLoggedIn) throw Exception('User not authenticated');
    if (guest.id.isEmpty) throw Exception('Guest ID is required');
    final data = guest.toJson();
    data.remove('id');
    await MockDataService.updateDocument('guests', guest.id, data);
  }

  Future<void> updateRSVPStatus(String guestId, String status) async {
    if (!MockAuthService.isLoggedIn) throw Exception('User not authenticated');
    await MockDataService.updateDocument('guests', guestId, {'rsvp_status': status});
  }

  Future<void> deleteGuest(String guestId) async {
    if (!MockAuthService.isLoggedIn) throw Exception('User not authenticated');
    await MockDataService.deleteDocument('guests', guestId);
  }

  int getTotalGuestCount(List<Guest> guests) {
    return guests.fold(0, (sum, guest) => sum + 1 + (guest.plusOne ? 1 : 0));
  }

  Map<String, int> getRSVPStats(List<Guest> guests) {
    return {
      'confirmed': guests.where((g) => g.rsvpStatus == 'confirmed').length,
      'declined': guests.where((g) => g.rsvpStatus == 'declined').length,
      'pending': guests.where((g) => g.rsvpStatus == 'pending').length,
    };
  }
}
