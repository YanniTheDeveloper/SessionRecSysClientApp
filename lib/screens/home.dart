import 'package:basic_utils/basic_utils.dart';
import 'package:ecommerce_ai/controller/event.dart';
import 'package:ecommerce_ai/data/api.dart';
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

// class _HomePageState extends State<HomePage> {

// }

class _HomePageState extends State<HomePage> {
  List<Product> products_from_api = List.empty(growable: true);
  bool _isLoading = false;

  EventProvider eventProvider = EventProvider();
//////////////////////////////////////////////////////////
  ///
  bool _isDataLoaded = false;

  Future<void> loadProductsApi() async {
    // if (_isLoading) return;
    if (_isLoading || _isDataLoaded) return;

    setState(() {
      _isLoading = true;
    });

    // Id that comes from an API
    final response = listo;
    // print("=========== ${response}");

    products_from_api = CsvDatabase.instance.getProductFromApi(response);
    // print(products_from_api);

    // print("Size: ${products_from_api.length}");

    // setState(() {});
    setState(() {
      products.addAll(products_from_api);
      // products.remove(products_from_api);
      _isDataLoaded = true;
      _isLoading = false;
    });
  }

  ///////////////////////////////////////////////////////////////////

  List<Product> products = List.empty(growable: true);

  Future<void> loadProducts() async {
    products = CsvDatabase.instance.getRandomProducts(20);
    // print("Size: ${products.length}");
    setState(() {});
  }

  @override
  void initState() {
    loadProducts();
    // lId();
    // loadProductsApi();
    super.initState();
  }

  String? _dropDownValue;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    // List<dynamic> _aiModels = [
    //   'ALBERT',
    //   'LSTM',
    //   'GRU',
    // ];

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

            DropdownButton<String>(
              value: _dropDownValue,
              icon: const Icon(Icons.bubble_chart_outlined),
              items: <String>['ALBERT', 'LSTM', 'GRU'].map((String val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(
                    val,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (dynamic newValue) {
                setState(() {
                  _dropDownValue = newValue;
                });
              },
            )

            //
          ],
        ),
        body: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!_isLoading &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
              // Fetch new data when the user reaches the bottom.
              loadProductsApi();
              return true;
            }
            return false;
          },
          child: SafeArea(
              child: products.isEmpty
                  ? const Center(child: Text("Loading"))
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          GridView.builder(
                            shrinkWrap: true,
                            itemCount: products.length + 1,
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            padding: const EdgeInsets.only(bottom: 60),
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              childAspectRatio: 0.79,
                              maxCrossAxisExtent: screenSize.width * 0.5,
                              crossAxisSpacing: 0,
                              mainAxisSpacing: 0,
                            ),
                            itemBuilder: (context, index) {
                              if (index == products.length) {
                                if (_isLoading) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  // When there's no more data to load, show a placeholder widget.
                                  return Container(
                                    color: Colors
                                        .grey, // Add your desired color or decoration.
                                  );
                                }
                              }
                              return GestureDetector(
                                onTap: () {
                                  Provider.of<EventProvider>(context,
                                          listen: false)
                                      .viewProduct(
                                    productId: products[index].productId,
                                    categoryId: products[index].categoryId,
                                    categoryCode: products[index].categoryCode,
                                    price: products[index].price,
                                    brand: products[index].brand,
                                  );

                                  // EventProvider().event.toString();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => DetailsScreen(
                                          selectedImage: images(
                                              products[index].categoryCode),
                                          catID: products[index].categoryCode,
                                          brand: products[index].brand,
                                          pID: products[index].productId,
                                          cID: products[index].categoryId,
                                          price: products[index].price,
                                          csvData: products)));
                                  EventProvider().extractEventData();

                                  //--- ***** ---///
                                  setState(() {
                                    _isDataLoaded = false;
                                  });
                                },
                                child: Card(
                                  elevation: 0.5,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        images(products[index].categoryCode) ==
                                                ""
                                            ? const AspectRatio(
                                                aspectRatio: 1.175,
                                                child: Center(
                                                    child: Text("No Image")),
                                              )
                                            : AspectRatio(
                                                aspectRatio: 1.175,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                              topLeft:
                                                                  Radius
                                                                      .circular(
                                                                          10),
                                                              topRight: Radius
                                                                  .circular(
                                                                      10.0)),
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              images(products[
                                                                      index]
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
                                                overflow:
                                                    TextOverflow.ellipsis),
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
        ));
  }
}
