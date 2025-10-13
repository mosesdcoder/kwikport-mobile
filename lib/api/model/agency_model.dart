class Agency {
  final String id;
  final String name;
  final int agencyType;
  final String routeCoverage;
  final String address;
  final double rating;
  final int numberOfDaysToDeliver;
  final double serviceFee;

  Agency({
    required this.id,
    required this.name,
    required this.agencyType,
    required this.routeCoverage,
    required this.address,
    required this.rating,
    required this.numberOfDaysToDeliver,
    required this.serviceFee,
  });

  factory Agency.fromJson(Map<String, dynamic> json) => Agency(
        id: json['id'],
        name: json['name'],
        agencyType: json['agencyType'],
        routeCoverage: json['routeCoverage'] ?? '',
        address: json['address'] ?? '',
        rating: (json['rating'] ?? 0).toDouble(),
        numberOfDaysToDeliver: json['numberOfDaysToDeliver'] ?? 0,
        serviceFee: (json['serviceFee'] ?? 0).toDouble(),
      );
}
