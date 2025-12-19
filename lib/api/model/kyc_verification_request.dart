class KycRequestPayload {
  final String expiryDate;
  final String businessName;
  final String businessType;
  final String businessAddress;
  final String businessRegNumber;
  final String exportExperience;
  final List<KycRequestDocument> documents;

  KycRequestPayload({
    required this.expiryDate,
    required this.businessName,
    required this.businessType,
    required this.businessAddress,
    required this.businessRegNumber,
    required this.exportExperience,
    required this.documents,
  });

  factory KycRequestPayload.fromJson(Map<String, dynamic> json) {
    return KycRequestPayload(
      expiryDate: json["expiryDate"] ?? "",
      businessName: json["businessName"] ?? "",
      businessType: json["businessType"] ?? "",
      businessAddress: json["businessAddress"] ?? "",
      businessRegNumber: json["businessRegNumber"] ?? "",
      exportExperience: json["exportExperience"] ?? "",
      documents: (json["documents"] as List<dynamic>? ?? [])
          .map((e) => KycRequestDocument.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "expiryDate": expiryDate,
      "businessName": businessName,
      "businessType": businessType,
      "businessAddress": businessAddress,
      "businessRegNumber": businessRegNumber,
      "exportExperience": exportExperience,
      "documents": documents.map((x) => x.toJson()).toList(),
    };
  }
}

class KycRequestDocument {
  final int documentType;
  final String documentNumber;
  final String document;
  final String fileName;
  final String certificationType;
  final String idNumber;
  final String mimeType;

  KycRequestDocument({
    required this.documentType,
    required this.documentNumber,
    required this.document,
    required this.fileName,
    required this.certificationType,
    required this.idNumber,
    required this.mimeType,
  });

  factory KycRequestDocument.fromJson(Map<String, dynamic> json) {
    return KycRequestDocument(
      documentType: json["documentType"] ?? 0,
      documentNumber: json["documentNumber"] ?? "",
      document: json["document"] ?? "",
      fileName: json["fileName"] ?? "",
      certificationType: json["certificationType"] ?? "",
      idNumber: json["idNumber"] ?? "",
      mimeType: json["mimeType"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "documentType": documentType,
      "documentNumber": documentNumber,
      "document": document,
      "fileName": fileName,
      "certificationType": certificationType,
      "idNumber": idNumber,
      "mimeType": mimeType,
    };
  }
}