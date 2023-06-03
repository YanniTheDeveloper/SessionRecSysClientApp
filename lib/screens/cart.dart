import 'dart:ffi';

import 'package:basic_utils/basic_utils.dart' as st;
import 'package:ecommerce_ai/controller/event.dart';
import 'package:ecommerce_ai/model/event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.5,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: const Text("Cart")),
      body: Consumer<EventProvider>(
        builder: (context, value, _) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: Provider.of<EventProvider>(context, listen: false)
                .cartItem
                .length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(
                    st.StringUtils.capitalize(
                        value.cartItem[index].categoryCode
                            .toString()
                            .replaceAll(".", " "),
                        allWords: true),
                  ),
                  trailing: GestureDetector(
                      onTap: () {
                        value.removeProduct(
                            index: index,
                            productId: value.cartItem[index].productId,
                            categoryId: value.cartItem[index].categoryId,
                            categoryCode: value.cartItem[index].categoryCode,
                            price: value.cartItem[index].price,
                            brand: value.cartItem[index].brand);
                      },
                      child: const Icon(Icons.delete, color: Colors.red)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
