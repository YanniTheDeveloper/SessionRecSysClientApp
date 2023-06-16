import 'package:csv/csv.dart';
import 'package:ecommerce_ai/data/api.dart';
import 'package:ecommerce_ai/model/product.dart';
import 'package:flutter/services.dart';

// make this class singleton with instance
class CsvDatabase {
  CsvDatabase._privateConstructor();
  static final CsvDatabase instance = CsvDatabase._privateConstructor();

  List<Product> _allProducts = [];

  Future<void> init() async {
    final String csvData = await rootBundle.loadString('assets/a.csv');

    final rows = const CsvToListConverter().convert(csvData, eol: "\n");

    print("Rows Size: ${rows.length}, of row sub list size: ${rows[0].length}");
    _allProducts = await Future.value(
        rows.skip(1).map((row) => Product.fromRow(row)).toList());
    print("All Products Size: ${_allProducts.length}");
  }

  // get random products
  List<Product> getRandomProducts(int count) {
    _allProducts.shuffle();
    return _allProducts.take(count).toList();
  }

  // search product by category
  List<Product> searchProduct(String text) {
    return _allProducts
        .where((product) =>
            product.categoryCode.toLowerCase().contains(text.toLowerCase()))
        .toList();
  }

  // get product by brand
  List<Product> getProductByBrand(String brand) {
    return _allProducts
        .where((product) => product.brand.toLowerCase() == brand.toLowerCase())
        .toList();
  }

  /////////////////////////////////////////
  ///
  ///
  ///  this is what i use for api and return to the flutter page

  List<Product> getProductFromApi(List<dynamic> ids) {
    List<Product> matchProducts = [];
    for (int i = 0; i < _allProducts.length; i++) {
      for (int j = 0; j < ids.length; j++) {
        if (_allProducts[i].productId == ids[j].toString()) {
          matchProducts.add(_allProducts[i]);
        }
      }
    }
    //print(matchProducts);
    return matchProducts;
  }

  /////////////////////////////////////////////
  // get product by id
  Product getProductById(String id) {
    return _allProducts.firstWhere((product) => product.productId == id);
  }

  // get product by category
  List<Product> getProductByCategory(String category) {
    return _allProducts
        .where((product) =>
            product.categoryCode.toLowerCase() == category.toLowerCase())
        .toList();
  }

  // get product by price range
  List<Product> getProductByPriceRange(double start, double end) {
    return _allProducts
        .where((product) => product.price >= start && product.price <= end)
        .toList();
  }
}
