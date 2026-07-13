part of 'inventory_bloc.dart';

sealed class InventoryEvent extends Equatable {
  const InventoryEvent();
  @override
  List<Object?> get props => [];
}

// --- Kategori İşlemleri (Events) ---
final class LoadCategories extends InventoryEvent {}

final class AddCategory extends InventoryEvent {
  final CategoryModel category;
  const AddCategory(this.category);
  
  @override
  List<Object?> get props => [category];
}

final class UpdateCategory extends InventoryEvent {
  final CategoryModel category;
  const UpdateCategory(this.category);
  
  @override
  List<Object?> get props => [category];
}

final class DeleteCategory extends InventoryEvent {
  final String categoryId;
  const DeleteCategory(this.categoryId);
  
  @override
  List<Object?> get props => [categoryId];
}

// --- Ürün İşlemleri (Events) ---
final class LoadProducts extends InventoryEvent {
  final String categoryId;
  const LoadProducts(this.categoryId);
  
  @override
  List<Object?> get props => [categoryId];
}

final class AddProduct extends InventoryEvent {
  final ProductModel product;
  const AddProduct(this.product);
  
  @override
  List<Object?> get props => [product];
}

final class UpdateProduct extends InventoryEvent {
  final ProductModel product;
  const UpdateProduct(this.product);
  
  @override
  List<Object?> get props => [product];
}

final class DeleteProduct extends InventoryEvent {
  final String categoryId;
  final String productId;
  const DeleteProduct(this.categoryId, this.productId);
  
  @override
  List<Object?> get props => [categoryId, productId];
}