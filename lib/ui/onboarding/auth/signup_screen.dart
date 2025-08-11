import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/onboarding/account_create_sucess.dart';
import 'package:kwik_port/ui/onboarding/auth/confirm_otp_screen.dart';
import 'package:kwik_port/ui/onboarding/auth/login_screen.dart';
import 'package:kwik_port/ui/onboarding/auth/profile_setup_screen.dart';
import 'package:kwik_port/utils/button/backNav_button.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/header_subtitle_text.dart';
import 'package:kwik_port/utils/text/signuptxtFunc.dart';
import 'package:kwik_port/utils/textFields/emailField_column.dart';
import 'package:kwik_port/utils/textFields/nameField_column.dart';
import 'package:kwik_port/utils/textFields/passwordField_column.dart';
import 'package:kwik_port/utils/textFields/phoneNumber_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  FocusNode phoneNumberFocusNode = FocusNode();
  String flag = "assets/images/icons/Indonesia (ID).png";
  String dialCode = '254';
  bool _isvisible = false;
  int countryNumLength = 9;
  bool countList = false;
  String emailVal = '';
  String fullnameVal = '';
  String passwordVal = '';
  bool validateEmailBool(String email) {
    // Regular exchangion pattern for email validation
    final pattern = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  void validateEmail() {
    String emailValidator = emailController.text;
    bool isValid = validateEmailBool(emailValidator);

    if (isValid || emailValidator == "") {
      setState(() {
        emailVal = '';
      });
    } else {
      setState(() {
        emailVal = 'Email address invalid';
      });
    }
  }

  void validatePassword() {
    String passwordValidator = passwordController.text;

    if (passwordValidator.isNotEmpty || passwordValidator == '') {
      setState(() {
        passwordVal = '';
      });
    } else {
      setState(() {
        passwordVal = 'insert a valid password';
      });
    }
  }

  String? firstName = '';
  @override
  void initState() {
    super.initState();
    // fullnameController.addListener();
    // phoneNumberController.addListener();
    emailController.addListener(validateEmail);
    passwordController.addListener(validatePassword);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorCodes.whiteSmoke,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              backnavButton(context),
              SizedBox(height: 27),
              headerSubtitleDescription(
                'Create an Account',
                'Enter your detail below to create your account',
              ),
              SizedBox(height: 32),
              nameFieldColumn(fullnameVal, fullnameController),
              SizedBox(height: 16),
              phoneTextfield(
                phoneNumberFocusNode,
                phoneNumberController,
                flag,
                dialCode,
                () async {
                  setState(() {
                    countList = !countList;
                  });
                },
                countryNumLength + 1,

                (value) {
                  if (value.startsWith("0")) {
                    phoneNumberController.value = TextEditingValue(
                      text: value.substring(1),
                    );
                  }
                  if (phoneNumberController.text.length > countryNumLength) {
                    phoneNumberController.text = phoneNumberController.text
                        .substring(0, countryNumLength);
                  }
                },
                context,
              ),
              emailFieldColumn(emailVal, emailController),
              SizedBox(height: 16),
              passwordtextFieldColumn(
                passwordVal,
                passwordController,
                _isvisible,
                () {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    _isvisible = !_isvisible;
                  });
                },
                context,
              ),
              SizedBox(height: 109),
              kwikbutton(
                'Continue',
                () {
                  // if (emailController.text.isNotEmpty &&
                  //     fullnameController.text.isNotEmpty &&
                  //     passwordController.text.isNotEmpty &&
                  //     phoneNumberController.text.isNotEmpty)
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ConfirmOtpScreen(
                              screen: AccountCreateSucess(
                                img:
                                    'assets/images/icons/account_successimg.png',
                                text: 'Account created\nsucessfully!',
                                buttonText: "Continue",
                                buttonFunc: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ProfileSetupScreen(),
                                    ),
                                  );
                                },
                                subText: "",
                              ),
                              email: emailController.text,
                            ),
                      ),
                    );
                  }
                },
                enabled:
                    emailController.text.isNotEmpty &&
                            fullnameController.text.isNotEmpty &&
                            passwordController.text.isNotEmpty &&
                            phoneNumberController.text.isNotEmpty
                        ? true
                        : false,
              ),
              SizedBox(height: 12),
              Align(
                alignment: Alignment.center,
                child: signuptxtFunc("Already have an account? ", "Log in", () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
