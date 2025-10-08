class Guest {
  final String id;
  final String userId;
  final String name;
  final String? email;
  final String? phone;
  final String rsvpStatus;
  final bool plusOne;
  final String? dietaryRestrictions;
  final DateTime createdAt;
  final DateTime updatedAt;

  Guest({
    required this.id,
    required this.userId,
    required this.name,
    this.email,
    this.phone,
    required this.rsvpStatus,
    required this.plusOne,
    this.dietaryRestrictions,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Guest.fromJson(Map<String, dynamic> json) {
    return Guest(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      rsvpStatus: json['rsvp_status'] ?? 'pending',
      plusOne: json['plus_one'] ?? false,
      dietaryRestrictions: json['dietary_restrictions'],
      createdAt: json['created_at'] != null 
          ? (json['created_at'] is String 
              ? DateTime.parse(json['created_at'])
              : (json['created_at']).toDate())
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? (json['updated_at'] is String 
              ? DateTime.parse(json['updated_at'])
              : (json['updated_at']).toDate())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'rsvp_status': rsvpStatus,
      'plus_one': plusOne,
      'dietary_restrictions': dietaryRestrictions,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Guest copyWith({
    String? id,
    String? userId,
    String? name,
    String? email,
    String? phone,
    String? rsvpStatus,
    bool? plusOne,
    String? dietaryRestrictions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Guest(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      rsvpStatus: rsvpStatus ?? this.rsvpStatus,
      plusOne: plusOne ?? this.plusOne,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
