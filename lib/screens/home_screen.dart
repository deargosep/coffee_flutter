import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_flutter/components/category_item.dart';
import 'package:coffee_flutter/components/home_appbar.dart';
import 'package:coffee_flutter/components/product.dart';
import 'package:coffee_flutter/store/category.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream =
        FirebaseFirestore.instance.collection('Coffees').snapshots();
    return Scaffold(
      body: ListView(
        children: [
          const HomeAppbar(),
          Container(
            height: 30,
            child: const CategoryList(),
            margin: const EdgeInsets.fromLTRB(24.0, 0, 0, 11.0),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: _productsStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                return Container(
                  margin: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 0),
                  child: GridView(
                      physics: const ScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 17,
                        mainAxisSpacing: 17,
                        mainAxisExtent: 230,
                      ),
                      shrinkWrap: true,
                      children: snapshot.data!.docs.where((el) {
                        Map<String, dynamic> data =
                            el.data()! as Map<String, dynamic>;
                        final category = context.watch<Category>().category;
                        if (category != 'All') {
                          if (data['category'] == category) {
                            return true;
                          } else {
                            return false;
                          }
                        } else {
                          return true;
                        }
                      }).map((DocumentSnapshot document) {
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

class CategoryList extends StatelessWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _categoriesStream =
        FirebaseFirestore.instance.collection('Categories').snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _categoriesStream,
      builder: (context, snapshot) {
        return ListView(
            scrollDirection: Axis.horizontal,
            children: [CategoryItem(title: 'All')]
              ..addAll(snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return CategoryItem(title: data['name']);
              }).toList()));
      },
    );
  }
}
