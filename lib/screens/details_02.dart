import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';

import '../const/images.dart';
import 'details.dart';

class DetailsTwo extends StatelessWidget {
  String selectedImage;
  String title;
  String pID;
  String cID;
  List<List<dynamic>> related;

  DetailsTwo(
      {required this.selectedImage,
      required this.title,
      required this.pID,
      required this.cID,
      required this.related});
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(title),
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              selectedImage == ""
                  ? SizedBox(
                      height: screenSize.height * 0.4,
                      child: const Center(child: Text("No Image")),
                    )
                  : Container(
                      height: screenSize.height * 0.4,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(selectedImage),
                              fit: BoxFit.cover)),
                    ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Text(
                  title,
                  maxLines: 2,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
              const SizedBox(height: 10),
              csvDataView(title: "Product ID: ", data: pID),
              const SizedBox(height: 10),
              csvDataView(title: "Category ID: ", data: cID),
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  "Related Products",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 15),
              GridView.builder(
                shrinkWrap: true,
                itemCount: related.length,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  childAspectRatio: 0.79,
                  maxCrossAxisExtent: screenSize.width * 0.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetailsTwo(
                            selectedImage: images(related[index][2].toString()),
                            title: StringUtils.capitalize(
                                related[index][2]
                                    .toString()
                                    .replaceAll(".", " "),
                                allWords: true),
                            pID: related[index][0].toString(),
                            cID: related[index][1].toString(),
                            related: related))),
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
                            images(related[index][2].toString()) == ""
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
                                                  related[index][2]
                                                      .toString())),
                                              fit: BoxFit.cover)),
                                    ),
                                  ),
                            const SizedBox(height: 5),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Text(
                                StringUtils.capitalize(
                                    related[index][2]
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
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "\$ ${related[index][4].toString()}",
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
                                            BorderRadius.circular(5.0)),
                                    child: const Text(
                                      " 3.0",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
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
            ],
          ),
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
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
    );
  }
}
