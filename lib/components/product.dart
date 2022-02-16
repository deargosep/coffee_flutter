import 'package:coffee_flutter/store/cart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/src/provider.dart';

class Product extends StatelessWidget {
  final name;
  final id;
  final image;
  final price;
  final size;

  const Product(
      {Key? key,
      required this.id,
      required this.name,
      required this.price,
      required this.size,
      String? this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    void addToCart() {
      final item = {
        "id": id,
        "name": name,
        "image": image,
        "price": price,
        "size": size,
        "count": 1
      };
      context.read<Cart>().addToCart(item);
    }

    return InkWell(
      onTap: () {
        Get.toNamed('/product', arguments: id);
      },
      child: PhysicalModel(
        shadowColor: Colors.black,
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        // elevation: 3,
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 5, 12, 0),
          width: 155,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: SizedBox(
                  height: 136,
                  width: 120,
                  child: Image.network(
                    image,
                    height: 136,
                    width: 120,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: 100,
                child: Text(
                  name.toString(),
                  softWrap: true,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$price ₽',
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 17,
                      ),
                    ),
                    Container(
                      height: 24,
                      width: 24,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF54B2CF),
                      ),
                      child: InkWell(
                        onTap: addToCart,
                        child: Icon(
                          Icons.add,
                          size: 20,
                          color: Get.isDarkMode ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
