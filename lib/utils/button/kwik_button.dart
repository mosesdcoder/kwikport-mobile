import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

Widget kwikbutton(
  btntxt,
  btnFunc, {
  textColor,
  backgroundcolor,
  textWidth,
  enabled = true,
  buttonChild,
  borderColor,
  fontSize,

  fontFamily,
}) {
  return InkWell(
    onTap: btnFunc,
    borderRadius: BorderRadius.circular(30),
    child: Container(
      height: 57,
      width: 390,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color:
              backgroundcolor == null
                  ? enabled == false
                      ? colorCodes.platinum
                      : colorCodes.frenchSkyBlue
                  : borderColor,
          width: 1.5,
        ),
        gradient:
            backgroundcolor == null
                ? enabled == false
                    ? null
                    : LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        colorCodes.jordyBlue,
                        colorCodes.azureBlue,
                        colorCodes.azureBlue,
                      ],
                    )
                : null,
        color: enabled == true ? backgroundcolor : colorCodes.platinum,
        borderRadius: BorderRadius.circular(30), // rounded corners
        // boxShadow:
        // enabled
        //     ? [
        //       BoxShadow(
        //         color: Colors.black.withOpacity(0.1),
        //         offset: const Offset(0, 3),
        //         blurRadius: 6,
        //       ),
        //     ]
        //     : [],
      ),
      child:
          buttonChild ??
          Text(
            btntxt,
            style: kwikTextStlye(
              fontFamily: fontFamily ?? "Poppins",
              fontSize ?? 16.0,
              FontWeight.w600,
              backgroundcolor == null
                  ? enabled == true
                      ? colorCodes.whiteSmoke
                      : colorCodes.aluminium
                  : colorCodes.textBlack,
            ),
          ),
    ),
  );
}
