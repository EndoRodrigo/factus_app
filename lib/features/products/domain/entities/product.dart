class Product {
  final int? id;
  final String name;
  final String code;
  final double price;
  final double taxRate;
  final String? description;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Product({
    this.id,
    required this.name,
    required this.code,
    required this.price,
    required this.taxRate,
    this.description,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });
}