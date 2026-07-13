import 'package:equatable/equatable.dart';

import '../models/category_model.dart';
import '../models/product_model.dart';

abstract class InventoryEvent extends Equatable {
  const InventoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategories extends InventoryEvent {}

class AddCategory extends InventoryEvent {
  const AddCategory(this.category);

  final CategoryModel category;

  @override
  List<Object?> get props => [category];
}

class UpdateCategory extends InventoryEvent {
  const UpdateCategory(this.category);

  final CategoryModel category;

  @override
  List<Object?> get props => [category];
}

class DeleteCategory extends InventoryEvent {
  const DeleteCategory(this.categoryId);

  final String categoryId;

  @override
  List<Object?> get props => [categoryId];
}

class LoadProducts extends InventoryEvent {
  const LoadProducts(this.categoryId);

  final String categoryId;

  @override
  List<Object?> get props => [categoryId];
}

class AddProduct extends InventoryEvent {
  const AddProduct(this.product);

  final ProductModel product;

  @override
  List<Object?> get props => [product];
}

class UpdateProduct extends InventoryEvent {
  const UpdateProduct(this.product);

  final ProductModel product;

  @override
  List<Object?> get props => [product];
}

class DeleteProduct extends InventoryEvent {
  const DeleteProduct(this.categoryId, this.productId);

  final String categoryId;
  final String productId;

  @override
  List<Object?> get props => [categoryId, productId];
}
