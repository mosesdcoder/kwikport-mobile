import 'package:flutter/material.dart';

Widget backnavButton(context, {func}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      InkWell(
        onTap:
            func ??
            () {
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
