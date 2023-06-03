class Event {
  String productId;
  String categoryId;
  String categoryCode;
  EventType eventType;
  double price;
  String brand;
  DateTime eventTime;
  String userId;
  String userSession;

  Event(
      {required this.productId,
      required this.categoryId,
      required this.categoryCode,
      required this.brand,
      required this.eventTime,
      required this.eventType,
      required this.price,
      this.userId = "1234567890",
      this.userSession = "0987654321"});
}

enum EventType { view, cart, remove_from_cart, purchase }
