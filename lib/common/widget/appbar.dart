import 'package:flutter/material.dart';

import '../image.dart';

// ignore: must_be_immutable
class CommonAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          // Navigator.of(context).pop();
        },
      ),
      title: Image.asset(
        ImageResources.Logo,
        height: 40,
      ),
      elevation: 10,
      centerTitle: false,
    );
  }
}
