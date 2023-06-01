import 'dart:math';

import 'package:csv/csv.dart';
import 'package:ecommerce_ai/const/images.dart';
import 'package:ecommerce_ai/screens/details_02.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:basic_utils/basic_utils.dart' as st;

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int selectedIndex = 0;
  List<List<dynamic>> _csvData = [];
  final List<List<dynamic>> _related = [];
  Future<void> readCSVFile() async {
    final String csvData = await rootBundle.loadString('assets/a.csv');
    final List<List<dynamic>> rowsAsListOfValues =
        const CsvToListConverter().convert(csvData);
    _csvData = rowsAsListOfValues;
    setState(() {});

    getRelated();
  }

  getRelated() {
    for (int i = 0; i < 40000; i++) {
      if (_csvData[selectedIndex][3].toString() == _csvData[i][3].toString()) {
        bool isAlreadyAdded = false;
        for (var relatedData in _related) {
          if (_csvData[i][2].toString() == relatedData[2].toString()) {
            isAlreadyAdded = true;
            break;
          }
        }
        if (!isAlreadyAdded) {
          _related.add(_csvData[i]);
        }
      }
    }
  }

  @override
  void initState() {
    readCSVFile();
    generateRandomNumber();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: _csvData.isEmpty
            ? const Center(child: Text("Loading"))
            : Stack(children: [
                SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child:
                              images(_csvData[selectedIndex][2].toString()) ==
                                      ""
                                  ? SizedBox(
                                      height: screenSize.height * 0.4,
                                      child:
                                          const Center(child: Text("No Image")),
                                    )
                                  : Container(
                                      height: screenSize.height * 0.4,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(images(
                                                  _csvData[selectedIndex][2]
                                                      .toString())),
                                              fit: BoxFit.cover)),
                                    ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Text(
                            st.StringUtils.capitalize(
                                _csvData[selectedIndex][2]
                                    .toString()
                                    .replaceAll(".", " "),
                                allWords: true),
                            maxLines: 2,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        const SizedBox(height: 10),
                        csvDataView(
                            title: "Product ID: ",
                            data: _csvData[selectedIndex][0].toString()),
                        const SizedBox(height: 10),
                        csvDataView(
                            title: "Category ID: ",
                            data: _csvData[selectedIndex][1].toString()),
                        const SizedBox(height: 30),
                        const Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Text(
                            "Related Products",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(height: 15),
                        GridView.builder(
                          shrinkWrap: true,
                          itemCount: _related.length,
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
                            return GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => DetailsTwo(
                                          selectedImage: images(
                                              _related[index][2].toString()),
                                          title: st.StringUtils.capitalize(
                                              _csvData[selectedIndex][2]
                                                  .toString()
                                                  .replaceAll(".", " "),
                                              allWords: true),
                                          pID: _related[index][0].toString(),
                                          cID: _related[index][1].toString(),
                                          related: _related))),
                              child: Card(
                                elevation: 0.5,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      images(_related[index][2].toString()) ==
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
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10.0)),
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            images(_related[
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
                                          st.StringUtils.capitalize(
                                              _related[index][2]
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
                                              "\$ ${_related[index][4].toString()}",
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Container(
                                              height: 22,
                                              width: 50,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: Colors.indigo,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              child: const Text(
                                                " 3.0",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            )
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
                          GestureDetector(
                            onTap: () {
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
                          )
                        ],
                      ),
                    ))
              ]),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 46.0),
        child: FloatingActionButton(
            child: const Icon(Icons.sync),
            onPressed: () async {
              _csvData.clear();
              setState(() {});
              _related.clear();
              Future.delayed(const Duration(milliseconds: 200)).then((_) {
                readCSVFile();
                generateRandomNumber();
              });
            }),
      ),
    );
  }

  void generateRandomNumber() {
    selectedIndex = Random.secure().nextInt(40001);
    setState(() {});
  }
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
