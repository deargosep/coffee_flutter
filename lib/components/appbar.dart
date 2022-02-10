import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Appbar extends StatelessWidget {
  String? title;

  Appbar({Key? key, String? this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 54, 0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColorDark,
                ),
                child: Icon(Icons.chevron_left)),
            iconSize: 24,
            splashRadius: 16.0,
            color: Theme.of(context).primaryIconTheme.color,
          ),
          SizedBox(
            width: Get.width / 5,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(title ?? '',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
          ),
          Spacer()
        ],
      ),
    );
  }
}
