
import 'package:basic_utils/basic_utils.dart';
import 'package:ecommerce_ai/controller/event.dart';
import 'package:ecommerce_ai/data/csv_db.dart';
import 'package:ecommerce_ai/model/product.dart';
import 'package:ecommerce_ai/screens/details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../const/images.dart';
import 'cart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> products = List.empty(growable: true);

  Future<void> loadProducts() async {
    products = CsvDatabase.instance.getRandomProducts(50);
    print("Size: ${products.length}");
    setState(() {});
  }

  @override
  void initState() {
    loadProducts();
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
        title: const Text("Products"),
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
          child: products.isEmpty
              ? const Center(child: Text("Loading"))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      GridView.builder(
                        shrinkWrap: true,
                        itemCount: products.length,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.only(bottom: 60),
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          childAspectRatio: 0.79,
                          maxCrossAxisExtent: screenSize.width * 0.5,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 0,
                        ),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Provider.of<EventProvider>(context, listen: false)
                                  .viewProduct(
                                productId: products[index].productId,
                                categoryId: products[index].categoryId,
                                categoryCode: products[index].categoryCode,
                                price: products[index].price,
                                brand: products[index].brand,
                              );
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DetailsScreen(
                                      selectedImage:
                                          images(products[index].categoryCode),
                                      catID: products[index].categoryCode,
                                      brand: products[index].brand,
                                      pID: products[index].productId,
                                      cID: products[index].categoryId,
                                      price: products[index].price,
                                      csvData: products)));
                              EventProvider().extractEventData();
                            },
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
                                    images(products[index].categoryCode) == ""
                                        ? const AspectRatio(
                                            aspectRatio: 1.175,
                                            child:
                                                Center(child: Text("No Image")),
                                          )
                                        : AspectRatio(
                                            aspectRatio: 1.175,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10.0)),
                                                  image: DecorationImage(
                                                      image: AssetImage(images(
                                                          products[index]
                                                              .categoryCode)),
                                                      fit: BoxFit.cover)),
                                            ),
                                          ),
                                    const SizedBox(height: 5),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: Text(
                                        StringUtils.capitalize(
                                            products[index]
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
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "\$ ${products[index].categoryCode}",
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
                    ],
                  ),
                )),
    );
  }
}
