import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kwik_port/colors/color.dart';

var numberInputFormatters = [
  new FilteringTextInputFormatter.allow(RegExp("[0-9]")),
];
TextField phoneTextfield(
  fNode,
  textControllerId,
  flag,
  dialCode,
  countryDialog,
  maxLength,
  onChanged,
  BuildContext context,
) {
  return TextField(
    controller: textControllerId,
    autocorrect: true,
    focusNode: fNode,
    // autofocus: true,
    enableSuggestions: true,
    maxLength: maxLength,
    inputFormatters: numberInputFormatters,
    keyboardType: TextInputType.number,
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
            width: 90,
            child: FittedBox(
              child: Row(
                children: [
                  // SvgPicture.network(flag, width: 20, height: 20),
                  Image.asset(flag, width: 20, height: 20),
                  const SizedBox(width: 2),
                  Image.asset(
                    'assets/images/icons/Arrowdown_Icon.png',
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 3),
                  const Text(
                    "|",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  Text(
                    " +$dialCode",
                    style: TextStyle(color: Colors.black.withOpacity(0.5)),
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
