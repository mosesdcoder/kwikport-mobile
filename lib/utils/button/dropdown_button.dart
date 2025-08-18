import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

bool isiconExpanded = false;
bool isdropdownExpanded = false;
Align itemsDropdown(
  value,
  hintTxt,
  items,
  onchanged,
  onmenustateChange, {
  dropIcon,
}) {
  return Align(
    alignment: Alignment.center,
    child: DropdownButtonHideUnderline(
      child: DropdownButton2(
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: colorCodes.black,
        ),
        value: value,
        hint: Text(
          hintTxt,
          style: kwikTextStlye(16.0, FontWeight.w400, colorCodes.graniteGrey),
        ),
        dropdownStyleData: DropdownStyleData(
          elevation: 2,
          decoration: BoxDecoration(
            color: colorCodes.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: colorCodes.antiFlashWhite,
                spreadRadius: 0.4,
                blurRadius: 0.2,
              ),
            ],
            border: Border.all(
              color: colorCodes.graniteGrey.withOpacity(0.4000000059604645),
              width: 1,
              style: BorderStyle.solid,
            ),
          ),
        ),
        buttonStyleData: ButtonStyleData(
          height: 52,
          width: 335,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  isdropdownExpanded == true
                      ? colorCodes.azureBlue
                      : colorCodes.graniteGrey.withOpacity(0.3),
              width: 1.2,
            ),
          ),
        ),
        iconStyleData: IconStyleData(
          icon:
              dropIcon ??
              Image.asset(
                isiconExpanded == true
                    ? 'assets/images/icons/arrow-up2.png'
                    : 'assets/images/icons/arrow-down2.png',
                height: 22.0,
                width: 22.0,
              ),
        ),
        isExpanded: true,
        items: items,
        onChanged: onchanged,
        onMenuStateChange: onmenustateChange,
      ),
    ),
  );
}
