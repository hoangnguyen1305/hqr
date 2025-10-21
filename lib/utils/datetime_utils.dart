import 'package:flutter/material.dart';
import 'package:hqr/common/custom_dialog.dart';
import 'package:hqr/common/custom_widget.dart';
import 'package:hqr/contants/color_res.dart';
import 'package:hqr/contants/const_res.dart';
import 'package:hqr/contants/font_size_res.dart';
import 'package:intl/intl.dart';

class DateTimeUtils {
  static const String customFormat = 'yyyy-MM-dd HH-mm-ss';

  static const String formatDate = 'yyyy-MM-dd';
  static const String formatDateFull = 'HH:mm yyyy-MM-dd';

  static String getStringDateApi(DateTime? dateTime) {
    return dateTime != null ? DateFormat(formatDate).format(dateTime) : '';
  }

  static String getStringDate(DateTime? date) {
    try {
      if (date == null) return '';
      return DateFormat(formatDate).format(date);
    } catch (_) {
      return '';
    }
  }

  static String getFullDateTime(DateTime? date) {
    try {
      if (date == null) return '';
      return DateFormat(formatDateFull).format(date);
    } catch (_) {
      return '';
    }
  }

  static DateTime? getDateTime(String? date) {
    try {
      if (date == null || date.isEmpty) return null;
      if (date.contains('Z')) {
        return DateTime.parse(date).toLocal();
      }
      return DateTime.parse(date);
    } catch (_) {
      try {
        if (date == null || date.isEmpty) return null;
        if (date.contains('Z')) {
          return DateFormat(customFormat).parse(date).toLocal();
        }
        return DateFormat(customFormat).parse(date);
      } catch (_) {
        return null;
      }
    }
  }

  static DateTime get getDateNow {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, now.hour, now.minute);
  }

  static DateTime get getDateNowStart {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 0, 0, 0);
  }

  static DateTime get getDateNowEnd {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 23, 59, 59);
  }

  static Future<DateTime?> pickerDate({
    required BuildContext context,
    DateTime? initialDate,
    required String title,
    DateTime? minDate,
    DateTime? maxDate,
  }) async {
    DateTime? selectedDate = initialDate;
    DateTime? dateResult = initialDate;
    await CBottomSheet.show(
      context: context,
      child: StatefulBuilder(
        builder: (ctx, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: CText(
                      text: title,
                      fontSize: FontSizeRes.subBody,
                      fontWeight: FontWeight.w500,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              const Divider(color: ColorRes.grey, height: 20),
              SizedBox(
                height: 250,
                child: CCustomDatePicker(
                  initialDate: selectedDate ?? getDateNow,
                  minDate:
                      minDate ??
                      DateTimeUtils.getDateNowStart.subtract(
                        const Duration(days: 36500),
                      ),
                  maxDate:
                      maxDate ??
                      DateTimeUtils.getDateNowEnd.add(
                        const Duration(days: 36500),
                      ),
                  onDateSelected: (date) {
                    selectedDate = date;
                  },
                ),
              ),
              const SizedBox(height: ConstRes.defaultVertical),
              CButton(
                text: 'Lưu',
                onPressed: () {
                  dateResult = selectedDate;
                  Navigator.pop(context);
                },
                backgroundColor: ColorRes.primaryColor,
                textColor: ColorRes.headerColor,
                showBorder: false,
              ),
            ],
          );
        },
      ),
    );
    return dateResult;
  }
}
