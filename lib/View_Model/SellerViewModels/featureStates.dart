import '../../models/ProductModel.dart';

class createFeatureProductState {
  final DateTime? expirationDateTime;
  final bool isLoading;
  final bool isCustomProduct;
  final ProductModel? selectedProduct;
  final List<ProductModel> products;

  createFeatureProductState({
    this.expirationDateTime,
    this.products=const[],
    this.selectedProduct,
    this.isCustomProduct=false,
    required this.isLoading,
  });

  createFeatureProductState copyWith({
    DateTime? expirationDateTime,
    List<ProductModel>? products,
    ProductModel? selectedPrduct,
    bool? isCustomProduct,
    bool? isLoading,
  }) {
    return createFeatureProductState(
      expirationDateTime: expirationDateTime ?? this.expirationDateTime,
      isLoading: isLoading ?? this.isLoading,
      products: products ??this.products,
      selectedProduct: selectedPrduct ?? this.selectedProduct,
      isCustomProduct: isCustomProduct ?? this.isCustomProduct,
    );
  }
}