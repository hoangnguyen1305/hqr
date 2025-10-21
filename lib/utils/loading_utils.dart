import 'package:flutter/material.dart';
import 'package:hqr/common/custom_widget.dart';
import 'package:hqr/contants/color_res.dart';
import 'package:hqr/contants/const_res.dart';
import 'package:hqr/contants/font_size_res.dart';
import 'package:hqr/utils/app_key_global.dart';

class LoadingUtils {
  static Future<void> showLoading({String? title}) {
    final context = AppKeyGlobal.navigatorKey.currentState?.overlay?.context;
    if (context == null || context.mounted == false) {
      return Future.value();
    }
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: GestureDetector(
            onLongPress: () {
              Navigator.of(context).pop();
            },
            child: AlertDialog(
              backgroundColor: ColorRes.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ConstRes.defaultRadius),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        ColorRes.primaryColor,
                      ),
                      strokeWidth: 4,
                    ),
                  ),
                  const SizedBox(height: ConstRes.defaultVertical),
                  CText(
                    text: title ?? 'Loading',
                    color: ColorRes.headerColor,
                    fontSize: FontSizeRes.subBody,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void hideLoading() {
    final context = AppKeyGlobal.navigatorKey.currentState?.overlay?.context;
    if (context != null) {
      Navigator.of(context).pop();
    }
  }
}
