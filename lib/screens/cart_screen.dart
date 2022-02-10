import 'dart:math';

import 'package:coffee_flutter/components/appbar.dart';
import 'package:coffee_flutter/components/button.dart';
import 'package:coffee_flutter/store/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:provider/src/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List cart = context.watch<Cart>().cart;
    int totalPrice() {
      int price = 0;
      cart.fold(0, (acc, cur) {
        price = cur['price'] * cur['count'];
      });
      return price;
    }

    void checkout() {
      context.read<Cart>().clearCart();
      Get.back();
    }

    return Scaffold(
        body: Column(
      children: [
        Appbar(
          title: 'Your order',
        ),
        Container(
          height: MediaQuery.of(context).size.height / 1.57,
          padding: const EdgeInsets.fromLTRB(27.0, 0, 27.0, 40.0),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: cart.length,
              itemBuilder: (context, i) {
                return CartProduct(
                  id: cart[i]['id'],
                  name: cart[i]['name'],
                  size: cart[i]['size'],
                  price: cart[i]['price'],
                  image: cart[i]['image'],
                  count: cart[i]['count'] ?? 1,
                  fromWhat: 'Milk and cassette',
                );
              }),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.fromLTRB(27.0, 0, 27.0, 40.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
              ),
              Text(
                '${totalPrice()} ₽',
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 28),
              )
            ],
          ),
        ),
        FirmButton(onPressed: checkout),
      ],
    ));
  }
}

class CartProduct extends StatelessWidget {
  String id;
  String name;
  String size;
  int price;
  int count;
  String fromWhat;
  String image;

  CartProduct(
      {Key? key,
      required this.id,
      required this.name,
      required this.image,
      required this.fromWhat,
      required this.size,
      required this.price,
      required this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color getSizeColor() {
      switch (size) {
        case 'tall':
          return const Color(0xFF54B2CF);
        case 'short':
          return const Color(0xFF3CD2D2);
        case 'grande':
          return const Color(0xFFB88AF8);
        default:
          return const Color(0xFF54B2CF);
      }
    }

    return Container(
      height: 88,
      width: 327,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(16.0),
              ),
            ),
            height: 88,
            width: 88,
            child: Image.network(
              image,
              height: 88,
              width: 88,
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 15),
                ),
                Text(
                  fromWhat,
                  style: const TextStyle(
                      color: Color(0xFF8E8E93),
                      fontWeight: FontWeight.w300,
                      fontSize: 13),
                ),
                const SizedBox(
                  height: 4,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: getSizeColor(),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(48.0),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(8, 1, 8, 1),
                  child: Text(
                    size.toUpperCase(),
                    style: TextStyle(
                        color: Theme.of(context).textTheme.caption?.color,
                        fontSize: 11,
                        fontWeight: FontWeight.w300),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  '${price} ₽',
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                )
              ],
            ),
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                borderRadius: BorderRadius.all(Radius.circular(100 / 2)),
                onTap: () {
                  context.read<Cart>().increment(id);
                },
                child: Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Get.isDarkMode
                              ? Color(0xFF353341)
                              : Color(0xFFEBEBEB),
                          width: 1)),
                  child: const Icon(
                    Icons.add,
                    size: 18,
                  ),
                ),
              ),
              Text(
                context
                    .watch<Cart>()
                    .cart[context
                        .watch<Cart>()
                        .cart
                        .indexWhere((element) => element['id'] == id)]['count']
                    .toString(),
                style: const TextStyle(),
              ),
              InkWell(
                onTap: () {
                  context.read<Cart>().decrement(id);
                },
                borderRadius: BorderRadius.all(Radius.circular(100 / 2)),
                child: Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Get.isDarkMode
                              ? Color(0xFF353341)
                              : Color(0xFFEBEBEB),
                          width: 1)),
                  child: const Icon(
                    Icons.remove,
                    size: 18,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
