import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/button/dropdown_button.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:kwik_port/utils/textFields/goods_volume_field.dart';

class FilterContractDialog extends StatefulWidget {
  const FilterContractDialog({super.key});

  @override
  State<FilterContractDialog> createState() => _FilterContractDialogState();
}

class _FilterContractDialogState extends State<FilterContractDialog> {
  TextEditingController volumeControlller = TextEditingController();
  String? category;
  String? destinaion;
  bool isiconExpanded = false;
  bool isdropdownExpanded = false;
  bool isdestinationiconExpanded = false;
  bool isdestinationdropdownExpanded = false;
  List<String> categoryList = [
    'Agriculture',
    'Cosmectics',
    'Textile',
    'Electronics',
  ];
  List<String> destinationList = ['Argentina', 'Nigeria', 'Canada', 'Dubai'];
  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: colorCodes.white,
      child: Container(
        height: 454,
        // width: double.infinity,
        width: 390,

        decoration: BoxDecoration(
          color: colorCodes.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorCodes.antiFlashWhite, width: 1.2),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Filter",
                  style: kwikTextStlye(20.0, FontWeight.w600, colorCodes.black),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    "assets/images/icons/close-circle.png",
                    height: 24,
                    width: 24,
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),
            //category Dropdown
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Category',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colorCodes.black,
                ),
              ),
            ),
            SizedBox(height: 8),
            itemsDropdown(
              category,
              "Electronics",
              categoryList.map(dropMenuItem).toList(),
              (newValue) {
                setState(() {
                  category = newValue;
                });
              },
              (isOpen) {
                setState(() {
                  isdropdownExpanded = isOpen;
                  isiconExpanded = isOpen;
                });
              },
            ),
            SizedBox(height: 16),
            goodsVolumnFieldColumn(
              "",
              volumeControlller,
              suffixIcon: Image.asset(
                "assets/images/icons/ruler.png",
                height: 24,
                width: 24,
              ),
              title: "Minimum Volume",
            ),
            SizedBox(height: 16),

            //Destination Dropdown
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Destination',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colorCodes.black,
                ),
              ),
            ),
            SizedBox(height: 8),
            itemsDropdown(
              destinaion,
              "Argentina",
              destinationList.map(dropMenuItem).toList(),
              (newValue) {
                setState(() {
                  destinaion = newValue;
                });
              },
              (isOpen) {
                setState(() {
                  isdestinationiconExpanded = isOpen;
                  isdestinationdropdownExpanded = isOpen;
                });
              },
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 95,
                  child: kwikbutton(
                    "Reset",
                    () {},
                    backgroundcolor: colorCodes.white,
                    textColor: colorCodes.black,
                    borderColor: colorCodes.white,
                  ),
                ),
                SizedBox(
                  width: 95,
                  child: kwikbutton("Apply", () {
                    Navigator.pop(context);
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

DropdownMenuItem<String> dropMenuItem(value) {
  return DropdownMenuItem(
    value: value,
    child: Text(
      value,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        fontSize: 16.0,
        color: colorCodes.black,
      ),
    ),
  );
}
