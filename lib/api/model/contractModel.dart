// models/contract_model.dart
class PublishedContractModel {
  final String? id;
  final String? contractId;
  // final String? exporterId;
  final String? destinationCountry;
  final double? totalQuantity;
  final double? totalAmount;
  final double? totalAmountSpent;
  final double? projectedIncome;
  final double? pricePerUnitInUSD;
  final int? contractStatus;
  final int? exportStage;
  final bool? isReferred;
  final bool? isActive;
  final String? commodityId;
  final int? exportContractStageEnum;
  final int? contractFulfilmentMethod;
  final int? contractType;
  final int? contractDuration;

  PublishedContractModel({
    this.id,
    this.contractId,
    // this.exporterId,
    this.destinationCountry,
    this.totalQuantity,
    this.totalAmount,
    this.totalAmountSpent,
    this.projectedIncome,
    this.pricePerUnitInUSD,
    this.contractStatus,
    this.exportStage,
    this.isReferred,
    this.isActive,
    this.commodityId,
    this.exportContractStageEnum,
    this.contractFulfilmentMethod,
    this.contractType,
    this.contractDuration,
  });

  factory PublishedContractModel.fromJson(Map<String, dynamic> json) {
    return PublishedContractModel(
      id: json['id'],
      contractId: json['contractId'],
      // exporterId: json['exporterId'],
      destinationCountry: json['destinationCountry'],
      totalQuantity: json['totalQuantity'],
      totalAmount:
          (json['totalAmount'] != null)
              ? (json['totalAmount'] as num).toDouble()
              : null,
      totalAmountSpent:
          (json['totalAmountSpent'] != null)
              ? (json['totalAmountSpent'] as num).toDouble()
              : null,
      projectedIncome:
          (json['projectedIncome'] != null)
              ? (json['projectedIncome'] as num).toDouble()
              : null,
      pricePerUnitInUSD:
          (json['pricePerUnitInUSD'] != null)
              ? (json['pricePerUnitInUSD'] as num).toDouble()
              : null,
      contractStatus: json['contractStatus'],
      exportStage: json['exportStage'],
      isReferred: json['isReferred'],
      isActive: json['isActive'],
      commodityId: json['commodityId'],
      exportContractStageEnum: json['exportContractStageEnum'],
      contractFulfilmentMethod: json['contractFulfilmentMethod'],
      contractType: json['contractType'],
      contractDuration: json['contractDuration'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'contractId': contractId,
    // 'exporterId': exporterId,
    'destinationCountry': destinationCountry,
    'totalQuantity': totalQuantity,
    'totalAmount': totalAmount,
    'totalAmountSpent': totalAmountSpent,
    'projectedIncome': projectedIncome,
    'pricePerUnitInUSD': pricePerUnitInUSD,
    'contractStatus': contractStatus,
    'exportStage': exportStage,
    'isReferred': isReferred,
    'isActive': isActive,
    'commodityId': commodityId,
    'exportContractStageEnum': exportContractStageEnum,
    'contractFulfilmentMethod': contractFulfilmentMethod,
    'contractType': contractType,
    'contractDuration': contractDuration,
  };
}
