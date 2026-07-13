import 'package:equatable/equatable.dart';

import '../models/category_model.dart';
import '../models/product_model.dart';

abstract class InventoryState extends Equatable {
  const InventoryState();

  @override
  List<Object?> get props => [];
}

class InventoryLoading extends InventoryState {}

class CategoriesLoaded extends InventoryState {
  const CategoriesLoaded(this.categories);

  final List<CategoryModel> categories;

  @override
  List<Object?> get props => [categories];
}

class ProductsLoaded extends InventoryState {
  const ProductsLoaded(this.products);

  final List<ProductModel> products;

  @override
  List<Object?> get props => [products];
}

class InventoryError extends InventoryState {
  const InventoryError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
