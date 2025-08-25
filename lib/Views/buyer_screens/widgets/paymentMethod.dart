enum PaymentMethod {
  jazzCash('jazzCash'),
  easyPaisa('easyPaisa'),
  bankTransfer('bankAccount');

  final String value;
  const PaymentMethod(this.value);

  // Helper method to convert string back to enum
  static PaymentMethod fromString(String value) {
    return values.firstWhere(
          (e) => e.value == value,
      orElse: () => PaymentMethod.jazzCash, // default if not found
    );
  }
}