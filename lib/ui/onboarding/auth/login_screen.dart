import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:kwik_port/api/controller/authApi/loginApi.dart';
import 'package:kwik_port/api/utils/loader.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/main.dart';
import 'package:kwik_port/ui/onboarding/auth/forgot_password.dart';
import 'package:kwik_port/ui/onboarding/login_successful_screen.dart';
import 'package:kwik_port/ui/onboarding/auth/signup_screen.dart';
import 'package:kwik_port/utils/button/backNav_button.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/button/loading_dialog.dart';
import 'package:kwik_port/utils/text/signuptxtFunc.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:kwik_port/utils/text/validationtext.dart';
import 'package:kwik_port/utils/textFields/emailField_column.dart';
import 'package:kwik_port/utils/textFields/passwordField_column.dart';
import 'package:kwik_port/utils/toast.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isVisible = false;
  bool check = false;
  String passwordVal = '';
  String emailVal = '';

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
    final loginProvider = Provider.of<LoginApi>(context);
    return Scaffold(
      backgroundColor: colorCodes.whiteSmoke,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             // backnavButton(context),
              SizedBox(height: 27),
              Text(
                'Welcome Back!',
                style: kwikTextStlye(32.0, FontWeight.w500, colorCodes.black),
              ),
              SizedBox(height: 4),
              Text(
                'Log in to your account',
                style: kwikTextStlye(
                  16.0,
                  FontWeight.w400,
                  colorCodes.jetBlack,
                ),
              ),
              SizedBox(height: 32),
              emailFieldColumn(emailVal, emailController),
              emailVal == "" ? Container() : validationtext(emailVal),
              SizedBox(height: 16),
              passwordtextFieldColumn(
                passwordVal,
                passwordController,
                _isVisible,
                () {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    _isVisible = !_isVisible;
                  });
                },
                context,
              ),
              passwordVal == "" ? Container() : validationtext(passwordVal),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ForgotPasswordScreen(
                              email: emailController.text,
                            ),
                      ),
                    );
                  },
                  child: Text(
                    "Forgot Password?",
                    style: kwikTextStlye(
                      14.0,
                      FontWeight.w500,
                      colorCodes.azureBlue,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32),
              kwikbutton(
                'Login',
                () =>
                //  Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => LoginSuccessfulScreen(),
                //   ),
                // ),
                login(loginProvider),
              ),
              SizedBox(height: 12),
              Align(
                alignment: Alignment.center,
                child: signuptxtFunc("Don’t have an account? ", "Sign Up", () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignupScreen()),
                  );
                }),
              ),
              SizedBox(height: 32),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "or",
                  style: kwikTextStlye(
                    14.0,
                    FontWeight.w500,
                    colorCodes.aluminium,
                  ),
                ),
              ),
              SizedBox(height: 24),
              signInContainer(
                'assets/images/icons/google 2.png',
                'Sign in with Google',
              ),
              SizedBox(height: 12),
              signInContainer(
                'assets/images/icons/apple.png',
                'Sign in with Apple',
              ),
            ],
          ),
        ],
      ),
    );
  }

  login(LoginApi loginProvider) {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      // showLoader(context: context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return LoadingDialog();
        },
      );
      loginProvider
          .login(emailController.text, passwordController.text, context)
          .then((_) {
            // Loader.hide();
            Navigator.pop(context);
            if (loginProvider.isLoggedIn) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginSuccessfulScreen(),
                ),
              );
              // showToastContainer(
              //   "Login Successful",
              //   loginProvider.message,
              //   colorCodes.pigmentGreen,
              //   colorCodes.mediumSeaGreen,
              //   context,
              // );
              currentIndex = 1;
            } else {
              _showErrorSnackBar(
                context,
                "Login Failed",
                loginProvider.message ?? "Unable to login. Please check your credentials and try again.",
              );
            }
          });
      currentIndex = 1;
    }
  }

  void _showErrorSnackBar(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 24),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorCodes.portlandOrange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        SizedBox(height: 2),
                        Text(message, maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    Future.delayed(Duration(seconds: 4), () {
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
    });
  }

  Widget signInContainer(img, text) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 57,
        width: 390,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colorCodes.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(img, height: 22, width: 22),
            SizedBox(width: 8),
            Text(
              text,
              style: kwikTextStlye(16.0, FontWeight.w500, colorCodes.squidInk),
            ),
          ],
        ),
      ),
    );
  }
}
