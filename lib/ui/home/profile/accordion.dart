import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/colors/color.dart';

class Accordion extends StatefulWidget {
  final String title;
  final child;

  const Accordion({super.key, required this.title, required this.child});

  @override
  State<Accordion> createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(
            top: 14.0,
            left: 14,
            right: 14,
            bottom: 14,
          ),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(width: 1.2, color: colorCodes.antiFlashWhite),
              left: BorderSide(width: 1.2, color: colorCodes.antiFlashWhite),
              right: BorderSide(width: 1.2, color: colorCodes.antiFlashWhite),
              bottom: BorderSide(
                width: isExpanded ? 0.1 : 1.2,
                color:
                    // ? colorCodes.whiteSmoke
                    // :
                    colorCodes.antiFlashWhite,
              ),
            ),
            color: colorCodes.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(8),
              topRight: const Radius.circular(8),
              bottomLeft: Radius.circular(isExpanded ? 1 : 8),
              bottomRight: Radius.circular(isExpanded ? 1 : 8),
            ),
          ),
          child: InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 120,
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
                    Icon(
                      isExpanded
                          ? Icons.expand_less_rounded
                          : Icons.expand_more_rounded,
                      color: colorCodes.graniteGrey,
                      size: 24,
                    ),
                  ],
                ),

                isExpanded
                    ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Divider(
                        thickness: 1,
                        color: colorCodes.antiFlashWhite,
                      ),
                    )
                    : SizedBox(),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Container(
            width: MediaQuery.of(context).size.width,
            height: 264,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            // margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 0.1, color: colorCodes.antiFlashWhite),
                left: BorderSide(width: 1.2, color: colorCodes.antiFlashWhite),
                right: BorderSide(width: 1.2, color: colorCodes.antiFlashWhite),
                bottom: BorderSide(
                  width: 1.2,
                  color: colorCodes.antiFlashWhite,
                ),
              ),
              color: colorCodes.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),

            child: widget.child,
          ),
        const SizedBox(height: 15),
      ],
    );
  }
}
