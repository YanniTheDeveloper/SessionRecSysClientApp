import 'package:ecommerce_ai/data/api.dart';
import 'package:ecommerce_ai/model/event.dart';
import 'package:flutter/foundation.dart';

class EventProvider with ChangeNotifier {
  final List<Event> _events = [];
  List<Event> get event => [..._events];
  final List<Event> _cartItems = [];
  final ApiProvider apiProvider = ApiProvider();

  List<Event> get cartItem => [..._cartItems];

  int get cartCount {
    return _cartItems.length;
  }

  clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  Future<dynamic> extractEventData() async {
    // List<Map<String, dynamic>> eventDataList = [];
    Map<String, dynamic> eventData = {};

    for (Event eve in _events) {
      String productId = eve.productId;
      String categoryId = eve.categoryId;
      String categoryCode = eve.categoryCode;
      String brand = eve.brand;
      EventType eventType = eve.eventType;
      DateTime eventTime = eve.eventTime;
      double price = eve.price;

      eventData = {
        'product_id': productId,
        'category_id': categoryId,
        'category_code': categoryCode,
        'brand': brand,
        'event_type': eventType.toString(),
        'event_time': eventTime.toString(),
        'price': price,
      };
      // eventDataList.add(eventData);
      // eventDataList.add(eventData);

      // ApiProvider().sendDataToServer(eventData);
    }
    // print("something");
    // print(eventData);
    // print(eventDataList);
    // ApiProvider().sendDataToServer(eventData);
    // dynamic responseData = ApiProvider().sendDataToServer(eventData);
    dynamic responseData = await ApiProvider().sendDataToServer(eventData);
    // print(responseData);
    return responseData;
  }

  void viewProduct({
    required String productId,
    required String categoryId,
    required String categoryCode,
    required double price,
    required String brand,
  }) {
    _events.add(
      Event(
        productId: productId,
        categoryId: categoryId,
        categoryCode: categoryCode,
        brand: brand,
        eventType: EventType.view,
        eventTime: DateTime.now(),
        price: price,
      ),
    );

    extractEventData();

    notifyListeners();
  }

  void purchaseProduct(
      {required String productId,
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
    extractEventData();
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
    // print("this isssssssssssss ${event.length}");

    notifyListeners();
    _events.add(Event(
        productId: productId,
        categoryId: categoryId,
        categoryCode: categoryCode,
        brand: brand,
        eventType: EventType.remove_from_cart,
        eventTime: DateTime.now(),
        price: price));
    EventProvider().extractEventData();
    // print("hhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
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
        price: price,
      ),
    ]);
    _events.add(Event(
        productId: productId,
        categoryId: categoryId,
        categoryCode: categoryCode,
        brand: brand,
        eventType: EventType.cart,
        eventTime: DateTime.now(),
        price: price));
    extractEventData();
    notifyListeners();
  }
}
