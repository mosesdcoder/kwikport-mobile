// lib/api/model/dashboard_model.dart
import 'package:kwik_port/api/model/userModel.dart'; // for ExporterModel
import 'package:kwik_port/api/model/contractModel.dart'; // for PublishedContractModel

class DashboardModel {
  final UserProfile? userProfile;
  final double walletBalance;
  final double kwikLCBalance;
  final List<KwikTicketModel> kwikTickets;
  final List<ContractModel> exports;

  DashboardModel({
    required this.userProfile,
    required this.walletBalance,
    required this.kwikLCBalance,
    required this.kwikTickets,
    required this.exports,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      userProfile:
          json['userProfile'] != null
              ? UserProfile.fromJson(json['userProfile'])
              : null,
      walletBalance: (json['walletBalance'] ?? 0).toDouble(),
      kwikLCBalance: (json['kwikLCBalance'] ?? 0).toDouble(),
      kwikTickets:
          (json['kwikTickets'] as List<dynamic>?)
              ?.map((e) => KwikTicketModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      exports:
          (json['exports'] as List<dynamic>?)
              ?.map((e) => ContractModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class UserProfile {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String businessName;
  final DateTime? createdAt;

  UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.businessName,
    this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final created = json['createdAt'] ?? json['createdDate'];
    return UserProfile(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      businessName: json['businessName'] ?? '',
      createdAt: created != null ? DateTime.tryParse(created) : null,
    );
  }
}

class KwikTicketModel {
  final String id;
  final String? createdBy;
  final String? createdByIp;
  final DateTime? createdDate;
  final String? modifiedBy;
  final String? modifiedByIp;
  final DateTime? modifiedDate;
  final bool? isDeleted;
  final String? exportContractId;
  final double? peggedDollarValue;
  final String? badge;
  final bool? isActive;
  final DateTime? deadline;
  final String uniqueId;
  final double kwikTicketAmount;
  final int? kwikTicketStatus;
  final double? projectedIncomeInDollars;
  final double? totalQuantity;
  final DateTime? createdAt;
  final ExporterModel? exporter;
  final ContractModel? contract;
  final Commodity? commodity;
  final BuyerSpecification? buyerSpecification;

  KwikTicketModel({
    required this.id,
    this.createdBy,
    this.createdByIp,
    this.createdDate,
    this.modifiedBy,
    this.modifiedByIp,
    this.modifiedDate,
    this.isDeleted,
    this.exportContractId,
    this.peggedDollarValue,
    this.badge,
    this.isActive,
    this.deadline,
    required this.uniqueId,
    required this.kwikTicketAmount,
    this.kwikTicketStatus,
    this.projectedIncomeInDollars,
    this.totalQuantity,
    this.createdAt,
    this.exporter,
    this.contract,
    this.commodity,
    this.buyerSpecification,
  });

  factory KwikTicketModel.fromJson(Map<String, dynamic> json) {
    final uniqueId =
        json['kwickTicketUniqueId'] ?? json['kwikTicketUniqueId'] ?? '';

    return KwikTicketModel(
      id: json['id'] ?? '',
      createdBy: json['createdBy'],
      createdByIp: json['createdByIp'],
      createdDate:
          json['createdDate'] != null
              ? DateTime.tryParse(json['createdDate'])
              : null,
      modifiedBy: json['modifiedBy'],
      modifiedByIp: json['modifiedByIp'],
      modifiedDate:
          json['modifiedDate'] != null
              ? DateTime.tryParse(json['modifiedDate'])
              : null,
      isDeleted: json['isDeleted'],
      exportContractId: json['exportContractId'],
      peggedDollarValue: (json['peggedDollarValue'] as num?)?.toDouble(),
      badge: json['badge'],
      isActive: json['isActive'],
      deadline:
          json['deadline'] != null ? DateTime.tryParse(json['deadline']) : null,
      uniqueId: uniqueId,
      kwikTicketAmount: (json['kwikTicketAmount'] as num?)?.toDouble() ?? 0.0,
      kwikTicketStatus: json['kwikTicketStatus'],
      projectedIncomeInDollars:
          (json['projectedIncomeInDollars'] as num?)?.toDouble(),
      totalQuantity: (json['totalQuantity'] as num?)?.toDouble(),
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'])
              : null,
      exporter:
          json['exporter'] != null
              ? ExporterModel.fromJson(json['exporter'])
              : null,
      contract:
          json['contract'] != null
              ? ContractModel.fromJson(json['contract'])
              : null,
      commodity:
          json['commodity'] != null
              ? Commodity.fromJson(json['commodity'])
              : null,
      buyerSpecification:
          json['buyerSpecification'] != null
              ? BuyerSpecification.fromJson(json['buyerSpecification'])
              : null,
    );
  }
}

// class KwikTicketModel {
//   final String id;
//   final String? createdBy;
//   final String? createdByIp;
//   final DateTime? createdDate;
//   final String? modifiedBy;
//   final String? modifiedByIp;
//   final DateTime? modifiedDate;
//   final bool? isDeleted;
//   final String? exportContractId;
//   // final String? exporterId;
//   final double? peggedDollarValue;
//   final String? badge;
//   final bool? isActive;
//   final DateTime? deadline;
//   final String uniqueId; // kwickTicketUniqueId or fallback
//   final double kwikTicketAmount;
//   final int? kwikTicketStatus;
//   final double? projectedIncomeInDollars;
//   final double? totalQuantity;
//   final DateTime? createdAt;
//   final ExporterModel? exporter; // reuse your ExporterModel
//   final ContractModel? contract; // reuse your PublishedContractModel
//   final Commodity? commodity;
//   final BuyerSpecification? buyerSpecification;

//   KwikTicketModel({
//     required this.id,
//     this.createdBy,
//     this.createdByIp,
//     this.createdDate,
//     this.modifiedBy,
//     this.modifiedByIp,
//     this.modifiedDate,
//     this.isDeleted,
//     this.exportContractId,
//     // this.exporterId,
//     this.peggedDollarValue,
//     this.badge,
//     this.isActive,
//     this.deadline,
//     required this.uniqueId,
//     required this.kwikTicketAmount,
//     this.kwikTicketStatus,
//     this.projectedIncomeInDollars,
//     this.totalQuantity,
//     this.createdAt,
//     this.exporter,
//     this.contract,
//     this.commodity,
//     this.buyerSpecification,
//   });

//   factory KwikTicketModel.fromJson(Map<String, dynamic> json) {
//     final createdDateRaw = json['createdDate'] ?? json['createdAt'];
//     final modifiedDateRaw = json['modifiedDate'];
//     final deadlineRaw = json['deadline'];

//     // handle both spellings if backend has inconsistent naming
//     final uniqueId =
//         json['kwickTicketUniqueId'] ?? json['kwikTicketUniqueId'] ?? '';

//     return KwikTicketModel(
//       id: json['id'] ?? '',
//       createdBy: json['createdBy'],
//       createdByIp: json['createdByIp'],
//       createdDate:
//           createdDateRaw != null ? DateTime.tryParse(createdDateRaw) : null,
//       modifiedBy: json['modifiedBy'],
//       modifiedByIp: json['modifiedByIp'],
//       modifiedDate:
//           modifiedDateRaw != null ? DateTime.tryParse(modifiedDateRaw) : null,
//       isDeleted: json['isDeleted'],
//       exportContractId: json['exportContractId'],
//       // exporterId: json['exporterId'],
//       peggedDollarValue:
//           (json['peggedDollarValue'] is num)
//               ? (json['peggedDollarValue'] as num).toDouble()
//               : (json['peggedDollarValue'] != null
//                   ? double.tryParse('${json['peggedDollarValue']}')
//                   : null),
//       badge: json['badge'],
//       isActive: json['isActive'],
//       deadline: deadlineRaw != null ? DateTime.tryParse(deadlineRaw) : null,
//       uniqueId: uniqueId ?? '',
//       kwikTicketAmount:
//           (json['kwikTicketAmount'] is num)
//               ? (json['kwikTicketAmount'] as num).toDouble()
//               : 0.0,
//       kwikTicketStatus: json['kwikTicketStatus'],
//       projectedIncomeInDollars:
//           (json['projectedIncomeInDollars'] is num)
//               ? (json['projectedIncomeInDollars'] as num).toDouble()
//               : null,
//       totalQuantity:
//           (json['totalQuantity'] is num)
//               ? (json['totalQuantity'] as num).toDouble()
//               : null,
//       createdAt:
//           json['createdAt'] != null
//               ? DateTime.tryParse(json['createdAt'])
//               : null,
//       exporter:
//           json['exporter'] != null
//               ? ExporterModel.fromJson(json['exporter'])
//               : null,
//       contract:
//           json['contract'] != null
//               ? ContractModel.fromJson(json['contract'])
//               : null,
//       commodity:
//           json['commodity'] != null
//               ? Commodity.fromJson(json['commodity'])
//               : null,
//       buyerSpecification:
//           json['buyerSpecification'] != null
//               ? BuyerSpecification.fromJson(json['buyerSpecification'])
//               : null,
//     );
//   }
// }

class Commodity {
  final String id;
  final String name;
  final String? description;
  final String? unitOfMeasurement;
  final bool? isAvailable;
  final double? price;
  final String? hsCode;
  final String? unit;
  final double? averageMarketPricePerUnit;
  final double? marketPriceInTonOrKg;
  final String? imageUrl;
  final bool? isActive;

  Commodity({
    required this.id,
    required this.name,
    this.description,
    this.unitOfMeasurement,
    this.isAvailable,
    this.price,
    this.hsCode,
    this.unit,
    this.averageMarketPricePerUnit,
    this.marketPriceInTonOrKg,
    this.imageUrl,
    this.isActive,
  });

  factory Commodity.fromJson(Map<String, dynamic> json) {
    return Commodity(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      unitOfMeasurement: json['unitOfMeasurement'],
      isAvailable: json['isAvailable'],
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : null,
      hsCode: json['hsCode'],
      unit: json['unit'],
      averageMarketPricePerUnit:
          (json['averageMarketPricePerUnit'] is num)
              ? (json['averageMarketPricePerUnit'] as num).toDouble()
              : null,
      marketPriceInTonOrKg:
          (json['marketPriceInTonOrKg'] is num)
              ? (json['marketPriceInTonOrKg'] as num).toDouble()
              : null,
      imageUrl: json['imageUrl'],
      isActive: json['isActive'],
    );
  }
}

class BuyerSpecification {
  final double? commodityCountPerMeasurement;
  final double? moistureContent;
  final double? defectsInPercentage;
  final double? fatContentInPercentage;
  final double? buyerPricePerUnit;
  final String? buyerName;

  BuyerSpecification({
    this.commodityCountPerMeasurement,
    this.moistureContent,
    this.defectsInPercentage,
    this.fatContentInPercentage,
    this.buyerPricePerUnit,
    this.buyerName,
  });

  factory BuyerSpecification.fromJson(Map<String, dynamic> json) {
    return BuyerSpecification(
      commodityCountPerMeasurement:
          (json['commodityCountPerMeasurement'] is num)
              ? (json['commodityCountPerMeasurement'] as num).toDouble()
              : null,
      moistureContent:
          (json['moistureContent'] is num)
              ? (json['moistureContent'] as num).toDouble()
              : null,
      defectsInPercentage:
          (json['defectsInPercentage'] is num)
              ? (json['defectsInPercentage'] as num).toDouble()
              : null,
      fatContentInPercentage:
          (json['fatContentInPercentage'] is num)
              ? (json['fatContentInPercentage'] as num).toDouble()
              : null,
      buyerPricePerUnit:
          (json['buyerPricePerUnit'] is num)
              ? (json['buyerPricePerUnit'] as num).toDouble()
              : null,
      buyerName: json['buyerName'],
    );
  }
  Map<String, dynamic> toJson() => {
    'commodityCountPerMeasurement': commodityCountPerMeasurement,
    'moistureContent': moistureContent,
    'defectsInPercentage': defectsInPercentage,
    'fatContentInPercentage': fatContentInPercentage,
    'buyerPricePerUnit': buyerPricePerUnit,
    'buyerName': buyerName,
  };
}

class ContractModel {
  final String id;
  final String contractId;
  final String destinationCountry;
  final double? totalQuantity;
  final double? totalAmount;
  final double? totalAmountSpent;
  final double? projectedIncome;
  final double? pricePerUnitInUSD;
  final double? fulfilledQuantity;
  final int? contractStatus;
  final int? exportStage;
  final String? referredBy;
  final bool? isReferred;
  final bool? isActive;
  final double? exportCommission;
  final String commodityId;
  final String commodityName;
  final String? commodityImage; // fixed
  final int? exportContractStageEnum;
  final int? contractFulfilmentMethod;
  final int? contractType;
  final int? contractCategory;
  final int? contractDuration;
  final BuyerSpecification? buyerSpecification;
  final double? fulfillmentPercentage;

  ContractModel({
    required this.id,
    required this.contractId,
    required this.destinationCountry,
    this.totalQuantity,
    this.totalAmount,
    this.totalAmountSpent,
    this.projectedIncome,
    this.pricePerUnitInUSD,
    this.fulfilledQuantity,
    this.contractStatus,
    this.exportStage,
    this.referredBy,
    this.isReferred,
    this.isActive,
    this.exportCommission,
    required this.commodityId,
    required this.commodityName,
    this.commodityImage,
    this.exportContractStageEnum,
    this.contractFulfilmentMethod,
    this.contractType,
    this.contractCategory,
    this.contractDuration,
    this.buyerSpecification,
    this.fulfillmentPercentage,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) {
    return ContractModel(
      id: json['id'] ?? '',
      contractId: json['contractId'] ?? '',
      destinationCountry: json['destinationCountry'] ?? '',
      totalQuantity: (json['totalQuantity'] as num?)?.toDouble(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      totalAmountSpent: (json['totalAmountSpent'] as num?)?.toDouble(),
      projectedIncome: (json['projectedIncome'] as num?)?.toDouble(),
      pricePerUnitInUSD: (json['pricePerUnitInUSD'] as num?)?.toDouble(),
      fulfilledQuantity: (json['fulfilledQuantity'] as num?)?.toDouble(),
      contractStatus: json['contractStatus'],
      exportStage: json['exportStage'],
      referredBy: json['referredBy'],
      isReferred: json['isReferred'],
      isActive: json['isActive'],
      exportCommission: (json['exportCommission'] as num?)?.toDouble(),
      commodityId: json['commodityId'] ?? '',
      commodityName: json['commodityName'] ?? '',
      commodityImage: json['commodityImage'], // ✅ null-safe
      exportContractStageEnum: json['exportContractStageEnum'],
      contractFulfilmentMethod: json['contractFulfilmentMethod'],
      contractType: json['contractType'],
      contractCategory: json['contractCategory'],
      contractDuration: json['contractDuration'],
      buyerSpecification:
          json['buyerSpecification'] != null
              ? BuyerSpecification.fromJson(json['buyerSpecification'])
              : null,
      fulfillmentPercentage:
          (json['fulfillmentPercentage'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'contractId': contractId,
    'destinationCountry': destinationCountry,
    'totalQuantity': totalQuantity,
    'totalAmount': totalAmount,
    'totalAmountSpent': totalAmountSpent,
    'projectedIncome': projectedIncome,
    'pricePerUnitInUSD': pricePerUnitInUSD,
    'fulfilledQuantity': fulfilledQuantity,
    'contractStatus': contractStatus,
    'exportStage': exportStage,
    'referredBy': referredBy,
    'isReferred': isReferred,
    'isActive': isActive,
    'exportCommission': exportCommission,
    'commodityId': commodityId,
    'commodityName': commodityName,
    'commodityImage': commodityImage,
    'exportContractStageEnum': exportContractStageEnum,
    'contractFulfilmentMethod': contractFulfilmentMethod,
    'contractType': contractType,
    'contractCategory': contractCategory,
    'contractDuration': contractDuration,
    'buyerSpecification': buyerSpecification?.toJson(),
    'fulfillmentPercentage': fulfillmentPercentage,
  };
}
