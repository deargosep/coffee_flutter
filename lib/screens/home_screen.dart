import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_flutter/components/home_appbar.dart';
import 'package:coffee_flutter/store/cart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream =
        FirebaseFirestore.instance.collection('Coffees').snapshots();
    return Scaffold(
      body: ListView(
        children: [
          HomeAppbar(),
          StreamBuilder<QuerySnapshot>(
              stream: _productsStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                return Container(
                  margin: EdgeInsets.fromLTRB(24.0, 0, 24.0, 0),
                  child: GridView(
                      physics: ScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 17,
                        mainAxisSpacing: 10,
                        mainAxisExtent: 230, // here set custom Height You Want
                      ),
                      shrinkWrap: true,
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        String id = document.id;
                        return Product(
                          id: id,
                          name: data['name'],
                          price: data['price'],
                          image: data['image'],
                          size: data['size'],
                        );
                      }).toList()),
                );
              })
        ],
      ),
    );
  }
}

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
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
        // elevation: 3,
        child: Container(
          padding: EdgeInsets.fromLTRB(12, 5, 12, 0),
          width: 155,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Container(
                  height: 136,
                  width: 120,
                  child: Image.network(
                    image,
                    height: 136,
                    width: 120,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: 100,
                child: Text(
                  name.toString(),
                  softWrap: true,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ),
              ),
              Container(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${price} ₽',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 17,
                      ),
                    ),
                    Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
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
