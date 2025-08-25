enum PaymentMethodSelection {
  COD('cashOnDelivery'),
  online('Online');

  final String value;
  const PaymentMethodSelection(this.value);

  // Helper method to convert string back to enum
  static PaymentMethodSelection fromString(String value) {
    return values.firstWhere(
          (e) => e.value == value,
      orElse: () => PaymentMethodSelection.COD, // default if not found
    );
  }
}