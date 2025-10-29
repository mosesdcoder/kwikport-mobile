import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

class AccountCreateSucess extends StatefulWidget {
  final img, text, buttonText, buttonFunc, subText;
  const AccountCreateSucess({
    super.key,
    required this.img,
    required this.text,
    required this.buttonText,
    required this.buttonFunc,
    required this.subText,
  });

  @override
  State<AccountCreateSucess> createState() => _AccountCreateSucessState();
}

class _AccountCreateSucessState extends State<AccountCreateSucess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorCodes.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(widget.img, height: 96, width: 113),
              SizedBox(height: 40),
              Text(
                widget.text,
                style: kwikTextStlye(24.0, FontWeight.w600, colorCodes.black),
                textAlign: TextAlign.center,
              ),
              widget.subText == "" ? SizedBox() : SizedBox(height: 12),
              Text(
                widget.subText,
                style: kwikTextStlye(
                  14.0,
                  FontWeight.w300,
                  colorCodes.graniteGrey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 48),
              kwikbutton(widget.buttonText, widget.buttonFunc),
            ],
          ),
        ),
      ),
    );
  }
}
