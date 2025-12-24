import 'package:intl/intl.dart';

class MoneyUtils {
  static String formatMoney(dynamic value) {
    if (value == null) return '₦0';

    final num amount = value is num
        ? value
        : num.tryParse(value.toString()) ?? 0;

    return NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 0,
    ).format(amount);
  }
}