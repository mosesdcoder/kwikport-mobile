// lib/api/model/agency_fee_model.dart

class AgencyFeeModel {
  final String? agencyId;
  final String? name;
  final int? agencyType;
  final String? routeCoverage;
  final String? address;
  final int? rating;
  final int? numberOfDaysToDeliver;
  final double? serviceFeePerTon;
  final double? serviceFeePerTonInUSD;
  final int? tonnage;
  final double? totalCost;
  final double? totalCostInUSD;
  final DateTime? createdDate;

  AgencyFeeModel({
    this.agencyId,
    this.name,
    this.agencyType,
    this.routeCoverage,
    this.address,
    this.rating,
    this.numberOfDaysToDeliver,
    this.serviceFeePerTon,
    this.serviceFeePerTonInUSD,
    this.tonnage,
    this.totalCost,
    this.totalCostInUSD,
    this.createdDate,
  });

  factory AgencyFeeModel.fromJson(Map<String, dynamic> json) {
    num? toNum(dynamic v) => v is num ? v : (v == null ? null : num.tryParse(v.toString()));

    return AgencyFeeModel(
      agencyId: json['agencyId'] as String?,
      name: json['name'] as String?,
      agencyType: toNum(json['agencyType'])?.toInt(),
      routeCoverage: json['routeCoverage'] as String?,
      address: json['address'] as String?,
      rating: toNum(json['rating'])?.toInt(),
      numberOfDaysToDeliver: toNum(json['numberOfDaysToDeliver'])?.toInt(),
      serviceFeePerTon: toNum(json['serviceFeePerTon'])?.toDouble(),
      serviceFeePerTonInUSD: toNum(json['serviceFeePerTonInUSD'])?.toDouble(),
      tonnage: toNum(json['tonnage'])?.toInt(),
      totalCost: toNum(json['totalCost'])?.toDouble(),
      totalCostInUSD: toNum(json['totalCostInUSD'])?.toDouble(),
      createdDate: json['createdDate'] != null ? DateTime.tryParse(json['createdDate'].toString()) : null,
    );
  }
}
