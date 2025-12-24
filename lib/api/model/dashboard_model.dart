// lib/api/model/dashboard_model.dart
import 'package:kwik_port/api/model/userModel.dart'; // for ExporterModel
import 'package:kwik_port/api/model/contractModel.dart'; // for PublishedContractModel

class DashboardModel {
  final UserProfile? userProfile;
  final double walletBalance;
  final double totalExportContractBalance;
  final bool canWithdraw;
  final double kwikLCBalance;
  final List<KwikTicketModel> kwikTickets;
  final List<ExportSummaryModel> exports;

  DashboardModel({
    required this.userProfile,
    required this.walletBalance,
    required this.totalExportContractBalance,
    required this.canWithdraw,
    required this.kwikLCBalance,
    required this.kwikTickets,
    required this.exports,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    final walletData = json['walletBalance'] ?? {};

    return DashboardModel(
      userProfile:
          json['userProfile'] != null
              ? UserProfile.fromJson(json['userProfile'])
              : null,
      walletBalance: (walletData['walletBalance'] ?? 0).toDouble(),

      canWithdraw: walletData['canWithdraw'] ?? false,
      kwikLCBalance: (json['kwikLCBalance'] ?? 0).toDouble(),
      totalExportContractBalance:
          (json['totalExportContractBalance'] ?? 0).toDouble(),
      kwikTickets:
          (json['kwikTickets'] as List<dynamic>?)
              ?.map((e) => KwikTicketModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      exports:
          (json['exports'] as List<dynamic>?)
              ?.map(
                (e) => ExportSummaryModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userProfile': userProfile?.toJson(),
      'walletBalance': {
        'walletBalance': walletBalance,
        'canWithdraw': canWithdraw,
        'totalExportContractBalance': totalExportContractBalance,
      },
      'kwikLCBalance': kwikLCBalance,
      'totalExportContractBalance': totalExportContractBalance,
      'kwikTickets': kwikTickets.map((e) => e.toJson()).toList(),
      'exports': exports.map((e) => e.toJson()).toList(),
    };
  }
}

class UserProfile {
  final String id;
  final String exporterId;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String businessName;
  final DateTime? createdAt;

  UserProfile({
    required this.id,
    required this.exporterId,
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
      exporterId: json['exporterId'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      businessName: json['businessName'] ?? '',
      createdAt: created != null ? DateTime.tryParse(created) : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exporterId': exporterId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'businessName': businessName,
      'createdAt': createdAt?.toIso8601String(),
    };
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
  final double? profitRatio;
  double? quantityToFulfill;
  final double? grossEarning;
  final String? profitRatioDisplay;
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
    this.profitRatio,
    this.quantityToFulfill,
    this.grossEarning,
    this.profitRatioDisplay,
    this.exporter,
    this.contract,
    this.commodity,
    this.buyerSpecification,
  });

  factory KwikTicketModel.fromJson(Map<String, dynamic> json) {
    final uniqueId =
        json['kwickTicketUniqueId'] ?? json['kwickTicketUniqueId'] ?? '';

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
      profitRatio: (json['profitRatio'] as num?)?.toDouble(),
      quantityToFulfill: (json['quantityToFulfill'] as num?)?.toDouble(),
      grossEarning: (json['grossEarning'] as num?)?.toDouble(),
      profitRatioDisplay: json['profitRatioDisplay'],
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
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdBy': createdBy,
      'createdByIp': createdByIp,
      'createdDate': createdDate?.toIso8601String(),
      'modifiedBy': modifiedBy,
      'modifiedByIp': modifiedByIp,
      'modifiedDate': modifiedDate?.toIso8601String(),
      'isDeleted': isDeleted,
      'exportContractId': exportContractId,
      'peggedDollarValue': peggedDollarValue,
      'badge': badge,
      'isActive': isActive,
      'deadline': deadline?.toIso8601String(),
      'uniqueId': uniqueId,
      'kwikTicketAmount': kwikTicketAmount,
      'kwikTicketStatus': kwikTicketStatus,
      'projectedIncomeInDollars': projectedIncomeInDollars,
      'totalQuantity': totalQuantity,
      'createdAt': createdAt?.toIso8601String(),
      'profitRatio': profitRatio,
      'quantityToFulfill': quantityToFulfill,
      'grossEarning': grossEarning,
      'profitRatioDisplay': profitRatioDisplay,
      'exporter': exporter?.toJson(),
      'contract': contract?.toJson(),
      'commodity': commodity?.toJson(),
      'buyerSpecification': buyerSpecification?.toJson(),
    };
  }
}

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
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'unitOfMeasurement': unitOfMeasurement,
    'isAvailable': isAvailable,
    'price': price,
    'hsCode': hsCode,
    'unit': unit,
    'averageMarketPricePerUnit': averageMarketPricePerUnit,
    'marketPriceInTonOrKg': marketPriceInTonOrKg,
    'imageUrl': imageUrl,
    'isActive': isActive,
  };
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
  final String? createdBy;
  final String? createdByIp;
  final DateTime? createdDate;
  final String? modifiedBy;
  final String? modifiedByIp;
  final DateTime? modifiedDate;
  final bool? isDeleted;
  final String contractId;
  final String destinationCountry;
  final double? totalQuantity;
  final double? totalAmount;
  final double? totalAmountSpent;
  final double? profitRatio;
  final double? projectedIncome;
  final double? pricePerUnitInUSD;
  final double? pricePerUnitInNGN;
  final double? fulfilledQuantity;
  final String? contractStatus;
  final int? exportStage;
  final String? referredBy;
  final bool? isReferred;
  final bool? isActive;
  final double? exportCommission;
  final String commodityId;
  final String commodityName;
  final String? commodityImage; // fixed
  final String? exportContractStageEnum;
  final String? contractFulfilmentMethod;
  final int? contractType;
  final int? contractCategory;
  final int? contractDuration;
  final BuyerSpecification? buyerSpecification;
  final double? fulfillmentPercentage;

