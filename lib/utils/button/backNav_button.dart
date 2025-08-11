import 'package:flutter/material.dart';

Widget backnavButton(context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Image.asset(
          'assets/images/icons/button back.png',
          height: 48,
          width: 48,
        ),
      ),
    ],
  );
}
