import 'dart:io';

class CreateAdState {
  final File? adImage;
  final DateTime? expirationDateTime;
  final bool isLoading;

  CreateAdState({
    this.adImage,
    this.expirationDateTime,
    required this.isLoading,
  });

  CreateAdState copyWith({
    String? adTitle,
    File? adImage,
    DateTime? expirationDateTime,
    bool? isLoading,
  }) {
    return CreateAdState(
      adImage: adImage ?? this.adImage,
      expirationDateTime: expirationDateTime ?? this.expirationDateTime,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}