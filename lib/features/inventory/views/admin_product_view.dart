import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/inventory_bloc.dart';
import '../models/product_model.dart';

class AdminProductView extends StatelessWidget {
  const AdminProductView({required this.categoryId, super.key});

  final String categoryId;

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: BlocBuilder<InventoryBloc, InventoryState>(
        builder: (context, state) {
          if (state is InventoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductsLoaded) {
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('SKU: ${product.skuCode} • Stock: ${product.currentStock}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showProductDialog(context, product: product),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _confirmDeleteProduct(context, product.id),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          if (state is InventoryError) {
            return Center(child: Text(state.message));
          }

          return const Center(child: Text('No products yet'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showProductDialog(BuildContext context, {ProductModel? product}) {
    final nameController = TextEditingController(text: product?.name ?? '');
    final skuController = TextEditingController(text: product?.skuCode ?? '');
    final stockController = TextEditingController(
      text: product?.currentStock.toString() ?? '0',
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(product == null ? 'Add Product' : 'Edit Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Product name'),
              ),
              TextField(
                controller: skuController,
                decoration: const InputDecoration(labelText: 'SKU code'),
              ),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Current stock'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final sku = skuController.text.trim();
                final stock = int.tryParse(stockController.text) ?? 0;
                if (name.isEmpty || sku.isEmpty) return;

                if (product == null) {
                  context.read<InventoryBloc>().add(
                    AddProduct(
                      ProductModel(
                        id: '',
                        categoryId: categoryId,
                        name: name,
                        skuCode: sku,
                        currentStock: stock,
                      ),
                    ),
                  );
                } else {
                  context.read<InventoryBloc>().add(
                    UpdateProduct(
                      ProductModel(
                        id: product.id,
                        categoryId: categoryId,
                        name: name,
                        skuCode: sku,
                        currentStock: stock,
                      ),
                    ),
                  );
                }

                Navigator.of(dialogContext).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteProduct(BuildContext context, String productId) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: const Text('Delete this product permanently?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<InventoryBloc>().add(DeleteProduct(categoryId, productId));
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
