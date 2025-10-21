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
    // Loại bỏ dấu cách, gạch, chấm khi xử lý
    var raw = newValue.text.toUpperCase().replaceAll(RegExp(r'[\s\-.]'), '');

    // Giới hạn độ dài tối đa
    final maxLength = isCar ? 8 : 9;
    if (raw.length > maxLength) raw = raw.substring(0, maxLength);

    // Nếu chưa hợp lệ theo thứ tự nhập, giữ giá trị cũ
    final isValid =
        isCar ? _isValidCarPlatePartial(raw) : _isValidBikePlatePartial(raw);

    if (!isValid) {
      return oldValue;
    }

    // Tạo định dạng hiển thị
    final formatted = _formatPlate(raw);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  /// Định dạng hiển thị có dấu '-' và '.'
  String _formatPlate(String text) {
    if (isCar) {
      // Ô tô: 2 số + 1 chữ + 4–5 số
      if (text.length <= 3) return text;
      if (text.length <= 6) {
        return '${text.substring(0, 3)}-${text.substring(3)}';
      }
      return '${text.substring(0, 3)}-${text.substring(3, 6)}.${text.substring(6)}';
    } else {
      // Xe máy: 2 số + 1–2 chữ + 4–5 số
      if (text.length <= 4) return text;
      if (text.length <= 7) {
        return '${text.substring(0, 4)}-${text.substring(4)}';
      }
      return '${text.substring(0, 4)}-${text.substring(4, 7)}.${text.substring(7)}';
    }
  }

  /// Cho phép nhập dần dần nhưng đúng thứ tự (ô tô)
  bool _isValidCarPlatePartial(String text) {
    final pattern = RegExp(
      r'^[0-9]{0,2}$' // 2 số đầu
      r'|^[0-9]{2}[A-Z]{0,1}$' // + 1 chữ
      r'|^[0-9]{2}[A-Z]{1}[0-9]{0,5}$', // + dãy số
    );
    return pattern.hasMatch(text);
  }

  /// Cho phép nhập dần dần nhưng đúng thứ tự (xe máy)
  bool _isValidBikePlatePartial(String text) {
    final pattern = RegExp(
      r'^[0-9]{0,2}$' // 2 số đầu
      r'|^[0-9]{2}[A-Z]{0,1}$' // + 1 chữ
      r'|^[0-9]{2}[A-Z]{1}[A-Z0-9]{0,1}$' // + chữ/số thứ 2
      r'|^[0-9]{2}[A-Z]{1}[A-Z0-9]{1}[0-9]{0,5}$', // + dãy số
    );
    return pattern.hasMatch(text);
  }
}

class LicensePlateFormatter extends TextInputFormatter {
  final bool isCar;

  LicensePlateFormatter({required this.isCar});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (text.isEmpty) {
      return newValue.copyWith(
        text: '',
        selection: const TextSelection.collapsed(offset: 0),
      );
    }

    // Giới hạn độ dài ký tự (chưa tính dấu)
    final maxRawLength = isCar ? 8 : 9;
    if (text.length > maxRawLength) text = text.substring(0, maxRawLength);

    final formatted = _formatPlate(text, isCar: isCar);

    // Giữ vị trí con trỏ cuối
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _formatPlate(String plate, {required bool isCar}) {
    if (isCar) {
      // Ô tô: 2 số + 1 chữ + 4–5 số
      // ex: 51A9999 → 51A-9999, 51A12345 → 51A-123.45
      if (plate.length <= 3) return plate;
      if (plate.length <= 7) {
        return '${plate.substring(0, 3)}-${plate.substring(3)}';
      }
      if (plate.length <= 9) {
        return '${plate.substring(0, 3)}-${plate.substring(3, 6)}.${plate.substring(6)}';
      }
      return '${plate.substring(0, 3)}-${plate.substring(3, 6)}.${plate.substring(6, 8)}';
    } else {
      // Xe máy: 2 số + 1–2 chữ + 4–5 số
      // ex: 59AB9999 → 59AB-9999, 59AB12345 → 59AB-123.45
      if (plate.length <= 4) return plate;
      if (plate.length <= 8) {
        return '${plate.substring(0, 4)}-${plate.substring(4)}';
      }
      if (plate.length <= 10) {
        return '${plate.substring(0, 4)}-${plate.substring(4, 7)}.${plate.substring(7)}';
      }
      return '${plate.substring(0, 4)}-${plate.substring(4, 7)}.${plate.substring(7, 9)}';
    }
  }
}
