import '../../../../core/database/app_database.dart';
import '../../domain/entities/product.dart';

class ProductMapper {
  static Product toEntity(ProductTableData data) {
    return Product(
      id: data.id,
      name: data.name,
      code: data.code,
      price: data.price,
      taxRate: data.taxRate,
      description: data.description,
      unitMeasureCode: data.unitMeasureCode,
      standardCode: data.standardCode,
      isActive: data.isActive,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }
}
