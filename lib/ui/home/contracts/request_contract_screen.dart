import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/main.dart';
import 'package:kwik_port/ui/home/contracts/request_submit_dialog.dart';
import 'package:kwik_port/utils/button/back_nav_header.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:kwik_port/utils/textFields/date_of_birth_field.dart';
import 'package:kwik_port/utils/textFields/nameField_column.dart';

class RequestContractScreen extends StatefulWidget {
  const RequestContractScreen({super.key});

  @override
  State<RequestContractScreen> createState() => _RequestContractScreenState();
}

class _RequestContractScreenState extends State<RequestContractScreen> {
  TextEditingController productNamecontroller = TextEditingController();
  TextEditingController availableDatecontroller = TextEditingController();
  TextEditingController productquantitycontroller = TextEditingController();
  TextEditingController locationcontroller = TextEditingController();
  TextEditingController contactChannelcontroller = TextEditingController();
  TextEditingController additionalNotescontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: colorCodes.whiteSmoke,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 42.0, bottom: 15),
          child: backNavRow(
            context,
            "Request Contract",
            func: () {
              currentIndex = 1;
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 1195,
                width: 391,
                padding: EdgeInsets.only(
                  left: 15,
                  right: 15,
                  bottom: 20,
                  top: 0,
                ),
                decoration: BoxDecoration(
                  color: colorCodes.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/image 22.png",
                      height: 391,
                      width: 391,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Request an Export Contract",
                      style: kwikTextStlye(
                        18.0,
                        FontWeight.w600,
                        colorCodes.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Can't find a contract that matches your product? ",
                      style: kwikTextStlye(
                        12.0,
                        FontWeight.w500,
                        colorCodes.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Submit a request and our team will review it. If approved, we'll source an export contract for your product and connect you with the next steps.",
                      style: kwikTextStlye(
                        12.0,
                        FontWeight.w300,
                        colorCodes.graniteGrey,
                      ),
                    ),
                    SizedBox(height: 20),
                    kycnameFieldColumn(
                      "Product Name",
                      "",
                      productNamecontroller,
                      hintText: "e.g Cashew nuts, Dry Ginger, Cocoa",
                    ),
                    SizedBox(height: 15),
                    kycnameFieldColumn(
                      "Quantity & Unit",
                      "",
                      productquantitycontroller,
                      hintText: "e.g 5MT, 100bags",
                    ),
                    SizedBox(height: 15),
                    kycnameFieldColumn(
                      "Location / Warehouse",
                      "",
                      locationcontroller,
                      hintText: "City, state or warehouse address",
                    ),
                    SizedBox(height: 15),
                    dateofbirthTxtField(
                      "Availability Date",
                      availableDatecontroller,
                      "",

                      () async {
                        var date = DateTime.now();
                        DateTime? dateofBirth = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().subtract(
                            Duration(days: 18 * 365),
                          ),
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now().subtract(
                            Duration(days: 18 * 365),
                          ),
                        );
                        if (dateofBirth != null) {
                          setState(() {
                            availableDatecontroller.text = DateFormat(
                              'dd/MM/yyyy',
                            ).format(dateofBirth);
                          });
                        }
                      },
                    ),
                    SizedBox(height: 8),
                    Text(
                      "When the product will be ready for export",
                      style: kwikTextStlye(
                        12.0,
                        FontWeight.w300,
                        colorCodes.graniteGrey,
                      ),
                    ),
                    SizedBox(height: 15),
                    kycnameFieldColumn(
                      "Preferred Contact Channel",
                      "",
                      contactChannelcontroller,
                      hintText: "In app, email, phone",
                    ),
                    SizedBox(height: 15),
                    SizedBox(
                      height: 135,
                      width: 351,
                      child: kycnameFieldColumn(
                        "Additional Notes  (Optional)",
                        "",
                        additionalNotescontroller,
                        hintText:
                            "Any additional information about your product or requirements...",
                        maxLines: 5,

                        // maxLength: 200,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              kwikbutton("Submit Request", () {
                showDialog(
                  barrierDismissible: false,
                  context: context,

                  builder: (BuildContext context) {
                    return RequestSubmitDialog();
                  },
                );
              }),
              SizedBox(height: 15),
            ],
          ),
        ],
      ),
    );
  }
}
