import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category_model.dart';
import '../models/product_model.dart';

class InventoryRepository {
  InventoryRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Stream<List<CategoryModel>> getCategoriesStream() {
    return _firestore.collection('categories').orderBy('name').snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => CategoryModel.fromMap(doc.data(), doc.id))
          .toList(),
    );
  }

  Stream<List<ProductModel>> getProductsStream(String categoryId) {
    return _firestore
        .collection('categories')
        .doc(categoryId)
        .collection('products')
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> addCategory(CategoryModel category) async {
    await _firestore.collection('categories').add(category.toMap());
  }

  Future<void> updateCategory(CategoryModel category) async {
    await _firestore.collection('categories').doc(category.id).update(category.toMap());
  }

  Future<void> deleteCategory(String categoryId) async {
    final products = await _firestore
        .collection('categories')
        .doc(categoryId)
        .collection('products')
        .get();

    for (final product in products.docs) {
      await product.reference.delete();
    }

    await _firestore.collection('categories').doc(categoryId).delete();
  }

  Future<void> addProduct(ProductModel product) async {
    await _firestore
        .collection('categories')
        .doc(product.categoryId)
        .collection('products')
        .add(product.toMap());
  }

  Future<void> updateProduct(ProductModel product) async {
    await _firestore
        .collection('categories')
        .doc(product.categoryId)
        .collection('products')
        .doc(product.id)
        .update(product.toMap());
  }

  Future<void> deleteProduct(String categoryId, String productId) async {
    await _firestore
        .collection('categories')
        .doc(categoryId)
        .collection('products')
        .doc(productId)
        .delete();
  }
}
