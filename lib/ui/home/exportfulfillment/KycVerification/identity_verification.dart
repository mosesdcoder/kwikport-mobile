import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/containers/upload_image_container.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

class IdentityVerification extends StatefulWidget {
  final VoidCallback nextFunc;
  final VoidCallback previousFunc;
  final File? selfieFile;
  final Function(File?) onSelfieChanged;

  const IdentityVerification({
    super.key,
    required this.nextFunc,
    required this.previousFunc,
    required this.selfieFile,
    required this.onSelfieChanged,
  });

  @override
  State<IdentityVerification> createState() => _IdentityVerificationState();
}

class _IdentityVerificationState extends State<IdentityVerification> {
  final ImagePicker _picker = ImagePicker();
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _validateForm();
  }

  void _validateForm() {
    final isValid = widget.selfieFile != null;
    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: await _showPickerDialog(),
      imageQuality: 80,
    );

    if (image != null) {
      final file = File(image.path);

      widget.onSelfieChanged(file);
    }
  }

  Future<ImageSource> _showPickerDialog() async {
    ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder:
          (context) => Container(
            height: 140,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text("Gallery"),
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text("Camera"),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
              ],
            ),
          ),
    );
    return source ?? ImageSource.gallery;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 900,
      width: 391,
      child: Column(
        children: [
          Container(
            height: 718,
            width: 391,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            decoration: BoxDecoration(
              color: colorCodes.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/icons/dashboard/Frame 1000006029 (3).png",
                      height: 25,
                      width: 25,
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Identity Verification",
                          style: kwikTextStlye(
                            18.0,
                            FontWeight.w600,
                            colorCodes.black,
                          ),
                        ),
                        Text(
                          "Take a selfie for identity confirmation",
                          style: kwikTextStlye(
                            12.0,
                            FontWeight.w300,
                            colorCodes.graniteGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 35),
                Image.asset(
                  "assets/images/icons/account_successimg.png",
                  height: 96,
                  width: 113,
                ),
                SizedBox(height: 40),
                Text(
                  "Identity Verification",
                  style: kwikTextStlye(24.0, FontWeight.w600, colorCodes.black),
                ),
                SizedBox(height: 15),
                Text(
                  "Take a clear selfie to verify your identity matches your ID document",
                  textAlign: TextAlign.center,
                  style: kwikTextStlye(
                    14.0,
                    FontWeight.w300,
                    colorCodes.graniteGrey,
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  height: 110,
                  width: 350,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  decoration: BoxDecoration(
                    color: colorCodes.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      width: 1.0,
                      color: colorCodes.portlandOrange,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/icons/dashboard/info_red.png",
                        height: 32,
                        width: 32,
                      ),
                      SizedBox(width: 8),
                      SizedBox(
                        width: 228,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "KYC Verification Required",
                              style: kwikTextStlye(
                                12.0,
                                FontWeight.w600,
                                colorCodes.sinopia,
                              ),
                            ),
                            SizedBox(height: 2),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w500,
                                  color: colorCodes.black,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        "Good lighting clear visibility of your face\n",
                                  ),
                                  TextSpan(
                                    text:
                                        "• Remove sunglasses, hats, or face coverings\n",
                                  ),
                                  TextSpan(
                                    text: "• Look directly at the camera\n",
                                  ),
                                  TextSpan(
                                    text: "• Make sure the photo is not blurry",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                // uploadImageContainer("Upload Selfie Photo", () {}),
                uploadImageContainer(
                  "Upload Selfie Photo",

                  () => pickImage(),
                  imageFile: widget.selfieFile,
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 38,
                width: 150,
                child: kwikbutton(
                  "Previous",
                  widget.previousFunc,
                  backgroundcolor: colorCodes.white,
                  textColor: colorCodes.black,
                  borderColor: colorCodes.antiFlashWhite,
                  fontSize: 12.0,
                ),
              ),
              SizedBox(
                height: 38,
                width: 150,
                child: kwikbutton(
                  "Next",
                  widget.nextFunc,
                  fontSize: 12.0,
                  buttonChild: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Next",
                        style: kwikTextStlye(
                          14.0,
                          FontWeight.w500,
                          colorCodes.whiteSmoke,
                        ),
                      ),
                      SizedBox(width: 8),
                      Image.asset(
                        "assets/images/icons/arrow-right.png",
                        height: 18,
                        width: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
