enum DocumentTypeEnum {
  NationalId, // 1
  Passport, // 2
  DriversLicense, // 3
  VotersCard, // 4
  BankStatement, // 5
  UtilityBill, // 6
  BusinessRegistration, // 7
  TaxCertificate, // 8
  ProofOfAddress, // 9
  Selfie, // 10
}

extension DocumentTypeEnumExtension on DocumentTypeEnum {
  int get value {
    return this.index + 1; // Enum index starts at 0, backend starts at 1
  }
}
