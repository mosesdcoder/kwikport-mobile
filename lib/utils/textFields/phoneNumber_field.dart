import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kwik_port/colors/color.dart';

// var numberInputFormatters = [
// new FilteringTextInputFormatter.allow(RegExp("[0-9]+")),
// ];

TextField phoneTextfield(
  fNode,
  textControllerId,
  flag,
  dialCode,
  countryDialog,
  // maxLength,
  // ValueChanged<String>?
  onChanged,
  BuildContext context,
) {
  return TextField(
    controller: textControllerId,
    autocorrect: true,
    focusNode: fNode,
    // autofocus: true,
    enableSuggestions: true,
    // maxLength: maxLength,
    inputFormatters: [
      FilteringTextInputFormatter.allow(
        RegExp(r'^\+?\d*'),
      ), // only allow digits after +
      TextInputFormatter.withFunction((oldValue, newValue) {
        if (!newValue.text.startsWith('+')) {
          return TextEditingValue(
            text: '+' + newValue.text.replaceAll('+', ''),
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
        return newValue;
      }),
    ],
    keyboardType: TextInputType.phone,
    onChanged: onChanged,
    decoration: InputDecoration(
      filled: true,
      fillColor: colorCodes.white,
      counter: Text(''),
      prefixIcon: GestureDetector(
        onTap: countryDialog,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            // color: colorCodes.white,
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Container(
            width: 50,
            child: FittedBox(
              child: Row(
                children: [
                  // SvgPicture.network(flag, width: 20, height: 20),
                  // Container(
                  //   width: 20,
                  //   height: 20,
                  //   decoration: BoxDecoration(
                  //     // image: DecorationImage(
                  //     //   image: AssetImage(flag),
                  //     //   fit: BoxFit.cover,
                  //     // ),
                  //     borderRadius: BorderRadius.circular(3),
                  //   ),
                  //   child:
                  CountryFlag.fromCountryCode(
                    flag,
                    theme: ImageTheme(
                      shape: const Circle(),
                      height: 20,
                      width: 20,
                    ),
                  ),

                  // ),
                  // Image.asset(flag, width: 20, height: 20),
                  const SizedBox(width: 3),
                  const Text(
                    "|",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // contentPadding: const EdgeInsets.only(top: 10, bottom: 10),
      isDense: true,
      border: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          color: colorCodes.graniteGrey.withOpacity(0.2),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      hintText: "+62-952-8789-9099",
      alignLabelWithHint: true,

      hintStyle: TextStyle(
        color: colorCodes.black.withOpacity(0.5),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      // prefixIcon: Icon(Icons.email, color: Colors.grey[400]),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: colorCodes.graniteGrey),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: colorCodes.graniteGrey),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
    ),
  );
}

Widget kycphonenumberFieldColumn(
  errorText,
  controller, {
  title,
  hintText,
  suffixIcon,
  textColor,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title ?? "Phone Number",
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
          color: textColor ?? colorCodes.graniteGrey,
        ),
        controller: controller,
        autocorrect: true,
        keyboardType: TextInputType.numberWithOptions(),
        decoration: InputDecoration(
          hintText: hintText ?? '+2348156732091',
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            color: colorCodes.graniteGrey,
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),

          suffixIcon: Container(
            height: 12,
            width: 12,
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 10.0,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 3.0),
            child: suffixIcon ?? SizedBox(),
          ),
          fillColor: colorCodes.antiFlashWhite,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              width: 1.3,
              color:
                  (errorText != '')
                      ? colorCodes.portlandOrange
                      : colorCodes.antiFlashWhite,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              width: 1.3,
              color:
                  (errorText != '')
                      ? colorCodes.portlandOrange
                      : colorCodes.antiFlashWhite,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color:
                  (errorText != '')
                      ? colorCodes.portlandOrange
                      : colorCodes.antiFlashWhite,
            ),
            // errorBorder:  OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(8),
            //   borderSide: BorderSide(width: 1.3, color: colorCodes.portlandOrange),
          ),
        ),
      ),
    ],
  );
}
