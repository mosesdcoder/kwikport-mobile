import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/api/controller/kwikTickets/create_kwikticket_api.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/api/model/userModel.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/main.dart';
import 'package:kwik_port/ui/home/contracts/generate_contract_ticket_dialog.dart';
import 'package:kwik_port/ui/home/contracts/kwikticket_created_successfully.dart';
import 'package:kwik_port/ui/home/contracts/overviewRichText.dart';
import 'package:kwik_port/utils/button/bottom_navigatior_bar.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:kwik_port/utils/toast.dart';
import 'package:provider/provider.dart';

class ContractDetailsDeliveredScreen extends StatefulWidget {
  final ContractModel contract;
  const ContractDetailsDeliveredScreen({super.key, required this.contract});

  @override
  State<ContractDetailsDeliveredScreen> createState() =>
      _ContractDetailsDeliveredScreenState();
}

class _ContractDetailsDeliveredScreenState
    extends State<ContractDetailsDeliveredScreen> {
  bool checkterms = false;

  @override
  Widget build(BuildContext context) {
    final createTicketApi = Provider.of<CreateKwikticketApi>(
      context,
      listen: false,
    );
    return Scaffold(
      extendBody: true,
      backgroundColor: colorCodes.whiteSmoke,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85.0),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            top: 42.0,
            bottom: 15,
            right: 20.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      currentIndex = 2;
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      'assets/images/icons/button back.png',
                      height: 48,
                      width: 48,
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    children: [
                      FittedBox(
                        child: Text(
                          "Contract details",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: colorCodes.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 2),
                      FittedBox(
                        child: Text(
                          widget.contract.contractId,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: colorCodes.aluminium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Image.asset(
                    "assets/images/icons/dashboard/star_review.png",
                    height: 39,
                    width: 39,
                  ),
                  SizedBox(width: 10),
                  Image.asset(
                    "assets/images/icons/dashboard/telegram_chat.png",
                    height: 39,
                    width: 39,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 65),
        children: [
          Container(
            // height: 2849,
            width: 390,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: colorCodes.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image.network(
                      widget.contract.commodityImage ??
                          "https://kwikport.s3.eu-west-3.amazonaws.com/commodity-images/cocoa.png",
                      height: 238,
                      width: 342,
                    ),
                    Positioned(
                      top: 35,
                      right: 17,
                      // bottom: 0,
                      // left: 0,
                      child: Container(
                        height: 25,
                        width: 48,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            width: 1.2,
                            color: HexColor("#95D6AC"),
                          ),
                          color: colorCodes.pigmentGreen,
                        ),
                        child: Text(
                          "${widget.contract.contractStatus}", // == 0
                          // ? "Active"
                          // : "Closed",
                          style: kwikTextStlye(
                            10.0,
                            FontWeight.w500,
                            colorCodes.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 19),
                Text(
                  widget.contract.commodityName,
                  style: kwikTextStlye(24.0, FontWeight.w600, colorCodes.black),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      height: 24,
                      width: 120,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.2,
                          color: colorCodes.mediumSeaGreen,
                        ),
                        borderRadius: BorderRadius.circular(22),
                        color: colorCodes.aeroblue,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/icons/tick-circle.png",
                            height: 10,
                            width: 10,
                          ),
                          Text(
                            "Grade A Premium",
                            style: kwikTextStlye(
                              10.0,
                              FontWeight.w500,
                              colorCodes.mediumSeaGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      height: 23,
                      // width: 130,
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: colorCodes.whiteSmoke,
                        border: Border.all(color: colorCodes.antiFlashWhite),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Text(
                        "Fair Trade",
                        style: kwikTextStlye(
                          10.0,
                          FontWeight.w500,
                          colorCodes.black,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      height: 23,
                      // width: 130,
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: colorCodes.whiteSmoke,
                        border: Border.all(color: colorCodes.antiFlashWhite),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Text(
                        "Organic",
                        style: kwikTextStlye(
                          10.0,
                          FontWeight.w500,
                          colorCodes.black,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "Nigeria ",
                      style: kwikTextStlye(
                        10.0,
                        FontWeight.w300,
                        colorCodes.graniteGrey,
                      ),
                    ),
                    SizedBox(width: 8),
                    Image.asset(
                      "assets/images/icons/dashboard/arrow-left.png",
                      height: 10,
                      width: 10,
                    ),
                    SizedBox(width: 8),
                    Text(
                      widget.contract.destinationCountry,
                      style: kwikTextStlye(
                        10.0,
                        FontWeight.w300,
                        colorCodes.graniteGrey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 44),
                Text(
                  "CONTRACT OVERVIEW",
                  style: kwikTextStlye(20.0, FontWeight.w600, colorCodes.black),
                ),
                overviewRichText("Commodity", widget.contract.commodityName),
                SizedBox(height: 4),
                overviewRichText(
                  "Contract Type",
                  widget.contract.contractType == 1
                      ? "International Buyer Agreement — verified & binding"
                      : "Local Buyer Agreement — verified & binding",
                ),
                SizedBox(height: 4),
                overviewRichText(
                  "Total Volume Requested",
                  "${widget.contract.totalQuantity} tons",
                ),
                SizedBox(height: 4),
                overviewRichText(
                  "Price per Ton (₦)",
                  "₦${widget.contract.buyerSpecification?.buyerPricePerUnit}",
                ),
                SizedBox(height: 4),
                overviewRichText(
                  "Projected Earnings per Ton (USD)",
                  "${widget.contract.pricePerUnitInUSD}",
                ),
                SizedBox(height: 4),
                overviewRichText(
                  "Contract Duration",
                  "${widget.contract.contractDuration} days from activation",
                ),
                SizedBox(height: 4),
                overviewRichText(
                  "Buyer",
                  "${widget.contract.buyerSpecification?.buyerPricePerUnit}",
                ),
                SizedBox(height: 4),
                overviewRichText(
                  "Quick Snapshot",
                  "${widget.contract.totalQuantity} tons | ₦${widget.contract.buyerSpecification?.buyerPricePerUnit}ton | ${widget.contract.pricePerUnitInUSD} projected earnings",
                ),
                SizedBox(height: 34),
                Text(
                  "BUYER SPECIFICATIONS",
                  style: kwikTextStlye(20.0, FontWeight.w600, colorCodes.black),
                ),
                Text(
                  "Before you participate, ensure your product meets the buyer’s requirements:",
                  textAlign: TextAlign.start,
                  style: kwikTextStlye(
                    12.0,
                    FontWeight.w300,
                    colorCodes.graniteGrey,
                  ),
                ),
                SizedBox(height: 20),
                specificationsRow(
                  "Quality",
                  "Premium grade ${widget.contract.commodityName}, minimum ${widget.contract.buyerSpecification?.fatContentInPercentage}% fat, no foreign matter",
                ),
                SizedBox(height: 13),
                specificationsRow(
                  "Packaging",
                  "${widget.contract.totalQuantity} food-grade sacks, properly sealed & labeled",
                ),
                SizedBox(height: 13),
                specificationsRow(
                  "Delivery Location",
                  widget.contract.destinationCountry,
                ),
                SizedBox(height: 13),
                specificationsRow(
                  "Inspection",
                  " Product must pass testing before your KwikTicket becomes active",
                ),
                SizedBox(height: 13),
                specificationsRow(
                  "Documentation",
                  "Batch number and inspection certificate",
                ),
                SizedBox(height: 10),
                Container(
                  height: 79,
                  width: 342,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: colorCodes.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      width: 1.5,
                      color: colorCodes.paleCornflowerBlue,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/icons/dashboard/Frame 1000006029.png",
                        height: 20,
                        width: 20,
                      ),
                      SizedBox(width: 6),
                      SizedBox(
                        width: 235,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pro tip",
                              style: kwikTextStlye(
                                14.0,
                                FontWeight.w600,
                                colorCodes.black,
                              ),
                            ),
                            Text(
                              "All specifications must be met to ensure smooth export processing.",
                              textAlign: TextAlign.start,
                              style: kwikTextStlye(
                                12.0,
                                FontWeight.w300,
                                colorCodes.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  "HOW YOU CAN ACTIVATE THIS CONTRACT",
                  style: kwikTextStlye(20.0, FontWeight.w600, colorCodes.black),
                ),
                SizedBox(height: 10),
                specificationsRow(
                  "KWIKPROCURE",
                  "",
                  subwidget: Container(
                    height: 23,
                    // width: 130,
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: colorCodes.whiteSmoke,
                      border: Border.all(color: colorCodes.antiFlashWhite),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "Recommended",
                      style: kwikTextStlye(
                        10.0,
                        FontWeight.w500,
                        colorCodes.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                contractPointText(
                  "Choose from verified independent procurement agencies onboarded by KwikPort.",
                ),
                contractPointText(
                  "No upfront cash required — KwikPort funds the procurement.",
                ),
                contractPointText(
                  "Agencies handle sourcing, packaging, and delivery.",
                ),
                contractPointText(
                  "Track costs and projected earnings in real-time via KwikLC.",
                ),
                SizedBox(height: 5),
                specificationsRow("OWN PRODUCT", ""),
                SizedBox(height: 10),
                contractPointText(
                  "Submit your product at a designated testing facility.",
                ),
                contractPointText(
                  "Once approved, your KwikTicket becomes active.",
                ),
                SizedBox(height: 15),
                Text(
                  "Example: Submitting 5 tons of cocoa → approval triggers your export journey.",
                  style: kwikTextStlye(12.0, FontWeight.w500, colorCodes.black),
                ),
                SizedBox(height: 10),
                Container(
                  height: 79,
                  width: 342,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: colorCodes.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      width: 1.5,
                      color: colorCodes.paleCornflowerBlue,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/icons/dashboard/Frame 1000006029.png",
                        height: 20,
                        width: 20,
                      ),
                      SizedBox(width: 6),
                      SizedBox(
                        width: 235,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pro tip",
                              style: kwikTextStlye(
                                14.0,
                                FontWeight.w600,
                                colorCodes.black,
                              ),
                            ),
                            Text(
                              "Present both options side by side so you can compare benefits.",
                              textAlign: TextAlign.start,
                              style: kwikTextStlye(
                                12.0,
                                FontWeight.w300,
                                colorCodes.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  "EXPORTER OF RECORD &",
                  style: kwikTextStlye(20.0, FontWeight.w600, colorCodes.black),
                ),
                Row(
                  children: [
                    Text(
                      "COMPLIANCE",
                      style: kwikTextStlye(
                        20.0,
                        FontWeight.w600,
                        colorCodes.black,
                      ),
                    ),
                    SizedBox(width: 15),
                    Container(
                      height: 23,
                      width: 125,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorCodes.papayaWhip,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          width: 1.5,
                          color: colorCodes.yellowOrange,
                        ),
                      ),
                      child: Text(
                        "Trusted & Protected",
                        style: kwikTextStlye(
                          10.0,
                          FontWeight.w500,
                          colorCodes.textBlack,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  "KwikPort acts as the official Exporter of Record for this contract:",
                  textAlign: TextAlign.start,
                  style: kwikTextStlye(
                    12.0,
                    FontWeight.w300,
                    colorCodes.graniteGrey,
                  ),
                ),
                SizedBox(height: 10),
                contractPointText(
                  "All government approvals, compliance filings, and customs documentation are handled by KwikPort and its verified agencies.",
                ),
                contractPointText(
                  "Users do not need to register as exporters.",
                ),
                contractPointText(
                  "KwikPort bears full responsibility for regulatory compliance, protecting you from errors, penalties, or documentation issues.",
                ),
                SizedBox(height: 34),
                Text(
                  "Earnings & Security",
                  style: kwikTextStlye(20.0, FontWeight.w600, colorCodes.black),
                ),
                SizedBox(height: 10),
                contractPointText(
                  "Once you generate your KwikTicket, your projected earnings are instantly loaded into KwikLC (dollar wallet).",
                ),
                contractPointText("Track agency fees and deductions live."),
                contractPointText(
                  "Upon export completion, funds are automatically converted to KwikBalance (Naira wallet) for withdrawal.",
                ),
                contractPointText(
                  "All funds are protected via insurance partnerships.",
                ),
                SizedBox(height: 15),
                Text(
                  "Example: Funding 5 tons via KwikProcure → \$16,000 gross earnings minus \$1,000 agency fees",
                  style: TextStyle(
                    fontFamily: "",
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: colorCodes.black,
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  height: 235,
                  width: 342,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.2, color: HexColor("#E7E7E7")),
                    borderRadius: BorderRadius.circular(8),
                    color: colorCodes.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Next Steps",
                        style: kwikTextStlye(
                          14.0,
                          FontWeight.w500,
                          colorCodes.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      checkRow(
                        "Review the main contract and buyer specifications.",
                      ),
                      SizedBox(height: 10),
                      checkRow("Acknowledge agreement to the terms."),
                      SizedBox(height: 10),
                      checkRow(
                        "Input the volume you wish to export → this generates your personalized KwikTicket.",
                      ),
                      SizedBox(height: 10),
                      checkRow(
                        "Choose your activation path: KwikProcure or Own Product.",
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 110,
                  width: 342,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                  decoration: BoxDecoration(
                    color: colorCodes.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      width: 1.5,
                      color: colorCodes.paleCornflowerBlue,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/icons/dashboard/Frame 1000006029.png",
                        height: 20,
                        width: 20,
                      ),
                      SizedBox(width: 6),
                      SizedBox(
                        width: 245,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Important",
                              style: kwikTextStlye(
                                12.0,
                                FontWeight.w600,
                                colorCodes.bluetiful,
                              ),
                            ),
                            Text(
                              "This page provides information about the main contract, not your KwikTicket. The ticket becomes active only after you select your capacity.",
                              textAlign: TextAlign.start,
                              style: kwikTextStlye(
                                10.0,
                                FontWeight.w300,
                                colorCodes.bluetiful,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          checkterms = !checkterms;
                        });
                      },
                      child:
                          checkterms == true
                              ? Image.asset(
                                "assets/images/icons/dashboard/Checkbox (1).png",
                                height: 25,
                                width: 25,
                              )
                              : Container(
                                height: 20,
                                width: 20,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: colorCodes.frenchSkyBlue,
                                    width: 1.5,
                                  ),

                                  color: colorCodes.white,
                                  borderRadius: BorderRadius.circular(
                                    6,
                                  ), // rounded corners
                                ),
                              ),
                    ),
                    SizedBox(width: 5),
                    SizedBox(
                      width: 250,
                      child: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12.0,
                            fontWeight: FontWeight.w300,
                            color: colorCodes.black,
                          ),
                          children: [
                            TextSpan(text: "I agree to the "),
                            TextSpan(
                              text: "Terms and Conditions. ",
                              style: TextStyle(color: colorCodes.azureBlue),
                            ),
                            TextSpan(
                              text:
                                  "I agree that this contract is understood by me.",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 35),
          kwikbutton("Generate KwikTicket", () {
            if (checkterms == true) {
              showDialog(
                barrierDismissible: false,
                context: context,

                builder: (BuildContext context) {
                  return GenerateContractTicketDialog(
                    contract: widget.contract,
                    // generateFunc: () async {
                    //   final newTicket = await createTicketApi
                    //       .createKwikTicket(
                    //         exportContractId: widget.contract.id,
                    //         exporterId: userDataVar?.exporter?.id ?? "",
                    //         peggedDollarValue:
                    //             widget.contract.projectedIncome ?? 0.0,
                    //         badge: "Gold",
                    //         deadline: DateTime.now().add(
                    //           Duration(
                    //             days: widget.contract.contractDuration ?? 0,
                    //           ),
                    //         ),
                    //         kwikTicketAmount:
                    //             widget.contract.totalAmount ?? 0.0,
                    //         projectedIncomeInDollars:
                    //             widget.contract.projectedIncome ?? 0.0,
                    //         // exporterId: widget.contract.exporterId ?? "N/A",
                    //       )
                    //       .then((newTicket) {
                    //         if (createTicketApi.isSuccessful == true &&
                    //             newTicket != null) {
                    //           Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //               builder:
                    //                   (_) => KwikticketCreatedSuccessfully(

                    //                     kwikticket: newTicket,
                    //                   ),
                    //             ),
                    //           );
                    //         } else {
                    //           showToastContainer(
                    //             "Error",
                    //             createTicketApi.message,
                    //             colorCodes.mistyRose,
                    //             colorCodes.portlandOrange,
                    //             context,
                    //           );
                    //         }
                    //       });

                    //   currentIndex = 3;
                    // },
                  );
                },
              );
            }
          }),
          SizedBox(height: 35),
        ],
      ),
      bottomNavigationBar: Bottomnavigationbar(5),
    );
  }

  Widget checkRow(title) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          "assets/images/icons/dashboard/Checkbox (1).png",
          height: 16,
          width: 16,
        ),
        SizedBox(height: 20),
        SizedBox(
          width: 250,
          child: Text(
            title,
            textAlign: TextAlign.start,
            style: kwikTextStlye(12.0, FontWeight.w300, colorCodes.black),
          ),
        ),
      ],
    );
  }

  Widget specificationsRow(title, description, {subwidget}) {
    return Row(
      children: [
        Image.asset(
          "assets/images/icons/dashboard/Frame 1000006016.png",
          height: 25,
          width: 25,
        ),
        SizedBox(width: 9),
        SizedBox(
          width: subwidget == null ? 255 : null,
          child: RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: colorCodes.black,
              ),
              children: [
                TextSpan(text: title),
                TextSpan(
                  text: description == "" ? description : ": $description",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: colorCodes.graniteGrey,
                  ),
                ),
              ],
            ),
          ),
        ),
        subwidget != null ? SizedBox(width: 10) : SizedBox(width: 1),
        subwidget ?? Container(),
      ],
    );
  }

  Widget contractPointText(point) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Container(
            height: 6,
            width: 6,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorCodes.black,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
        SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: SizedBox(
            width: 270,
            child: Text(
              point,
              style: kwikTextStlye(12.0, FontWeight.w300, colorCodes.black),
            ),
          ),
        ),
      ],
    );
  }
}
