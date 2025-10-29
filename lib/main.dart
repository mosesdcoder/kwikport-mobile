import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/api/controller/agency/export_stage_api.dart';
import 'package:kwik_port/api/controller/agency/export_substage_api.dart';
import 'package:kwik_port/api/controller/agency/get_agency_api.dart';
import 'package:kwik_port/api/controller/authApi/change_password_api.dart';
import 'package:kwik_port/api/controller/authApi/createExportProfileApi.dart';
import 'package:kwik_port/api/controller/authApi/forgotPasswordApi.dart';
import 'package:kwik_port/api/controller/authApi/loginApi.dart';
import 'package:kwik_port/api/controller/authApi/registerApi.dart';
import 'package:kwik_port/api/controller/authApi/reset_passwordApi.dart';
import 'package:kwik_port/api/controller/authApi/update_user_api.dart';
import 'package:kwik_port/api/controller/authApi/verifyEmailApi.dart';
import 'package:kwik_port/api/controller/contractsApi/calculate_commodity_cost.dart';
import 'package:kwik_port/api/controller/contractsApi/get_contract_api.dart';
import 'package:kwik_port/api/controller/contractsApi/publishedcontractsApi.dart';
import 'package:kwik_port/api/controller/home/dashboard_api.dart';
import 'package:kwik_port/api/controller/kwikTickets/create_kwikticket_api.dart';
import 'package:kwik_port/api/controller/kwikTickets/fund_ticket_api.dart';
import 'package:kwik_port/api/controller/kwikTickets/get_kwik_ticket_api.dart';
import 'package:kwik_port/api/controller/kwikTickets/update_kwikticket_status_api.dart';
import 'package:kwik_port/api/controller/kwikTickets/verify_payment.dart';
import 'package:kwik_port/api/model/userModel.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/onboarding/splash_screen.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized
  await initUserSession(); // ✅ Loads once, globally
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Registerapi()),
          ChangeNotifierProvider(create: (_) => VerifyEmailApi()),
          ChangeNotifierProvider(create: (_) => CreateExportProfileApi()),
          ChangeNotifierProvider(create: (_) => LoginApi()),
          ChangeNotifierProvider(create: (_) => GetContractApi()),
          ChangeNotifierProvider(create: (_) => CreateKwikticketApi()),
          ChangeNotifierProvider(create: (_) => GetKwikTicketApi()),
          ChangeNotifierProvider(create: (_) => UpdateKwikTicketStatusApi()),
          ChangeNotifierProvider(create: (_) => ForgotPasswordApi()),
          ChangeNotifierProvider(create: (_) => ResetPasswordApi()),
          ChangeNotifierProvider(create: (_) => UpdateUserApi()),
          ChangeNotifierProvider(create: (_) => GetAgencyApi()),
          ChangeNotifierProvider(create: (_) => DashboardApi()),
          ChangeNotifierProvider(create: (_) => ExportSubStageApi()),
          ChangeNotifierProvider(create: (_) => ExportStageApi()),
          ChangeNotifierProvider(create: (_) => ChangePasswordApi()),
          ChangeNotifierProvider(create: (_) => FundKwikticketApi()),
          ChangeNotifierProvider(create: (_) => CalculateCommodityCostApi()),
          ChangeNotifierProvider(create: (_) => VerifyPaymentApi()),
        ],
        child: const MyApp(),
      ),
    );
  });
}

int currentIndex = 1;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final primaryColor = HexColor("#3385FF");
    final primarySwatch = MaterialColor(primaryColor.value, {
      50: primaryColor.withOpacity(0.1),
      100: primaryColor.withOpacity(0.2),
      200: primaryColor.withOpacity(0.3),
      300: primaryColor.withOpacity(0.4),
      400: primaryColor.withOpacity(0.5),
      500: primaryColor.withOpacity(0.6),
      600: primaryColor.withOpacity(0.7),
      700: primaryColor.withOpacity(0.8),
      800: primaryColor.withOpacity(0.9),
      900: primaryColor.withOpacity(1.0),
    });

    final colorScheme = ColorScheme.fromSwatch(primarySwatch: primarySwatch);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kwik Port',
      theme: ThemeData(
        colorScheme: colorScheme.copyWith(background: colorCodes.whiteSmoke),
      ),
      home: const MediaQuery(data: MediaQueryData(), child: SplashScreen()),
    );
  }
}
