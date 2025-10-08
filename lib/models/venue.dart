class Venue {
  final String id;
  final String name;
  final String location;
  final String city;
  final int priceMin;
  final int priceMax;
  final int capacity;
  final String description;
  final String? imageUrl;
  final List<String> amenities;
  final double rating;
  final DateTime createdAt;

  Venue({
    required this.id,
    required this.name,
    required this.location,
    required this.city,
    required this.priceMin,
    required this.priceMax,
    required this.capacity,
    required this.description,
    this.imageUrl,
    required this.amenities,
    required this.rating,
    required this.createdAt,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      city: json['city'],
      priceMin: json['price_min'],
      priceMax: json['price_max'],
      capacity: json['capacity'],
      description: json['description'] ?? '',
      imageUrl: json['image_url'],
      amenities: List<String>.from(json['amenities'] ?? []),
      rating: (json['rating'] ?? 4.5).toDouble(),
      createdAt: json['created_at'] != null 
          ? (json['created_at'] is String 
              ? DateTime.parse(json['created_at'])
              : (json['created_at']).toDate())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'city': city,
      'price_min': priceMin,
      'price_max': priceMax,
      'capacity': capacity,
      'description': description,
      'image_url': imageUrl,
      'amenities': amenities,
      'rating': rating,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String get priceRange => '₹${_formatPrice(priceMin)} - ₹${_formatPrice(priceMax)}';

  String _formatPrice(int price) {
    if (price >= 100000) {
      return '${(price / 100000).toStringAsFixed(1)}L';
    }
    return price.toString();
  }
}
