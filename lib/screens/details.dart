import 'package:basic_utils/basic_utils.dart';
import 'package:ecommerce_ai/const/images.dart';
import 'package:ecommerce_ai/model/product.dart';
import 'package:ecommerce_ai/screens/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/event.dart';

class DetailsScreen extends StatefulWidget {
  String selectedImage;
  String catID;
  String pID;
  String cID;
  double price;
  String brand;
  List<Product> csvData;

  DetailsScreen(
      {super.key,
      required this.selectedImage,
      required this.catID,
      required this.pID,
      required this.cID,
      required this.price,
      required this.brand,
      required this.csvData});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final List<Product> _related = [];
  getRelated() {
    for (int i = 0; i < 10; i++) {
      _related.add(widget.csvData[i]);

      // if (widget.brand.toString() == widget.csvData[i][3].toString()) {
      //   bool isAlreadyAdded = false;
      //   for (var relatedData in _related) {
      //     if (widget.csvData[i][2].toString() == relatedData[2].toString()) {
      //       isAlreadyAdded = true;
      //       break;
      //     }
      //   }
      //   if (!isAlreadyAdded) {
      //     if (widget.pID.toString() != widget.csvData[i][0].toString()) {
      //       _related.add(widget.csvData[i]);
      //     }
      //   }
      // }
    }

    setState(() {});
  }

  @override
  void initState() {
    getRelated();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(
          StringUtils.capitalize(widget.catID.toString().replaceAll(".", " "),
              allWords: true),
        ),
        actions: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CartScreen())),
            child: Stack(children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(right: 15.0),
                  child: Icon(
                    Icons.add_shopping_cart_rounded,
                    color: Colors.black,
                  ),
                ),
              ),
              Positioned(
                  top: 7,
                  right: 7.0,
                  child: CartCountWidget(
                      cartCounterText: Provider.of<EventProvider>(context)
                          .cartCount
                          .toString()))
            ]),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(children: [
          SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              widget.selectedImage == ""
                  ? SizedBox(
                      height: screenSize.height * 0.4,
                      child: const Center(child: Text("No Image")),
                    )
                  : Container(
                      height: screenSize.height * 0.4,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(widget.selectedImage),
                              fit: BoxFit.cover)),
                    ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Text(
                  StringUtils.capitalize(
                      widget.catID.toString().replaceAll(".", " "),
                      allWords: true),
                  maxLines: 2,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
              const SizedBox(height: 10),
              csvDataView(title: "Product ID: ", data: widget.pID),
              const SizedBox(height: 10),
              csvDataView(title: "Category ID: ", data: widget.cID),
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  "Related Products",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 15),
              // _related.isEmpty
              //     ? Container(
              //         height: screenSize.height * 0.3,
              //         child: Text("No Related"),
              //       )
              //     :
              GridView.builder(
                shrinkWrap: true,
                itemCount: _related.length,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 60),
                scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    childAspectRatio: 0.79,
                    maxCrossAxisExtent: screenSize.width * 0.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetailsScreen(
                            selectedImage: images(_related[index].categoryCode),
                            catID: StringUtils.capitalize(
                                _related[index]
                                    .categoryCode
                                    .replaceAll(".", " "),
                                allWords: true),
                            brand: _related[index].brand,
                            pID: _related[index].productId,
                            price: _related[index].price,
                            cID: _related[index].categoryId,
                            csvData: _related))),
                    child: Card(
                      elevation: 0.5,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            images(_related[index].categoryCode) == ""
                                ? const AspectRatio(
                                    aspectRatio: 1.175,
                                    child: Center(child: Text("No Image")))
                                : AspectRatio(
                                    aspectRatio: 1.175,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10.0)),
                                          image: DecorationImage(
                                              image: AssetImage(images(
                                                  _related[index]
                                                      .categoryCode)),
                                              fit: BoxFit.cover)),
                                    ),
                                  ),
                            const SizedBox(height: 5),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Text(
                                StringUtils.capitalize(
                                    _related[index]
                                        .categoryCode
                                        .replaceAll(".", " "),
                                    allWords: true),
                                maxLines: 2,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "\$ ${_related[index].categoryCode}",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  // Container(
                                  //   height: 22,
                                  //   width: 50,
                                  //   alignment: Alignment.center,
                                  //   decoration: BoxDecoration(
                                  //       color: Colors.indigo,
                                  //       borderRadius:
                                  //           BorderRadius.circular(5.0)),
                                  //   child: const Text(
                                  //     " 3.0",
                                  //     style: TextStyle(
                                  //         color: Colors.white,
                                  //         fontSize: 13,
                                  //         fontWeight: FontWeight.w600),
                                  //   ),
                                  // )
                                ],
                              ),
                            )
                          ]),
                    ),
                  );
                },
              ),
            ]),
          ),
          Positioned(
              bottom: 0,
              child: Container(
                height: 54,
                width: screenSize.width,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.calendar_view_day),
                    const SizedBox(width: 20),
                    const Icon(Icons.favorite_outline),
                    const SizedBox(width: 20),
                    const Icon(Icons.comment_outlined),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        Provider.of<EventProvider>(context, listen: false)
                            .addToCart(
                                productId: widget.pID,
                                categoryId: widget.cID,
                                categoryCode: widget.catID,
                                price: widget.price,
                                brand: widget.brand);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                duration: Duration(seconds: 1),
                                backgroundColor: Colors.green,
                                content: Text("Added To Cart!")));
                      },
                      child: Container(
                        height: 56,
                        width: screenSize.width * 0.3,
                        alignment: Alignment.center,
                        color: Colors.red,
                        child: const Text(
                          "Add To Cart",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Provider.of<EventProvider>(context, listen: false)
                            .purchaseProduct(
                                productId: widget.pID,
                                categoryId: widget.cID,
                                categoryCode: widget.catID,
                                price: widget.price,
                                brand: widget.brand);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                duration: Duration(seconds: 1),
                                backgroundColor: Colors.green,
                                content: Text("Success")));
                      },
                      child: Container(
                        height: 56,
                        width: screenSize.width * 0.3,
                        alignment: Alignment.center,
                        color: Colors.pink.shade100,
                        child: const Text(
                          "Buy Now",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ))
        ]),
      ),
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(bottom: 46.0),
      //   child: FloatingActionButton(
      //       child: const Icon(Icons.sync),
      //       onPressed: () async {
      //         _csvData.clear();
      //         setState(() {});
      //         _related.clear();
      //         Future.delayed(const Duration(milliseconds: 200)).then((_) {
      //           readCSVFile();
      //           generateRandomNumber();
      //         });
      //       }),
      // ),
    );
  }

  // void generateRandomNumber() {
  //   selectedIndex = Random.secure().nextInt(40001);
  //   setState(() {});
  // }
}

Widget csvDataView({required String title, required String data}) {
  return Padding(
    padding: const EdgeInsets.only(left: 15.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
        ),
        const SizedBox(width: 10),
        Text(
          data,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
      ],
    ),
  );
}

class CartCountWidget extends StatelessWidget {
  String cartCounterText;
  CartCountWidget({required this.cartCounterText});

  @override
  Widget build(BuildContext context) {
    return cartCounterText == "0"
        ? Container()
        : Container(
            alignment: Alignment.center,
            height: 20,
            width: 20,
            decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white)),
            child: Text(
              cartCounterText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          );
  }
}
