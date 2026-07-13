import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  const ProductModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.skuCode,
    required this.currentStock,
  });

  final String id;
  final String categoryId;
  final String name;
  final String skuCode;
  final int currentStock;

  factory ProductModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ProductModel(
      id: documentId,
      categoryId: map['categoryId']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      skuCode: map['skuCode']?.toString() ?? '',
      currentStock: map['currentStock'] is int
          ? map['currentStock'] as int
          : int.tryParse(map['currentStock']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'name': name,
      'skuCode': skuCode,
      'currentStock': currentStock,
    };
  }

  @override
  List<Object?> get props => [id, categoryId, name, skuCode, currentStock];
}
