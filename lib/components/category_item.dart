import 'package:coffee_flutter/store/category.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class CategoryItem extends StatelessWidget {
  String title;

  CategoryItem({Key? key, required String this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String category = context.watch<Category>().category;
    return GestureDetector(
      onTap: () {
        context.read<Category>().changeCategory(title);
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 14, 0),
        decoration: BoxDecoration(
            color: category != title
                ? Theme.of(context).cardColor
                : Color(0xFF4795AD),
            borderRadius: BorderRadius.all(Radius.circular(24))),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(18.0, 0, 18.0, 0),
          child: Text(title,
              style: TextStyle(
                  color: category != title
                      ? Color(0xFF54B2CF)
                      : Theme.of(context).textTheme.caption?.color)),
        )),
      ),
    );
  }
}
