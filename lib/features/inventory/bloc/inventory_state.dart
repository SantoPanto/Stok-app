part of 'inventory_bloc.dart';

sealed class InventoryState extends Equatable {
  const InventoryState();
  @override
  List<Object?> get props => [];
}

final class InventoryLoading extends InventoryState {}

final class CategoriesLoaded extends InventoryState {
  final List<CategoryModel> categories;
  const CategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

final class ProductsLoaded extends InventoryState {
  final List<ProductModel> products;
  const ProductsLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

final class InventoryError extends InventoryState {
  final String message;
  const InventoryError(this.message);

  @override
  List<Object?> get props => [message];
}