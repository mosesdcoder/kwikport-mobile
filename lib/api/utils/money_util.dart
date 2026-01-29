import 'package:intl/intl.dart';

class MoneyUtils {
  static String formatMoney(dynamic value, {String symbol = '₦', int decimalDigits = 0}) {
    if (value == null) return '$symbol${0.toStringAsFixed(decimalDigits)}';

    final num amount = value is num
        ? value
        : num.tryParse(value.toString()) ?? 0;

    return NumberFormat.currency(
      locale: symbol == '\$' ? 'en_US' : 'en_NG',
      symbol: symbol,
      decimalDigits: decimalDigits,
    ).format(amount);
  }
}