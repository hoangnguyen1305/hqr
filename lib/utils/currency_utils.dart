import 'package:intl/intl.dart';

class CurrencyUtils {
  static final _formatterVN = NumberFormat('###,##0', 'en_US');

  static String format(num value) {
    return '${_formatterVN.format(value)} đ';
  }
}
