import 'package:flutter/material.dart';

class FirmButton extends StatelessWidget {
  var onPressed;

  String? text;

  FirmButton({Key? key, this.onPressed, String? this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
          width: MediaQuery.of(context).size.width / 1.5,
          height: 64,
          decoration: BoxDecoration(
            color: Theme.of(context).buttonColor,
            borderRadius: BorderRadius.all(Radius.circular(64.0)),
          ),
          child: Center(
            child: Text(text ?? 'Checkout',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 17,
                    color: Colors.white)),
          )),
    );
  }
}

class CircularFirmButton extends StatelessWidget {
  var onPressed;

  CircularFirmButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
          width: MediaQuery.of(context).size.width / 1.5,
          height: 64,
          decoration: BoxDecoration(
              color: Theme.of(context).buttonColor, shape: BoxShape.circle),
          child: const Center(
            child: Text('Checkout',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 17,
                    color: Colors.white)),
          )),
    );
  }
}
