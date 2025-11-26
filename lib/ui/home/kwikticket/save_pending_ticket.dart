import 'package:shared_preferences/shared_preferences.dart';

Future<void> savePendingTicket(String ticketId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('pendingKwikTicketId', ticketId);
}

Future<String?> getPendingTicket() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('pendingKwikTicketId');
}

Future<void> clearPendingTicket() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('pendingKwikTicketId');
}
