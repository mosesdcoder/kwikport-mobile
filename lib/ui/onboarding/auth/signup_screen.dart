import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:kwik_port/api/controller/authApi/registerApi.dart';
import 'package:kwik_port/api/utils/loader.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/onboarding/account_create_sucess.dart';
import 'package:kwik_port/ui/onboarding/auth/confirm_otp_screen.dart';
import 'package:kwik_port/ui/onboarding/auth/login_screen.dart';
import 'package:kwik_port/ui/onboarding/auth/profile_setup_screen.dart';
import 'package:kwik_port/utils/button/backNav_button.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/button/loading_dialog.dart';
import 'package:kwik_port/utils/text/header_subtitle_text.dart';
import 'package:kwik_port/utils/text/signuptxtFunc.dart';
import 'package:kwik_port/utils/textFields/emailField_column.dart';
import 'package:kwik_port/utils/textFields/nameField_column.dart';
import 'package:kwik_port/utils/textFields/passwordField_column.dart';
import 'package:kwik_port/utils/textFields/phoneNumber_field.dart';
import 'package:kwik_port/utils/toast.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController(
    text: "+",
  );

  FocusNode phoneNumberFocusNode = FocusNode();
  String flag = "assets/images/icons/Indonesia (ID).png";
  String dialCode = '+234';
  bool _isvisible = false;
  // int countryNumLength = 10;
  String countryCode = 'NG';
  final Map<String, String> dialMap = {
    '+1': 'US',
    '+44': 'GB',
    '+234': 'NG',
    '+91': 'IN',
    '+237': 'CM', // Cameroon
    '+254': 'KE', // Kenya
    '+255': 'TZ', // Tanzania
    '+256': 'UG', // Uganda
    '+260': 'ZM', // Zambia
    '+263': 'ZW', // Zimbabwe
    '+971': 'AE', // United Arab Emirates
    '+972': 'IL', // Israel
    '+974': 'QA', // Qatar
    '+975': 'BT', // Bhutan
    '+977': 'NP', // Nepal
    '+994': 'AZ', // Azerbaijan
    '+998': 'UZ', // Uzbekistan
    '+49': 'DE', // Germany
    '+52': 'MX', // Mexico
    '+55': 'BR', // Brazil
    '+60': 'MY', // Malaysia
    '+61': 'AU', // Australia
    '+62': 'ID', // Indonesia
    '+63': 'PH', // Philippines
    '+65': 'SG', // Singapore
    '+81': 'JP', // Japan
    '+82': 'KR', // South Korea
    '+84': 'VN', // Vietnam
    '+86': 'CN', // China
    '+90': 'TR', // Turkey
    '+91': 'IN', // India
    '+92': 'PK', // Pakistan
    '+93': 'AF', // Afghanistan
    '+94': 'LK', // Sri Lanka
    '+95': 'MM', // Myanmar
    '+98': 'IR', // Iran
    '+212': 'MA', // Morocco
    '+213': 'DZ', // Algeria
    '+216': 'TN', // Tunisia
    '+218': 'LY', // Libya
    '+220': 'GM', // Gambia
    '+221': 'SN', // Senegal
    '+225': 'CI', // Côte d’Ivoire
    '+233': 'GH', // Ghana
    '+7': 'RU', // Russia / Kazakhstan
    '+20': 'EG', // Egypt
    '+27': 'ZA', // South Africa
    '+30': 'GR', // Greece
    '+31': 'NL', // Netherlands
    '+32': 'BE', // Belgium
    '+33': 'FR', // France
    '+34': 'ES', // Spain
    '+39': 'IT', // Italy
    '+40': 'RO', // Romania
  };
  void _onChanged(String value) {
    for (final entry in dialMap.entries) {
      if (value.startsWith(entry.key)) {
        setState(() {
          countryCode = entry.value;
          dialCode = entry.key;
        });
        break;
      }
    }
  }

  bool countList = false;
  String emailVal = '';
  String fullnameVal = '';
  String passwordVal = '';
  // for password requirements
  bool hasMinLength = false;
  bool hasLowerCase = false;
  bool hasUpperCase = false;
  bool hasSpecialChar = false;
  Map<String, String> splitFullName(String fullName) {
    List<String> parts = fullName.trim().split(" ");

    String lastName = "";
    String firstName = "";

    String otherNames = "";

    if (parts.isNotEmpty) {
      firstName = parts.first; // first word
      if (parts.length > 1) {
        lastName = parts.last; // last word
      }
      if (parts.length > 2) {
        // everything between first and last name
        otherNames = parts.sublist(1, parts.length - 1).join(" ");
      }
    }

    return {
      "firstName": firstName,
      "lastName": lastName,
      "otherNames": otherNames,
    };
  }

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

    setState(() {
      hasMinLength = passwordValidator.length >= 8;
      hasLowerCase = passwordValidator.contains(RegExp(r'[a-z]'));
      hasUpperCase = passwordValidator.contains(RegExp(r'[A-Z]'));
      hasSpecialChar = passwordValidator.contains(
        RegExp(r'[!@#\$&\*\?./|\-+]'),
      );

      if (hasMinLength && hasLowerCase && hasUpperCase && hasSpecialChar ||
          passwordValidator == '') {
        passwordVal = '';
      } else {
        passwordVal = 'Insert a valid password';
      }
    });
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
    final registerProvider = Provider.of<Registerapi>(context);
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
                subtitlefontSize: 14.0,
                subtitlefontWeight: FontWeight.w300,
              ),
              SizedBox(height: 32),
              nameFieldColumn(fullnameVal, fullnameController),
              SizedBox(height: 16),
              Text(
                'Phone Number',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colorCodes.black,
                ),
              ),
              SizedBox(height: 8),
              phoneTextfield(
                phoneNumberFocusNode,
                phoneNumberController,
                countryCode,
                dialCode,

                () async {
                  setState(() {
                    countList = !countList;
                  });
                },

                // countryNumLength + 1,
                _onChanged,
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
                () => register(registerProvider),
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

  register(Registerapi registerProvider) async {
    if (emailController.text.isNotEmpty &&
        fullnameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty) {
      // showLoader(context: context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return LoadingDialog();
        },
      );
      final userData = splitFullName(fullnameController.text);

      print(userData);
      // {
      //   "firstName": "John",
      //   "lastName": "Doe",
      //   "otherNames": "Michael Junior"
      // }

      registerProvider
          .registerApi(
            userData["firstName"] ?? "",
            userData["lastName"] ?? "",
            userData["otherNames"] ?? "",
            emailController.text,

            phoneNumberController.text,
            passwordController.text,
            context,
          )
          .then((_) {
            // Handle the login result
            if (registerProvider.registrationSuccess) {
              print("here");
              // Navigator.pop(context);
              // if (registerProvider.registrationSuccess2) {
              Navigator.pop(context);
              // Loader.hide();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => ConfirmOtpScreen(
                        email: emailController.text,
                        sessionHash: registerProvider.sessionHash,
                        flowType: "signup",
                      ),
                ),
              );

           
             
            } else {
              // Login failed
              showToastContainer(
                "Signup",
                registerProvider.message,
                colorCodes.mistyRose,
                colorCodes.portlandOrange,
                context,
              );
              Navigator.pop(context);
              // Loader.hide();
            }
          });
    } else {
      Navigator.pop(context);
      // Loader.hide();
      showToastE(context: context, message: "Fill fields properly");
    }
  }
}
