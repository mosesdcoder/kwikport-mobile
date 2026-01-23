class TransactionResponse {
  final bool isSuccessful;
  final String message;
  final String responseCode;
  final List<String> errors;
  final TransactionData data;

  TransactionResponse({
    required this.isSuccessful,
    required this.message,
    required this.responseCode,
    required this.errors,
    required this.data,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      isSuccessful: json['isSuccessful'] ?? false,
      message: json['message'] ?? '',
      responseCode: json['responseCode'] ?? '',
      errors: List<String>.from(json['errors'] ?? []),
      data: TransactionData.fromJson(json['data'] ?? {}),
    );
  }
}

class TransactionData {
  final List<Transaction> results;
  final int currentPage;
  final int pageCount;
  final int pageSize;
  final int rowCount;

  TransactionData({
    required this.results,
    required this.currentPage,
    required this.pageCount,
    required this.pageSize,
    required this.rowCount,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      results: List<Transaction>.from(
        (json['results'] ?? []).map((x) => Transaction.fromJson(x)),
      ),
      currentPage: json['currentPage'] ?? 1,
      pageCount: json['pageCount'] ?? 0,
      pageSize: json['pageSize'] ?? 20,
      rowCount: json['rowCount'] ?? 0,
    );
  }
}

class Transaction {
  final String id;
  final String exporterId;
  final double amount;
  final String currency;
  final String paymentProvider;
  final String paymentStatus;
  final String paymentType;
  final String reference;
  final String providerReference;
  final DateTime createdAt;

  Transaction({
    required this.id,
    required this.exporterId,
    required this.amount,
    required this.currency,
    required this.paymentProvider,
    required this.paymentStatus,
    required this.paymentType,
    required this.reference,
    required this.providerReference,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      exporterId: json['exporterId'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? '',
      paymentProvider: json['paymentProvider'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      paymentType: json['paymentType'] ?? '',
      reference: json['reference'] ?? '',
      providerReference: json['providerReference'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
