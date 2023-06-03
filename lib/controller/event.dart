import 'package:ecommerce_ai/model/event.dart';
import 'package:flutter/foundation.dart';

class EventProvider with ChangeNotifier {
  List<Event> _events = [];
  List<Event> get event => [..._events];
  List _cartItems = [];

  List get cartItem => [...cartItem];

  int get cartCount {
    return _cartItems.length;
  }

  void viewProduct(
      {
      required String productId,
      required String categoryId,
      required String categoryCode,
      required double price,
      required String brand}) {
    _events.add(Event(
        productId: productId,
        categoryId: categoryId,
        categoryCode: categoryCode,
        brand: brand,
        eventType: EventType.view,
        eventTime: DateTime.now(),
        price: price));
    notifyListeners();
  }

  void purchaseProduct(
      {
      required String productId,
      required String categoryId,
      required String categoryCode,
      required double price,
      required String brand}) {
    _events.add(Event(
        productId: productId,
        categoryId: categoryId,
        categoryCode: categoryCode,
        brand: brand,
        eventType: EventType.purchase,
        eventTime: DateTime.now(),
        price: price));
    notifyListeners();
  }

  void removeProduct(
      {required int index,
      required String productId,
      required String categoryId,
      required String categoryCode,
      required double price,
      required String brand}) {
    _cartItems.removeAt(index);
    notifyListeners();
    _events.add(Event(
        productId: productId,
        categoryId: categoryId,
        categoryCode: categoryCode,
        brand: brand,
        eventType: EventType.cart,
        eventTime: DateTime.now(),
        price: price));
  }

  addToCart(
      {required String productId,
      required String categoryId,
      required String categoryCode,
      required double price,
      required String brand}) {
    _cartItems.addAll([
      Event(
          productId: productId,
          categoryId: categoryId,
          categoryCode: categoryCode,
          brand: brand,
          eventType: EventType.cart,
          eventTime: DateTime.now(),
          price: price),
    ]);
    _events.add(Event(
        productId: productId,
        categoryId: categoryId,
        categoryCode: categoryCode,
        brand: brand,
        eventType: EventType.cart,
        eventTime: DateTime.now(),
        price: price));
    notifyListeners();
  }
}
