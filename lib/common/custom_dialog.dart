import 'package:flutter/material.dart';
import 'package:hqr/common/custom_widget.dart';
import 'package:hqr/contants/color_res.dart';
import 'package:hqr/contants/const_res.dart';
import 'package:hqr/contants/font_size_res.dart';

class CBottomSheet {
  static Future<void> show({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ConstRes.defaultRadius),
        ),
      ),
      backgroundColor: ColorRes.backgroundWhiteColor,
      builder: (BuildContext context) {
        return SafeArea(
          top: false,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8 + 30,
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.only(top: 10),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: ColorRes.grey,
                    borderRadius: BorderRadius.all(
                      Radius.circular(ConstRes.defaultRadius),
                    ),
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.8,
                  ),
                  padding: const EdgeInsets.only(
                    left: ConstRes.defaultHorizontal,
                    right: ConstRes.defaultHorizontal,
                    top: ConstRes.defaultVertical,
                  ),
                  child: child,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CDialogConfirm {
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required Widget content,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = false,
    bool showClose = true,
    bool isCenterButton = true,
    bool titleAlignCenter = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return PopScope(
          canPop: barrierDismissible,
          child: Dialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: ConstRes.defaultHorizontal,
            ),
            backgroundColor: ColorRes.backgroundWhiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ConstRes.defaultRadius),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    if (showClose) const SizedBox(width: 15),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: ConstRes.defaultVertical,
                        ),
                        child: CText(
                          text: title,
                          fontWeight: FontWeight.w600,
                          fontSize: FontSizeRes.subHeader - 1,
                          maxLines: 2,
                          textAlign:
                              titleAlignCenter
                                  ? TextAlign.center
                                  : TextAlign.left,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 10, color: ColorRes.grey),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ConstRes.defaultHorizontal,
                    vertical: ConstRes.defaultVertical,
                  ),
                  child: content,
                ),
                const Divider(height: 10, color: ColorRes.grey),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ConstRes.defaultHorizontal,
                    vertical: ConstRes.defaultVertical,
                  ),
                  child: Row(
                    mainAxisAlignment:
                        isCenterButton
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.end,
                    children: [
                      if (onCancel != null)
                        CButton(
                          text: cancelText ?? 'Huỷ',
                          onPressed: () {
                            onCancel.call();
                          },
                          backgroundColor: ColorRes.backgroundWhiteColor,
                          textColor: ColorRes.primaryColor,
                          fontSize: FontSizeRes.subBody,
                        ),
                      const SizedBox(width: 10),
                      CButton(
                        text: confirmText ?? 'Ok',
                        fontSize: FontSizeRes.subBody,
                        onPressed: () {
                          if (onConfirm != null) {
                            onConfirm.call();
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                        backgroundColor: ColorRes.primaryColor,
                        textColor: ColorRes.headerColor,
                        showBorder: false,
                      ),
                    ],
                  ),
                ),
                // const SizedBox(height: 5),
              ],
            ),
          ),
        );
      },
    );
  }
}
