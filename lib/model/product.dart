class Product {
  String productId;
  String categoryId;
  String categoryCode;
  double price;
  String brand;

  Product({
    required this.productId,
    required this.categoryId,
    required this.categoryCode,
    required this.brand,
    required this.price,
  });

  factory Product.fromRow(List<dynamic> row) {
    return Product(
        productId: row[0].toString(),
        categoryId: row[1].toString(),
        categoryCode: row[2].toString(),
        brand: row[3].toString(),
        price: double.tryParse(row[4].toString()) ?? 0.0);
  }

  @override
  String toString() {
    return 'Product{productId: $productId, categoryId: $categoryId, categoryCode: $categoryCode, price: $price, brand: $brand}';
  }
}
