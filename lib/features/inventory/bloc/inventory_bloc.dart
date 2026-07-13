import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/inventory_repository.dart';
import 'inventory_event.dart';
import 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  InventoryBloc({InventoryRepository? repository})
      : _repository = repository ?? InventoryRepository(),
        super(InventoryLoading()) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategory>(_onAddCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<DeleteCategory>(_onDeleteCategory);
    on<LoadProducts>(_onLoadProducts);
    on<AddProduct>(_onAddProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
  }

  final InventoryRepository _repository;
  StreamSubscription? _categoriesSubscription;
  StreamSubscription? _productsSubscription;

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoading());
    _categoriesSubscription?.cancel();
    _categoriesSubscription = _repository.getCategoriesStream().listen(
      (categories) => emit(CategoriesLoaded(categories)),
      onError: (error) => emit(InventoryError(error.toString())),
    );
  }

  Future<void> _onAddCategory(
    AddCategory event,
    Emitter<InventoryState> emit,
  ) async {
    try {
      await _repository.addCategory(event.category);
    } catch (error) {
      emit(InventoryError(error.toString()));
    }
  }

  Future<void> _onUpdateCategory(
    UpdateCategory event,
    Emitter<InventoryState> emit,
  ) async {
    try {
      await _repository.updateCategory(event.category);
    } catch (error) {
      emit(InventoryError(error.toString()));
    }
  }

  Future<void> _onDeleteCategory(
    DeleteCategory event,
    Emitter<InventoryState> emit,
  ) async {
    try {
      await _repository.deleteCategory(event.categoryId);
    } catch (error) {
      emit(InventoryError(error.toString()));
    }
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoading());
    _productsSubscription?.cancel();
    _productsSubscription = _repository.getProductsStream(event.categoryId).listen(
      (products) => emit(ProductsLoaded(products)),
      onError: (error) => emit(InventoryError(error.toString())),
    );
  }

  Future<void> _onAddProduct(
    AddProduct event,
    Emitter<InventoryState> emit,
  ) async {
    try {
      await _repository.addProduct(event.product);
    } catch (error) {
      emit(InventoryError(error.toString()));
    }
  }

  Future<void> _onUpdateProduct(
    UpdateProduct event,
    Emitter<InventoryState> emit,
  ) async {
    try {
      await _repository.updateProduct(event.product);
    } catch (error) {
      emit(InventoryError(error.toString()));
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProduct event,
    Emitter<InventoryState> emit,
  ) async {
    try {
      await _repository.deleteProduct(event.categoryId, event.productId);
    } catch (error) {
      emit(InventoryError(error.toString()));
    }
  }

  @override
  Future<void> close() {
    _categoriesSubscription?.cancel();
    _productsSubscription?.cancel();
    return super.close();
  }
}
