import 'dart:io';

class transcriptsState {
  final File? adImage;
  final bool isLoading;
  final String? Image;
  transcriptsState({
    this.adImage,
     this.Image,
    required this.isLoading,
  });

  transcriptsState copyWith({
    File? adImage,
    String? Image,
    bool? isLoading,
  }) {
    return transcriptsState(
      adImage: adImage ?? this.adImage,
      Image: Image ?? this.Image,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}