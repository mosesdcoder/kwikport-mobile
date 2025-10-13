import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: OverlayLoaderWithAppIcon(
            overlayOpacity: 0.0,
            isLoading: true,
            appIcon: Image.asset(
              'assets/images/Kwiport.png',
              color: colorCodes.azureBlue,
              // width: 20,
              // height: 20,
              scale: 16.0,
            ),
            circularProgressColor: colorCodes.azureBlue,
            appIconSize: 65,
            child: const SizedBox(height: 20, width: 20),
          ),
        ),
      ),
    );
  }
}

Container kwikportloader() {
  return Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
    ),
    child: OverlayLoaderWithAppIcon(
      overlayOpacity: 0.0,
      isLoading: true,
      appIcon: Image.asset(
        'assets/images/Kwiport.png',
        // width: 20,
        // height: 20,
        color: colorCodes.azureBlue,
        scale: 16.0,
      ),
      circularProgressColor: colorCodes.azureBlue,
      appIconSize: 65,
      child: const SizedBox(height: 20, width: 20),
    ),
  );
}
