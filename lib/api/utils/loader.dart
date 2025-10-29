import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:kwik_port/colors/color.dart';

void showLoader({required BuildContext context}) {
  Loader.show(
    context,
    isSafeAreaOverlay: true,
    isBottomBarOverlay: true,
    overlayFromBottom: 80,
    overlayColor: Colors.black26,
    progressIndicator: CircularProgressIndicator(
      backgroundColor: colorCodes.azureBlue,
    ),
    themeData: ThemeData.dark(),
  );
}
