import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/colors/color.dart';

Widget fundTextfield(controller, hintText, onChanged) {
  return SizedBox(
    width: 255,
    height: 50,
    child: TextField(
      showCursor: true,
      cursorColor: colorCodes.bluetiful,
      controller: controller,
      maxLines: 1,
      autofocus: true,
      textAlign: TextAlign.center,

      keyboardType: TextInputType.numberWithOptions(),
      //  inputFormatters: ,
      style: TextStyle(
        color: colorCodes.pigmentGreen,
        // fontFamily: 'DM Sans',
        fontSize: 32,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 0.0,
        ),

        hintText: hintText,
        hintStyle: TextStyle(
          color: colorCodes.gainsboro,
          // fontFamily: 'DM Sans',
          fontSize: 32,
          fontWeight: FontWeight.w500,
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorCodes.graniteGrey),
        ),

        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorCodes.graniteGrey),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorCodes.graniteGrey),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: colorCodes.graniteGrey),
        ),
      ),
      onChanged: onChanged,
    ),
  );
}

Widget fundWalletColumn(
  title,
  errorText,
  controller,
  hintText,
  onChanged, {

  // title,
  suffixIcon,
  maxLines,
  maxLength,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: colorCodes.black,
        ),
      ),
      SizedBox(height: 8),
      TextField(
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w300,
          color: colorCodes.graniteGrey,
        ),
        controller: controller,
        autocorrect: true,
        keyboardType: TextInputType.numberWithOptions(),
        maxLines: maxLines,
        maxLength: maxLength,

        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: '',
            color: colorCodes.graniteGrey,
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),

          // prefixIcon: Container(
          //   height: 12,
          //   width: 12,
          //   padding: const EdgeInsets.symmetric(
          //     horizontal: 10.0,
          //     vertical: 10.0,
          //   ),
          //   margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 3.0),
          //   child:
          //       suffixIcon ??
          //       Image.asset(
          //         "assets/images/icons/search-normal.png",
          //         height: 15,
          //         width: 15,
          //       ),
          // ),
          fillColor: colorCodes.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(width: 1.3, color: HexColor(" #EFEFEF")),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(width: 1.3, color: colorCodes.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: colorCodes.white),
            // errorBorder:  OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(8),
            //   borderSide: BorderSide(width: 1.3, color: colorCodes.portlandOrange),
          ),
        ),
        onChanged: onChanged,
      ),
    ],
  );
}
