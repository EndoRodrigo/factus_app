class Product {
  final int? id;
  final String name;
  final String code;
  final double price;
  final double taxRate;
  final String? description;
  final String unitMeasureCode;
  final String standardCode;
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
    this.unitMeasureCode = '94',
    this.standardCode = '999',
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });
}