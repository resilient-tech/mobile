import 'package:flutter/material.dart';

class FrappeLogo extends StatelessWidget {
  final Size size;
  const FrappeLogo({this.size = const Size(60, 60)});
  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage('assets/frappe_icon.jpg'),
      width: size.width,
      height: size.height,
    );
  }
}
