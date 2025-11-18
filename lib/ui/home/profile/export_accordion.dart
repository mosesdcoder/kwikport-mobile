import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:kwik_port/utils/toast.dart';

class ExportAccordion extends StatefulWidget {
  final title, statusbtntxt, statusbtnFunc, statusbackgroundColor;
  final child;
  final bool canExpand;

  const ExportAccordion({
    super.key,
    required this.title,
    required this.statusbtntxt,
    required this.statusbackgroundColor,
    required this.statusbtnFunc,
    required this.child,
    this.canExpand = true,
  });

  @override
  State<ExportAccordion> createState() => _ExportAccordionState();
}

class _ExportAccordionState extends State<ExportAccordion> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // height: 80,
          width: MediaQuery.of(context).size.width,
          // padding: const EdgeInsets.only(
          //   top: 14.0,
          //   left: 14,
          //   right: 14,
          //   bottom: 14,
          // ),
          decoration: BoxDecoration(
            color: colorCodes.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: () {
              if (!widget.canExpand) {
                showToastContainer(
                  "Locked Stage 🚧",
                  "Complete the previous stage to unlock this one.",
                  colorCodes.sunset,
                  colorCodes.white,
                  context,
                );
                return;
              }
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 86,
                      width: 30,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: colorCodes.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(
                                    0x66000000,
                                  ), // #00000040 → 40 = ~25% opacity
                                  blurRadius: 2, // same as the 2px blur
                                  offset: Offset(0, 0), // x=0, y=0
                                  spreadRadius: 0, // 0px spread
                                ),
                              ],
                            ),
                            child:
                                widget.statusbtntxt == "Completed"
                                    ? Image.asset(
                                      "assets/images/icons/tick-circle.png",
                                      height: 15,
                                      width: 15,
                                      color: HexColor("#292D32"),
                                    )
                                    : SizedBox(),
                          ),
                          Image.asset(
                            "assets/images/icons/dashboard/Vector 955.png",
                            width: 6,
                            height: 56,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 211,
                          child: Text(
                            widget.title,
                            textAlign: TextAlign.start,
                            // overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                              color: colorCodes.black,
                              // overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        SizedBox(
                          height: 23,
                          width: widget.statusbtntxt == "Pending" ? 60 : 90,
                          child: ElevatedButton(
                            onPressed: widget.statusbtnFunc,

                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.statusbackgroundColor,
                              // widget.statusbtntxt == "Completed"
                              //     ? colorCodes.pigmentGreen
                              //     : widget.statusbtntxt == "Select Agency"
                              //     ? colorCodes.yellowOrange
                              //     : colorCodes.aluminium,
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: Text(
                              widget.statusbtntxt,
                              style: kwikTextStlye(
                                10.0,
                                FontWeight.w500,
                                colorCodes.white,
                                fontFamily: "Poppins",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Icon(
                  isExpanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  color:
                      widget.canExpand
                          ? colorCodes.black
                          : colorCodes.graniteGrey,
                  size: 26,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Container(
            width: MediaQuery.of(context).size.width,
            height: 465,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              // border: Border(
              color: colorCodes.white,
              borderRadius: BorderRadius.circular(16),
            ),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Image.asset(
                    "assets/images/icons/dashboard/Vector 955.png",
                    width: 10,
                    height: 56,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(child: widget.child),
              ],
            ),
          ),
        const SizedBox(height: 5),
      ],
    );
  }
}