  ContractModel({
    required this.id,
    this.createdBy,
    this.createdByIp,
    this.createdDate,
    this.modifiedBy,
    this.modifiedByIp,
    this.modifiedDate,
    this.isDeleted,
    required this.contractId,
    required this.destinationCountry,
    this.totalQuantity,
    this.totalAmount,
    this.totalAmountSpent,
    this.profitRatio,
    this.projectedIncome,
    this.pricePerUnitInUSD,
    this.pricePerUnitInNGN,
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
      contractId: json['contractId'] ?? '',
      destinationCountry: json['destinationCountry'] ?? '',
      totalQuantity: (json['totalQuantity'] as num?)?.toDouble(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      totalAmountSpent: (json['totalAmountSpent'] as num?)?.toDouble(),
      profitRatio: (json['profitRatio'] as num?)?.toDouble(),
      projectedIncome: (json['projectedIncome'] as num?)?.toDouble(),
      pricePerUnitInUSD: (json['pricePerUnitInUSD'] as num?)?.toDouble(),
      pricePerUnitInNGN: (json['pricePerUnitInNGN'] as num?)?.toDouble(),
      fulfilledQuantity: (json['fulfilledQuantity'] as num?)?.toDouble(),
      contractStatus: (json['contractStatus']?.toString() ?? ''),
      exportStage: int.tryParse(json['exportStage']?.toString() ?? ''),
      referredBy: json['referredBy'],
      isReferred: json['isReferred'],
      isActive: json['isActive'],
      exportCommission: (json['exportCommission'] as num?)?.toDouble(),
      commodityId: json['commodityId'] ?? '',
      commodityName: json['commodityName'] ?? '',
      commodityImage: json['commodityImage'], // ✅ null-safe
      exportContractStageEnum:
          json['exportContractStageEnum']?.toString() ?? '',

      contractFulfilmentMethod:
          // int.tryParse(
          json['contractFulfilmentMethod']?.toString() ?? '',
      // ),
      contractType: int.tryParse(json['contractType']?.toString() ?? ''),
      contractCategory: int.tryParse(
        json['contractCategory']?.toString() ?? '',
      ),
      contractDuration: int.tryParse(
        json['contractDuration']?.toString() ?? '',
      ),
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
    'createdBy': createdBy,
    'createdByIp': createdByIp,
    'createdDate': createdDate?.toIso8601String(),
    'modifiedBy': modifiedBy,
    'modifiedByIp': modifiedByIp,
    'modifiedDate': modifiedDate?.toIso8601String(),
    'isDeleted': isDeleted,
    'contractId': contractId,
    'destinationCountry': destinationCountry,
    'totalQuantity': totalQuantity,
    'totalAmount': totalAmount,
    'totalAmountSpent': totalAmountSpent,
    'projectedIncome': projectedIncome,
    'pricePerUnitInUSD': pricePerUnitInUSD,
    'pricePerUnitInNGN':pricePerUnitInNGN,
    'profitRatio':profitRatio,
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

class CommodityCostModel {
  final String commodityId;
  final String commodityName;
  final int units;
  final double unitPrice;
  final double totalCost;

  CommodityCostModel({
    required this.commodityId,
    required this.commodityName,
    required this.units,
    required this.unitPrice,
    required this.totalCost,
  });

  factory CommodityCostModel.fromJson(Map<String, dynamic> json) {
    return CommodityCostModel(
      commodityId: json['commodityId'] ?? '',
      commodityName: json['commodityName'] ?? '',
      units: json['units'] ?? 0,
      unitPrice: (json['unitPrice'] ?? 0).toDouble(),
      totalCost: (json['totalCost'] ?? 0).toDouble(),
    );
  }
}

class ExportSummaryModel {
  final String id;
  final String contractId;
  final String exporterId;
  final String commodityName;
  final double totalQuantity;
  final double contractTotalAmount;
  final double grossEarning;
  final double totalAmountSpent;
  final String contractFulfilmentMethod;
  final String exportContractStage;
  final DateTime createdAt;
  final DateTime? completedAt;
  final KwikTicketModel? kwikTickets;
  final String buyerName;
  final DateTime? estimatedCompletionDate;
  double exportNumberOfDays;
  final String destinationCountry;
  final String contractUniqueId;
  final double? selectedCapacity;

  ExportSummaryModel({
    required this.id,
    required this.contractId,
    required this.exporterId,
    required this.commodityName,
    required this.totalQuantity,
    required this.contractTotalAmount,
    required this.grossEarning,
    required this.totalAmountSpent,
    required this.contractFulfilmentMethod,
    required this.exportContractStage,
    required this.createdAt,
    this.completedAt,
    required this.kwikTickets,
    required this.buyerName,
    this.estimatedCompletionDate,
    required this.exportNumberOfDays,
    required this.destinationCountry,
    required this.contractUniqueId,
    this.selectedCapacity,
  });

  factory ExportSummaryModel.fromJson(Map<String, dynamic> json) {
    return ExportSummaryModel(
      id: json['id'] ?? '',
      contractId: json['contractId'] ?? '',
      exporterId: json['exporterId'] ?? '',
      commodityName: json['commodityName'] ?? '',
      totalQuantity: (json['totalQuantity'] ?? 0).toDouble(),
      contractTotalAmount: (json['contractTotalAmount'] ?? 0).toDouble(),
      grossEarning: (json['grossEarning'] ?? 0).toDouble(),
      totalAmountSpent: (json['totalAmountSpent'] ?? 0).toDouble(),
      contractFulfilmentMethod: json['contractFulfilmentMethod'] ?? '',
      exportContractStage: json['exportContractStage'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      completedAt:
          json['completedAt'] != null
              ? DateTime.tryParse(json['completedAt'])
              : null,
      kwikTickets:
          json['kwikTickets'] != null
              ? KwikTicketModel.fromJson(json['kwikTickets'])
              : null,
      buyerName: json['buyerName'] ?? '',
      estimatedCompletionDate:
          json['estimatedCompletionDate'] != null
              ? DateTime.tryParse(json['estimatedCompletionDate'])
              : null,
      exportNumberOfDays: (json['exportNumberOfDays'] ?? 0).toDouble(),
      destinationCountry: json['destinationCountry'] ?? '',
      contractUniqueId: json['contractUniqueId'] ?? '',
      selectedCapacity: (json['selectedCapacity'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'contractId': contractId,
    'exporterId': exporterId,
    'commodityName': commodityName,
    'totalQuantity': totalQuantity,
    'contractTotalAmount': contractTotalAmount,
    'grossEarning': grossEarning,
    'totalAmountSpent': totalAmountSpent,
    'contractFulfilmentMethod': contractFulfilmentMethod,
    'exportContractStage': exportContractStage,
    'createdAt': createdAt.toIso8601String(),
    'completedAt': completedAt?.toIso8601String(),
    'kwikTickets': kwikTickets?.toJson(),
    'buyerName': buyerName,
    'estimatedCompletionDate': estimatedCompletionDate?.toIso8601String(),
    'exportNumberOfDays': exportNumberOfDays,
    'destinationCountry': destinationCountry,
    'contractUniqueId': contractUniqueId,
    'selectedCapacity': selectedCapacity ?? 0.0,

  };
}

