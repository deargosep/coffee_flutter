import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_flutter/components/button.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:coffee_flutter/components/appbar.dart';
import 'package:coffee_flutter/store/cart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductScreen extends HookWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id = Get.arguments;
    final _productStream = FirebaseFirestore.instance
        .collection('Coffees')
        .doc(id)
        .get()
        .asStream();
    final count = useState(1);
    return Scaffold(
        backgroundColor:
            Get.isDarkMode ? Theme.of(context).cardColor : Color(0xFFE4F3F7),
        body: StreamBuilder<DocumentSnapshot>(
          stream: _productStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            final data = snapshot.data?.data() as Map<String, dynamic>;
            void addToCart() {
              final item = {
                "id": id,
                "name": data['name'],
                "image": data['image'],
                "price": data['price'],
                "size": data['size'],
                "count": count.value
              };
              context.read<Cart>().addToCart(item);
              Get.back();
            }

            return Column(
              children: [
                Appbar(),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 100,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 24, 0),
                  child: Row(
                    children: [
                      Spacer(),
                      Image.network(
                        data['image'],
                        scale: 0.49,
                      ),
                      Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100 / 2)),
                            onTap: () {
                              count.value++;
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                              child: const Icon(
                                Icons.add,
                                size: 18,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                            child: Text(
                              count.value.toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          InkWell(
                            onTap: count.value != 1
                                ? () {
                                    count.value--;
                                  }
                                : null,
                            borderRadius:
                                BorderRadius.all(Radius.circular(100 / 2)),
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: count.value != 1
                                      ? Theme.of(context)
                                          .scaffoldBackgroundColor
                                      : Theme.of(context)
                                          .scaffoldBackgroundColor
                                          .withOpacity(0.5)),
                              child: const Icon(
                                Icons.remove,
                                size: 18,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.all(32),
                  height: MediaQuery.of(context).size.height / 2.3,
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data['name'],
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            '${data['price']} ₽',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Text(
                        data['description'] ??
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum nibh justo, placerat sit amet laoreet quis, scelerisque id erat. Pellentesque quis ex sagittis, egestas odio ultrices, ornare dolor. ',
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                            color: Color(0xFF8E8E93)),
                      ),
                      FirmButton(
                        onPressed: addToCart,
                        text: 'Add to cart',
                      )
                    ],
                  ),
                )
              ],
            );
          },
        ));
  }
}
