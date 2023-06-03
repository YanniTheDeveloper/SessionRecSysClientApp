import 'package:basic_utils/basic_utils.dart';
import 'package:csv/csv.dart';
import 'package:ecommerce_ai/controller/event.dart';
import 'package:ecommerce_ai/model/event.dart';
import 'package:ecommerce_ai/screens/details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../const/images.dart';
import 'cart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<List<dynamic>> _csvData = [];
  List<List<dynamic>> _filteredCsvData = [];

  Future<void> readCSVFile() async {
    final String csvData = await rootBundle.loadString('assets/a.csv');
    final List<List<dynamic>> rowsAsListOfValues =
        const CsvToListConverter().convert(csvData);

    // Define a set to store unique category codes
    Set<String> uniqueCategoryCodes = Set<String>();

    // Iterate through the rows
    for (int i = 0; i < rowsAsListOfValues.length; i++) {
      List<dynamic> row = rowsAsListOfValues[i];
      String categoryCode = row[2]
          .toString(); // Assuming category_code is in the third column (index 2)

      // Check if the category code is already present
      if (!uniqueCategoryCodes.contains(categoryCode)) {
        // Add the row to the non-redundant data
        _filteredCsvData.add(row);

        // Add the category code to the set
        uniqueCategoryCodes.add(categoryCode);
      }
    }

    _csvData = rowsAsListOfValues;
    _filteredCsvData.removeAt(0);
    setState(() {});
  }

  @override
  void initState() {
    readCSVFile();
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
          child: _filteredCsvData.isEmpty
              ? const Center(child: Text("Loading"))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      GridView.builder(
                        shrinkWrap: true,
                        itemCount: _filteredCsvData.length,
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
                                      productId:
                                          _filteredCsvData[index][0].toString(),
                                      categoryId:
                                          _filteredCsvData[index][1].toString(),
                                      categoryCode:
                                          _filteredCsvData[index][2].toString(),
                                      price: _filteredCsvData[index][4],
                                      brand: _filteredCsvData[index][3]
                                          .toString());
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DetailsScreen(
                                      selectedImage: images(
                                          _filteredCsvData[index][2]
                                              .toString()),
                                      catID:
                                          _filteredCsvData[index][2].toString(),
                                      brand:
                                          _filteredCsvData[index][3].toString(),
                                      pID:
                                          _filteredCsvData[index][0].toString(),
                                      cID:
                                          _filteredCsvData[index][1].toString(),
                                      price: _filteredCsvData[index][4],
                                      csvData: _filteredCsvData)));
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
                                    images(_filteredCsvData[index][2]
                                                .toString()) ==
                                            ""
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
                                                          _filteredCsvData[
                                                                  index][2]
                                                              .toString())),
                                                      fit: BoxFit.cover)),
                                            ),
                                          ),
                                    const SizedBox(height: 5),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: Text(
                                        StringUtils.capitalize(
                                            _filteredCsvData[index][2]
                                                .toString()
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
                                            "\$ ${_filteredCsvData[index][4].toString()}",
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
