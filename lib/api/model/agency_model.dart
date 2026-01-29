// lib/api/model/agency_model.dart

import 'package:kwik_port/api/model/agency_fee_model.dart';

class AgencyModel {
  final String id;
  final String name;
  final int? agencyType;
  final String? routeCoverage;
  final String? address;
  final double? rating;
  final int? numberOfDaysToDeliver;
  final double? serviceFee;
  final bool? isDeleted;
  final double? serviceFeeInUSD;
  final String? agencyId;
  final double? serviceFeePerTon;
  final double? serviceFeePerTonInUSD;
  final int? tonnage;
  final double? totalCost;
  final double? totalCostInUSD;
  AgencyFeeModel? fee;

  AgencyModel({
    required this.id,
    required this.name,
    this.agencyType,
    this.routeCoverage,
    this.address,
    this.rating,
    this.numberOfDaysToDeliver,
    this.serviceFee,
    this.isDeleted,
    this.serviceFeeInUSD,
    this.agencyId,
    this.serviceFeePerTon,
    this.serviceFeePerTonInUSD,
    this.tonnage,
    this.totalCost,
    this.totalCostInUSD,
    this.fee,
  });

  factory AgencyModel.fromJson(Map<String, dynamic> json) {
    return AgencyModel(
      id: json['id'] ?? json['agencyId'] ?? '',
      name: json['name'] ?? '',
      agencyType:
          json['agencyType'] is int
              ? json['agencyType']
              : (json['agencyType'] != null
                  ? int.tryParse('${json['agencyType']}')
                  : null),
      routeCoverage: json['routeCoverage'],
      address: json['address'],
      rating:
          (json['rating'] is num)
              ? (json['rating'] as num).toDouble()
              : (json['rating'] != null
                  ? double.tryParse('${json['rating']}')
                  : null),
      numberOfDaysToDeliver:
          json['numberOfDaysToDeliver'] is int
              ? json['numberOfDaysToDeliver']
              : (json['numberOfDaysToDeliver'] != null
                  ? int.tryParse('${json['numberOfDaysToDeliver']}')
                  : null),
      serviceFee:
          (json['serviceFee'] is num)
              ? (json['serviceFee'] as num).toDouble()
              : (json['serviceFee'] != null
                  ? double.tryParse('${json['serviceFee']}')
                  : (json['totalCost'] is num)
                      ? (json['totalCost'] as num).toDouble()
                      : (json['totalCost'] != null
                          ? double.tryParse('${json['totalCost']}')
                          : null)),
      isDeleted: json['isDeleted'],
      serviceFeeInUSD:
          (json['serviceFeeInUSD'] is num)
              ? (json['serviceFeeInUSD'] as num).toDouble()
              : (json['serviceFeeInUSD'] != null
                  ? double.tryParse('${json['serviceFeeInUSD']}')
                  : (json['totalCostInUSD'] is num)
                      ? (json['totalCostInUSD'] as num).toDouble()
                      : (json['totalCostInUSD'] != null
                          ? double.tryParse('${json['totalCostInUSD']}')
                          : null)),
      agencyId: json['agencyId'],
      serviceFeePerTon:
          (json['serviceFeePerTon'] is num)
              ? (json['serviceFeePerTon'] as num).toDouble()
              : (json['serviceFeePerTon'] != null
                  ? double.tryParse('${json['serviceFeePerTon']}')
                  : null),
      serviceFeePerTonInUSD:
          (json['serviceFeePerTonInUSD'] is num)
              ? (json['serviceFeePerTonInUSD'] as num).toDouble()
              : (json['serviceFeePerTonInUSD'] != null
                  ? double.tryParse('${json['serviceFeePerTonInUSD']}')
                  : null),
      tonnage:
          json['tonnage'] is int
              ? json['tonnage']
              : (json['tonnage'] != null
                  ? int.tryParse('${json['tonnage']}')
                  : null),
      totalCost:
          (json['totalCost'] is num)
              ? (json['totalCost'] as num).toDouble()
              : (json['totalCost'] != null
                  ? double.tryParse('${json['totalCost']}')
                  : null),
      totalCostInUSD:
          (json['totalCostInUSD'] is num)
              ? (json['totalCostInUSD'] as num).toDouble()
              : (json['totalCostInUSD'] != null
                  ? double.tryParse('${json['totalCostInUSD']}')
                  : null),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'agencyType': agencyType,
    'routeCoverage': routeCoverage,
    'address': address,
    'rating': rating,
    'numberOfDaysToDeliver': numberOfDaysToDeliver,
    'serviceFee': serviceFee,
    'isDeleted': isDeleted,
    'serviceFeeInUSD': serviceFeeInUSD,
    'agencyId': agencyId,
    'serviceFeePerTon': serviceFeePerTon,
    'serviceFeePerTonInUSD': serviceFeePerTonInUSD,
    'tonnage': tonnage,
    'totalCost': totalCost,
    'totalCostInUSD': totalCostInUSD,
    'fee':
        fee != null
            ? {
              'serviceFeePerTonInUSD': fee!.serviceFeePerTonInUSD,
              'totalCostInUSD': fee!.totalCostInUSD,
              'totalCost': fee!.totalCost,
              'tonnage': fee!.tonnage,
            }
            : null,
  };
}

// lib/api/model/export_substage_model.dart
// class ExportSubStageModel {
//   final String id;
//   final String subStageName;
//   final int? order;
//   final int? estimatedDays;
//   final DateTime? startDate;
  // final DateTime? completedDate;
  // final DateTime? estimatedCompletionDate;
  // final bool? isCompleted;
  // final bool? isActive;
  // final String? notes;
  // final String? hangfireJobId;

  // ExportSubStageModel({
  //   required this.id,
  //   required this.subStageName,
  //   this.order,
  //   this.estimatedDays,
  //   this.startDate,
  //   this.completedDate,
  //   this.estimatedCompletionDate,
  //   this.isCompleted,
  //   this.isActive,
  //   this.notes,
  //   this.hangfireJobId,
  // });

  // factory ExportSubStageModel.fromJson(Map<String, dynamic> json) {
  //   return ExportSubStageModel(
  //     id: json['id'] ?? '',
  //     subStageName: json['subStageName'] ?? '',
  //     order: json['order'] is int ? json['order'] : (json['order'] != null ? int.tryParse('${json['order']}') : null),
  //     estimatedDays: json['estimatedDays'] is int ? json['estimatedDays'] : (json['estimatedDays'] != null ? int.tryParse('${json['estimatedDays']}') : null),
  //     startDate: json['startDate'] != null ? DateTime.tryParse(json['startDate']) : null,
  //     completedDate: json['completedDate'] != null ? DateTime.tryParse(json['completedDate']) : null,
  //     estimatedCompletionDate: json['estimatedCompletionDate'] != null ? DateTime.tryParse(json['estimatedCompletionDate']) : null,
  //     isCompleted: json['isCompleted'],
  //     isActive: json['isActive'],
  //     notes: json['notes'],
  //     hangfireJobId: json['hangfireJobId'],
  //   );
  // }

  // Map<String, dynamic> toJson() => {
  //   'id': id,
//     'subStageName': subStageName,
//     'order': order,
//     'estimatedDays': estimatedDays,
//     'startDate': startDate?.toIso8601String(),
//     'completedDate': completedDate?.toIso8601String(),
//     'estimatedCompletionDate': estimatedCompletionDate?.toIso8601String(),
//     'isCompleted': isCompleted,
//     'isActive': isActive,
//     'notes': notes,
//     'hangfireJobId': hangfireJobId,
//   };
// }

