class createFeatureProductState {
  final DateTime? expirationDateTime;
  final bool isLoading;

  createFeatureProductState({
    this.expirationDateTime,
    required this.isLoading,
  });

  createFeatureProductState copyWith({
    DateTime? expirationDateTime,
    bool? isLoading,
  }) {
    return createFeatureProductState(
      expirationDateTime: expirationDateTime ?? this.expirationDateTime,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}