import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/button/dropdown_button.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/containers/upload_image_container.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:kwik_port/utils/textFields/nameField_column.dart';

class DocumentVerification extends StatefulWidget {
  final VoidCallback nextFunc;
  final VoidCallback previousFunc;
  final String? certificationType;
  final Function(String?) onCertificationTypeChanged;
  File? idDocumentFile;
  File? proofOfAddressFile;
  final Function(File?) onIdDocumentChanged;
  final Function(File?) onProofOfAddressChanged;
  final TextEditingController iDNumberController;
  // final nextFunc, previousFunc;
  DocumentVerification({
    super.key,
    required this.nextFunc,
    required this.previousFunc,
    required this.certificationType,
    required this.onCertificationTypeChanged,
    required this.idDocumentFile,
    required this.proofOfAddressFile,
    required this.onIdDocumentChanged,
    required this.onProofOfAddressChanged,
    required this.iDNumberController,
  });

  @override
  State<DocumentVerification> createState() => _DocumentVerificationState();
}

class _DocumentVerificationState extends State<DocumentVerification> {
  // String? certificatetionType;
  bool isiconExpanded = false;
  bool isdropdownExpanded = false;
  // TextEditingController iDNumbercontroller = TextEditingController();
  List<String> certificatetionTypeList = [
    'International Passport',
    'Voters Card',
    'National Driver License',
    'National ID Card',
    "BankStatement",
    "UtilityBill",
    "BusinessRegistration",
    "TaxCertificate",
    "ProofOfAddress",
    "Selfie",
  ];
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(bool isIdDocument) async {
    final XFile? image = await _picker.pickImage(
      source: await _showPickerDialog(),
      imageQuality: 80,
    );

    if (image != null) {
      final file = File(image.path);

      if (isIdDocument) {
        widget.onIdDocumentChanged(file);
      } else {
        widget.onProofOfAddressChanged(file);
      }
      _validateForm();
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

  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    widget.iDNumberController.addListener(_validateForm);
  }

  @override
  void dispose() {
    widget.iDNumberController.removeListener(_validateForm);
    super.dispose();
  }

  void _validateForm() {
    final isValid =
        widget.iDNumberController.text.isNotEmpty &&
        widget.certificationType != null &&
        widget.idDocumentFile != null &&
        widget.proofOfAddressFile != null;

    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 30),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       children: [
  //         Container(
  //           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
  //           decoration: BoxDecoration(
  //             color: colorCodes.white,
  //             borderRadius: BorderRadius.circular(16),
  //           ),
  //           child: Column(
  //                 children: [
  //                   Row(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Image.asset(
  //                         "assets/images/icons/dashboard/Frame 1000006029 (3).png",
  //                         height: 25,
  //                         width: 25,
  //                       ),
  //                       SizedBox(width: 12),
  //                       Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             "Document Verification",
  //                             style: kwikTextStlye(
  //                               18.0,
  //                               FontWeight.w600,
  //                               colorCodes.black,
  //                             ),
  //                           ),
  //                           Text(
  //                             "Upload required identity documents",
  //                             style: kwikTextStlye(
  //                               12.0,
  //                               FontWeight.w300,
  //                               colorCodes.graniteGrey,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(height: 25),
  //                   Container(
  //                     height: 109,
  //                     width: 351,
  //                     alignment: Alignment.center,
  //                     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  //                     decoration: BoxDecoration(
  //                       color: colorCodes.white,
  //                       borderRadius: BorderRadius.circular(16),
  //                       border: Border.all(
  //                         width: 1.5,
  //                         color: colorCodes.paleCornflowerBlue,
  //                       ),
  //                     ),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Image.asset(
  //                           "assets/images/icons/dashboard/Frame 1000006029.png",
  //                           height: 20,
  //                           width: 20,
  //                         ),
  //                         SizedBox(width: 6),
  //                         SizedBox(
  //                           width: 280,
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text(
  //                                 "Document Security",
  //                                 style: kwikTextStlye(
  //                                   14.0,
  //                                   FontWeight.w600,
  //                                   colorCodes.black,
  //                                 ),
  //                               ),
  //                               Text(
  //                                 "Your documents are encrypted and securely stored. We only use them for identity verification.",
  //                                 textAlign: TextAlign.start,
  //                                 style: kwikTextStlye(
  //                                   12.0,
  //                                   FontWeight.w300,
  //                                   colorCodes.black,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   SizedBox(height: 25),
  //                   Align(
  //                     alignment: Alignment.centerLeft,
  //                     child: Text(
  //                       "Idetification Type",
  //                       style: TextStyle(
  //                         fontFamily: 'Poppins',
  //                         fontSize: 12,
  //                         fontWeight: FontWeight.w500,
  //                         color: colorCodes.black,
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(height: 8),
  //                   kycNationalityDropdown(
  //                     widget.certificationType,
  //                     "Select certification type",
  //                     certificatetionTypeList.map(dropMenuItem).toList(),
  //                     // (newValue) {
  //                     //   setState(() {
  //                     //     certificatetionType = newValue;
  //                     //   });
  //                     // },
  //                     (newValue) {
  //                       widget.onCertificationTypeChanged(newValue);
  //                     },
  //                     (isOpen) {
  //                       setState(() {
  //                         isiconExpanded = isOpen;
  //                         isdropdownExpanded = isOpen;
  //                       });
  //                     },
  //                   ),
  //                   SizedBox(height: 15),
  //                   kycnameFieldColumn(
  //                     "ID Number",
  //                     "",
  //                     widget.iDNumberController,
  //                     hintText: "Peter Walker",
  //                   ),
  //                   SizedBox(height: 15),
  //                   uploadImageContainer(
  //                     "Upload ID Document",
  //                     // () async {
  //                     //   File? selectedFile =
  //                     //       await pickFile(); // Your file picker logic
  //                     //   widget.onIdDocumentChanged(selectedFile);
  //                     // }, imageFile: widget.idDocumentFile
  //                     () => pickImage(true),
  //                     imageFile: widget.idDocumentFile,
  //                   ),
  //                   SizedBox(height: 15),
  //                   uploadImageContainer(
  //                     "Proof of Address",
  //                     () => pickImage(false),
  //                     imageFile: widget.proofOfAddressFile,
  //                     // () async {
  //                     //   File? selectedFile = await pickFile();
  //                     //   widget.onProofOfAddressChanged(selectedFile);
  //                     // }, imageFile: widget.proofOfAddressFile
  //                   ),
  //                   //               uploadImageContainer("Upload ID Document", () async {
  //                   //                     final pickedFile = await _picker.pickImage(
  //                   //                       //source: ImageSource.gallery,
  //                   //                       source: ImageSource.camera,
  //                   // preferredCameraDevice: CameraDevice.front,
  //                   //                     );
  //                   //                     if (pickedFile != null) {
  //                   //                       setState(() {
  //                   //                         _selectedImage = File(pickedFile.path);
  //                   //                       });
  //                   //                     }
  //                   //                   }, _selectedImage),
  //                   //               SizedBox(height: 15),
  //                   //               uploadImageContainer("Proof of Address", () async {
  //                   //                     final pickedFile = await _picker.pickImage(
  //                   //                       source: ImageSource.gallery,
  //                   //                     );
  //                   //                     if (pickedFile != null) {
  //                   //                       setState(() {
  //                   //                         _selectedImage2 = File(pickedFile.path);
  //                   //                       });
  //                   //                     }
  //                   //   },_selectedImage2),
  //                 ],
  //               ),
  //         ),
  //          SizedBox(height: 15),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 SizedBox(
  //                   height: 38,
  //                   width: 150,
  //                   child: kwikbutton(
  //                     "Previous",
  //                     widget.previousFunc,
  //                     backgroundcolor: colorCodes.white,
  //                     textColor: colorCodes.black,
  //                     borderColor: colorCodes.antiFlashWhite,
  //                     fontSize: 12.0,
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 38,
  //                   width: 150,
  //                   child: kwikbutton(
  //                     "Next",
  //                     widget.nextFunc,
  //                     fontSize: 12.0,
  //                     buttonChild: Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         Text(
  //                           "Next",
  //                           style: kwikTextStlye(
  //                             14.0,
  //                             FontWeight.w500,
  //                             colorCodes.whiteSmoke,
  //                           ),
  //                         ),
  //                         SizedBox(width: 8),
  //                         Image.asset(
  //                           "assets/images/icons/arrow-right.png",
  //                           height: 18,
  //                           width: 18,
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             SizedBox(height: 30),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 990,
      width: 391,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: Column(
          children: [
            Container(
              height: 865,
              width: 391,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                            "Document Verification",
                            style: kwikTextStlye(
                              18.0,
                              FontWeight.w600,
                              colorCodes.black,
                            ),
                          ),
                          Text(
                            "Upload required identity documents",
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
                  SizedBox(height: 25),
                  Container(
                    height: 109,
                    width: 351,
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
                          width: 280,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Document Security",
                                style: kwikTextStlye(
                                  14.0,
                                  FontWeight.w600,
                                  colorCodes.black,
                                ),
                              ),
                              Text(
                                "Your documents are encrypted and securely stored. We only use them for identity verification.",
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
                  SizedBox(height: 25),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Idetification Type",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: colorCodes.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  kycNationalityDropdown(
                    widget.certificationType,
                    "Select certification type",
                    certificatetionTypeList.map(dropMenuItem).toList(),
                    // (newValue) {
                    //   setState(() {
                    //     certificatetionType = newValue;
                    //   });
                    // },
                    (newValue) {
                      widget.onCertificationTypeChanged(newValue);
                    },
                    (isOpen) {
                      setState(() {
                        isiconExpanded = isOpen;
                        isdropdownExpanded = isOpen;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  kycnameFieldColumn(
                    "ID Number",
                    "",
                    widget.iDNumberController,
                    hintText: "Peter Walker",
                  ),
                  SizedBox(height: 15),
                  uploadImageContainer(
                    "Upload ID Document",
                    // () async {
                    //   File? selectedFile =
                    //       await pickFile(); // Your file picker logic
                    //   widget.onIdDocumentChanged(selectedFile);
                    // }, imageFile: widget.idDocumentFile
                    () => pickImage(true),
                    imageFile: widget.idDocumentFile,
                  ),
                  SizedBox(height: 15),
                  uploadImageContainer(
                    "Proof of Address",
                    () => pickImage(false),
                    imageFile: widget.proofOfAddressFile,
                    // () async {
                    //   File? selectedFile = await pickFile();
                    //   widget.onProofOfAddressChanged(selectedFile);
                    // }, imageFile: widget.proofOfAddressFile
                  ),
                  //               uploadImageContainer("Upload ID Document", () async {
                  //                     final pickedFile = await _picker.pickImage(
                  //                       //source: ImageSource.gallery,
                  //                       source: ImageSource.camera,
                  // preferredCameraDevice: CameraDevice.front,
                  //                     );
                  //                     if (pickedFile != null) {
                  //                       setState(() {
                  //                         _selectedImage = File(pickedFile.path);
                  //                       });
                  //                     }
                  //                   }, _selectedImage),
                  //               SizedBox(height: 15),
                  //               uploadImageContainer("Proof of Address", () async {
                  //                     final pickedFile = await _picker.pickImage(
                  //                       source: ImageSource.gallery,
                  //                     );
                  //                     if (pickedFile != null) {
                  //                       setState(() {
                  //                         _selectedImage2 = File(pickedFile.path);
                  //                       });
                  //                     }
                  //   },_selectedImage2),
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
                    // _isFormValid ? widget.nextFunc : () {},
                    // enabled: _isFormValid,
                    fontSize: 12.0,
                    buttonChild: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Next",
                          style: kwikTextStlye(
                            14.0,
                            FontWeight.w500,
                            // _isFormValid  ?
                            colorCodes.whiteSmoke,
                            // : colorCodes.aluminium,
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
            SizedBox(height: 30),
          ],
        ),
      ),
    );
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
}
