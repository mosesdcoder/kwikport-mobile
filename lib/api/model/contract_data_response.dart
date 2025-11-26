class ContractDataResponse {
  final String userId;
  final String productName;
  final int quantity;
  final String location;
  final String availableDate;
  final String contactChannel;
  final String additionalNotes;
  final String id;
  final dynamic createdBy;
  final dynamic createdByIp;
  final String createdDate;
  final dynamic modifiedBy;
  final dynamic modifiedByIp;
  final dynamic modifiedDate;
  final bool isDeleted;

  ContractDataResponse({
    required this.userId,
    required this.productName,
    required this.quantity,
    required this.location,
    required this.availableDate,
    required this.contactChannel,
    required this.additionalNotes,
    required this.id,
    this.createdBy,
    this.createdByIp,
    required this.createdDate,
    this.modifiedBy,
    this.modifiedByIp,
    this.modifiedDate,
    required this.isDeleted,
  });

  factory ContractDataResponse.fromJson(Map<String, dynamic> json) {
    return ContractDataResponse(
      userId: json['userId'],
      productName: json['productName'],
      quantity: json['quantity'],
      location: json['location'],
      availableDate: json['availableDate'],
      contactChannel: json['contactChannel'],
      additionalNotes: json['additionalNotes'],
      id: json['id'],
      createdBy: json['createdBy'],
      createdByIp: json['createdByIp'],
      createdDate: json['createdDate'],
      modifiedBy: json['modifiedBy'],
      modifiedByIp: json['modifiedByIp'],
      modifiedDate: json['modifiedDate'],
      isDeleted: json['isDeleted'],
    );
  }
}
