import '../main.dart';
import '../models/guest.dart';

class GuestService {
  Future<List<Guest>> getGuests() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await supabase
        .from('guests')
        .select()
        .eq('user_id', userId)
        .order('name');

    return (response as List).map((guest) => Guest.fromJson(guest)).toList();
  }

  Future<Guest> createGuest({
    required String name,
    String? email,
    String? phone,
    bool plusOne = false,
    String? dietaryRestrictions,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final response = await supabase
        .from('guests')
        .insert({
          'user_id': userId,
          'name': name,
          'email': email,
          'phone': phone,
          'rsvp_status': 'pending',
          'plus_one': plusOne,
          'dietary_restrictions': dietaryRestrictions,
        })
        .select()
        .single();

    return Guest.fromJson(response);
  }

  Future<void> updateGuest(Guest guest) async {
    await supabase.from('guests').update({
      'name': guest.name,
      'email': guest.email,
      'phone': guest.phone,
      'rsvp_status': guest.rsvpStatus,
      'plus_one': guest.plusOne,
      'dietary_restrictions': guest.dietaryRestrictions,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', guest.id);
  }

  Future<void> updateRSVPStatus(String guestId, String status) async {
    await supabase.from('guests').update({
      'rsvp_status': status,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', guestId);
  }

  Future<void> deleteGuest(String guestId) async {
    await supabase.from('guests').delete().eq('id', guestId);
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
