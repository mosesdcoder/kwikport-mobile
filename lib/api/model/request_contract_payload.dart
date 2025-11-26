class RequestContractPayload {
  final String productName;
  final int quantity;
  final String location;
  final String availableDate;
  final String contactChannel;
  final String additionalNotes;

  RequestContractPayload({
    required this.productName,
    required this.quantity,
    required this.location,
    required this.availableDate,
    required this.contactChannel,
    required this.additionalNotes,
  });

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'quantity': quantity,
      'location': location,
      'availableDate': availableDate,
      'contactChannel': contactChannel,
      'additionalNotes': additionalNotes,
    };
  }
}
