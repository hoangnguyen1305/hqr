import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class UpperCaseInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final upperCaseText = newValue.text.toUpperCase();
    return TextEditingValue(text: upperCaseText, selection: newValue.selection);
  }
}

class NormalPriceInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,###', 'en_US');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(',', '');
    if (text.isEmpty) return newValue.copyWith(text: '');

    final number = int.tryParse(text);
    if (number == null) return oldValue;

    final newText = _formatter.format(number);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class PlateNumberFormatter extends TextInputFormatter {
  final bool isCar; // true = ô tô, false = xe máy

  PlateNumberFormatter({required this.isCar});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.toUpperCase().replaceAll(RegExp(r'\s|-'), '');

    final isValid =
        isCar ? _isValidCarPlatePartial(text) : _isValidBikePlatePartial(text);

    if (isValid) {
      return newValue.copyWith(text: text, selection: newValue.selection);
    } else {
      // Giữ nguyên giá trị cũ nếu nhập sai
      return oldValue;
    }
  }

  /// Cho phép nhập dần dần nhưng đúng thứ tự (ô tô)
  bool _isValidCarPlatePartial(String text) {
    final pattern = RegExp(
      r'^[0-9]{0,2}$|^[0-9]{2}[A-Z]{0,1}$|^[0-9]{2}[A-Z]{1}[0-9]{0,5}$',
    );
    return pattern.hasMatch(text);
  }

  /// Cho phép nhập dần dần nhưng đúng thứ tự (xe máy)
  bool _isValidBikePlatePartial(String text) {
    final pattern = RegExp(
      r'^[0-9]{0,2}$|^[0-9]{2}[A-Z]{0,1}$|^[0-9]{2}[A-Z]{1}[A-Z0-9]{0,1}$|^[0-9]{2}[A-Z]{1}[A-Z0-9]{1}[0-9]{0,5}$',
    );
    return pattern.hasMatch(text);
  }
}
