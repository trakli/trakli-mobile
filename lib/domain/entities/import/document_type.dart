enum DocumentType {
  bankStatement,
  receipt,
  invoice,
  payStub,
  utilityBill;

  String get serverKey {
    return switch (this) {
      DocumentType.bankStatement => 'bank_statement',
      DocumentType.receipt => 'receipt',
      DocumentType.invoice => 'invoice',
      DocumentType.payStub => 'pay_stub',
      DocumentType.utilityBill => 'utility_bill',
    };
  }

  static DocumentType fromServerKey(String key) {
    return switch (key) {
      'bank_statement' => DocumentType.bankStatement,
      'receipt' => DocumentType.receipt,
      'invoice' => DocumentType.invoice,
      'pay_stub' => DocumentType.payStub,
      'utility_bill' => DocumentType.utilityBill,
      _ => throw ArgumentError('Unknown DocumentType server key: $key'),
    };
  }
}
