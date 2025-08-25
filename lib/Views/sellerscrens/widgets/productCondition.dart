
enum ProductCondition {
  New('New'),
  Used('Used');

  final String value;
  const ProductCondition(this.value);

  // Helper method to convert string back to enum
  static ProductCondition fromString(String value) {
  return values.firstWhere(
  (e) => e.value == value,
  orElse: () => ProductCondition.New, // default if not found
  );
  }
}