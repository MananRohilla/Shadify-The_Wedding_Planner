import '../main.dart';
import '../models/venue.dart';

class VenueService {
  Future<List<Venue>> getVenues({
    int? maxBudget,
    int? minCapacity,
    String? city,
  }) async {
    var query = supabase.from('venues').select();

    if (maxBudget != null) {
      query = query.lte('price_min', maxBudget);
    }

    if (minCapacity != null) {
      query = query.gte('capacity', minCapacity);
    }

    if (city != null && city.isNotEmpty) {
      query = query.ilike('city', '%$city%');
    }

    final response = await query.order('rating', ascending: false);

    return (response as List).map((venue) => Venue.fromJson(venue)).toList();
  }

  Future<void> seedDummyVenues() async {
    final venues = [
      {
        'name': 'Royal Palace Gardens',
        'location': 'MG Road, Bangalore',
        'city': 'Bangalore',
        'price_min': 500000,
        'price_max': 1000000,
        'capacity': 500,
        'description': 'Luxurious outdoor venue with beautiful gardens and royal architecture. Perfect for grand celebrations.',
        'amenities': ['Outdoor Space', 'Parking', 'Catering', 'Decoration', 'AC Halls'],
        'rating': 4.8,
      },
      {
        'name': 'Taj Wedding Hall',
        'location': 'Bandra West, Mumbai',
        'city': 'Mumbai',
        'price_min': 800000,
        'price_max': 1500000,
        'capacity': 800,
        'description': 'Premium banquet hall with world-class amenities and stunning city views.',
        'amenities': ['Indoor Hall', 'Valet Parking', 'In-house Catering', 'Bridal Suite', 'DJ'],
        'rating': 4.9,
      },
      {
        'name': 'Lakeside Resort',
        'location': 'Udaipur City Palace Road',
        'city': 'Udaipur',
        'price_min': 300000,
        'price_max': 700000,
        'capacity': 300,
        'description': 'Romantic lakeside venue with breathtaking sunset views and traditional Rajasthani hospitality.',
        'amenities': ['Lake View', 'Outdoor Lawn', 'Accommodation', 'Traditional Decor'],
        'rating': 4.7,
      },
      {
        'name': 'Grand Hyatt Ballroom',
        'location': 'Vasant Kunj, New Delhi',
        'city': 'Delhi',
        'price_min': 1000000,
        'price_max': 2000000,
        'capacity': 1000,
        'description': 'Elegant ballroom with state-of-the-art facilities and impeccable service.',
        'amenities': ['Indoor Ballroom', 'Parking', 'Catering', 'Audio-Visual', 'Wedding Planner'],
        'rating': 4.9,
      },
      {
        'name': 'Heritage Haveli',
        'location': 'Old City, Jaipur',
        'city': 'Jaipur',
        'price_min': 400000,
        'price_max': 800000,
        'capacity': 400,
        'description': 'Traditional Rajasthani haveli with authentic architecture and cultural ambiance.',
        'amenities': ['Heritage Property', 'Courtyard', 'Folk Music', 'Traditional Catering'],
        'rating': 4.6,
      },
      {
        'name': 'Beachside Villa',
        'location': 'Candolim Beach, Goa',
        'city': 'Goa',
        'price_min': 600000,
        'price_max': 1200000,
        'capacity': 250,
        'description': 'Exclusive beachfront property perfect for intimate destination weddings.',
        'amenities': ['Beach Access', 'Villa Stay', 'Outdoor Setup', 'Seafood Catering'],
        'rating': 4.8,
      },
      {
        'name': 'Garden Paradise',
        'location': 'Whitefield, Bangalore',
        'city': 'Bangalore',
        'price_min': 350000,
        'price_max': 650000,
        'capacity': 350,
        'description': 'Lush green gardens with modern amenities and flexible event spaces.',
        'amenities': ['Garden', 'Indoor Hall', 'Parking', 'Decoration', 'Catering'],
        'rating': 4.5,
      },
      {
        'name': 'The Imperial Lawns',
        'location': 'Juhu, Mumbai',
        'city': 'Mumbai',
        'price_min': 700000,
        'price_max': 1400000,
        'capacity': 600,
        'description': 'Spacious lawns with contemporary design and premium services.',
        'amenities': ['Lawn', 'Banquet Hall', 'Valet', 'Stage Setup', 'Lighting'],
        'rating': 4.7,
      },
      {
        'name': 'Mountain View Resort',
        'location': 'Mall Road, Shimla',
        'city': 'Shimla',
        'price_min': 250000,
        'price_max': 500000,
        'capacity': 200,
        'description': 'Scenic mountain resort ideal for intimate hill station weddings.',
        'amenities': ['Mountain View', 'Accommodation', 'Bonfire', 'Indoor Dining'],
        'rating': 4.4,
      },
      {
        'name': 'Crystal Palace',
        'location': 'Park Street, Kolkata',
        'city': 'Kolkata',
        'price_min': 450000,
        'price_max': 900000,
        'capacity': 450,
        'description': 'Elegant venue with crystal chandeliers and colonial architecture.',
        'amenities': ['Ballroom', 'Parking', 'In-house Catering', 'Decor', 'Sound System'],
        'rating': 4.6,
      },
    ];

    for (var venue in venues) {
      await supabase.from('venues').insert(venue);
    }
  }
}
