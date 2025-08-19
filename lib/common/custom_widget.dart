import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hqr/common/custom_dialog.dart';
import 'package:hqr/contants/color_res.dart';
import 'package:hqr/contants/const_res.dart';
import 'package:hqr/contants/font_size_res.dart';

class CDropdown<T> extends FormField<T> {
  CDropdown({
    super.key,
    required List<T> items,
    T? selectedValue,
    required Function(dynamic) onChanged,
    required String title,
    bool isRequired = false,
    required String Function(dynamic) getName,
    required String Function(dynamic) getUrl,
    double padding = 0,
    String? messageError,
    Color? backgroundColor,
    bool fromHome = false,
    super.validator,
    super.enabled,
    required BuildContext context,
  }) : super(
         builder: (FormFieldState<T> state) {
           return IgnorePointer(
             ignoring: !enabled,
             child: Padding(
               padding: EdgeInsets.symmetric(horizontal: padding),
               child: Stack(
                 children: [
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       if (fromHome) const SizedBox(height: 10),
                       if (!fromHome) ...[
                         SizedBox(
                           width: double.infinity,
                           child: Text.rich(
                             maxLines: 3,
                             textAlign: TextAlign.start,
                             TextSpan(
                               text: title,
                               style: const TextStyle(
                                 fontSize: FontSizeRes.subBody,
                                 fontWeight: FontWeight.w500,
                                 color: ColorRes.textColor,
                               ),
                               children: [
                                 if (isRequired)
                                   const TextSpan(
                                     text: ' *',
                                     style: TextStyle(
                                       color: ColorRes.red,
                                       fontSize: FontSizeRes.subBody,
                                       fontWeight: FontWeight.w500,
                                     ),
                                   ),
                               ],
                             ),
                           ),
                         ),
                         const SizedBox(height: 6),
                       ],
                       GestureDetector(
                         onTap: () {
                           CBottomSheet.show(
                             context: context,
                             child: CSelectModel(
                               items: items,
                               selectedValue: selectedValue,
                               onChanged: (val) {
                                 if (val != null && val != selectedValue) {
                                   onChanged(val);
                                   state.didChange(val);
                                 }
                               },
                               title: title,
                               isBottomSheet: true,
                               getName: (e) => getName(e),
                               getUrl: (e) => getUrl(e),
                             ),
                           );
                         },
                         child: Container(
                           decoration: BoxDecoration(
                             border: Border.all(
                               color:
                                   state.hasError
                                       ? ColorRes.red
                                       : ColorRes.grey,
                               width: 1,
                             ),
                             color:
                                 backgroundColor ??
                                 (enabled
                                     ? ColorRes.backgroundWhiteColor
                                     : ColorRes.grey),
                             borderRadius: BorderRadius.circular(
                               fromHome
                                   ? ConstRes.defaultRadius
                                   : ConstRes.defaultRadius,
                             ),
                           ),
                           width: double.infinity,
                           height: 50,
                           alignment: Alignment.centerLeft,
                           child: Row(
                             children: [
                               SizedBox(width: fromHome ? 14 : 10),
                               Expanded(
                                 child: CText(
                                   text:
                                       selectedValue == null || items.isEmpty
                                           ? 'Vui lòng chọn'
                                           : getName(selectedValue),
                                   textAlign: TextAlign.start,
                                   fontSize:
                                       selectedValue == null
                                           ? FontSizeRes.subBody
                                           : FontSizeRes.body,
                                   color:
                                       selectedValue == null
                                           ? ColorRes.grey
                                           : ColorRes.textColor,
                                   fontWeight:
                                       selectedValue == null
                                           ? FontWeight.w400
                                           : FontWeight.w500,
                                   maxLines: 2,
                                 ),
                               ),
                               const SizedBox(width: 10),
                               Icon(
                                 Icons.expand_more_rounded,
                                 color: ColorRes.subTextColor,
                                 size: 25,
                               ),
                               const SizedBox(width: 5),
                             ],
                           ),
                         ),
                       ),
                       if (state.hasError)
                         Padding(
                           padding: const EdgeInsets.only(top: 5),
                           child: CText(
                             text: state.errorText!,
                             color: ColorRes.red,
                             fontSize: FontSizeRes.subBody - 2,
                           ),
                         ),
                     ],
                   ),
                   if (fromHome)
                     Positioned(
                       left: 10,
                       top: 0,
                       child: Container(
                         color: Colors.white,
                         padding: const EdgeInsets.symmetric(horizontal: 4),
                         child: Text.rich(
                           maxLines: 3,
                           textAlign: TextAlign.start,
                           TextSpan(
                             text: title,
                             style: const TextStyle(
                               fontSize: FontSizeRes.subBody,
                               fontWeight: FontWeight.w300,
                               color: ColorRes.subTextColor,
                             ),
                             children: [
                               if (isRequired)
                                 const TextSpan(
                                   text: ' *',
                                   style: TextStyle(
                                     color: ColorRes.red,
                                     fontSize: FontSizeRes.subBody,
                                     fontWeight: FontWeight.w600,
                                   ),
                                 ),
                             ],
                           ),
                         ),
                       ),
                     ),
                 ],
               ),
             ),
           );
         },
       );
}

class CTextFormField extends StatefulWidget {
  final String title;
  final bool isRequired;
  final TextEditingController? controller;
  final String hintText;
  final double padding;
  final bool isPassword;
  final String? initValue;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final List<TextInputFormatter> inputFormatters;
  final int? maxLength;
  final TextInputType? keyboardType;
  final bool enabled;
  final int maxLines;
  final Color? backgroundColor;
  final double size;
  final bool isCurrency;
  final bool showTitle;
  final String tooltip;
  final Widget? tooltipWidget;
  final TextInputAction? textInputAction;

  const CTextFormField({
    super.key,
    required this.title,
    required this.isRequired,
    this.controller,
    this.padding = 0,
    this.hintText = '',
    this.isPassword = false,
    this.initValue,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.validator,
    this.inputFormatters = const [],
    this.maxLength,
    this.keyboardType,
    this.enabled = true,
    this.maxLines = 1,
    this.backgroundColor,
    this.size = FontSizeRes.subBody,
    this.isCurrency = false,
    this.showTitle = true,
    this.tooltip = '',
    this.tooltipWidget,
    this.textInputAction,
  });

  @override
  State<CTextFormField> createState() => _CTextFormFieldState();
}

class _CTextFormFieldState extends State<CTextFormField> {
  bool isObscure = true;
  late Widget textForm;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showTitle) ...[
          Text.rich(
            maxLines: 10,
            TextSpan(
              text: widget.title,
              style: TextStyle(
                fontSize: widget.size,
                fontWeight: FontWeight.w500,
                color: ColorRes.textColor,
              ),
              children: [
                if (widget.isRequired)
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                      fontSize: widget.size,
                      fontWeight: FontWeight.w500,
                      color: ColorRes.red,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
        ],
        TextFormField(
          readOnly: !widget.enabled,
          obscureText: widget.isPassword && isObscure,
          initialValue: widget.initValue,
          onChanged: widget.onChanged,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: (val) {
            widget.onSubmitted?.call(val);
          },
          focusNode: widget.focusNode,
          inputFormatters: widget.inputFormatters,
          maxLength: widget.maxLength,
          keyboardType: widget.keyboardType,
          enabled: widget.enabled,
          maxLines: widget.maxLines,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          validator:
              widget.validator ??
              (value) {
                if (widget.isRequired &&
                    widget.controller != null &&
                    widget.controller!.text.isNotEmpty) {
                  return null;
                }
                if (widget.isRequired && (value == null || value.isEmpty)) {
                  return 'Bắt buộc nhập';
                }
                return null;
              },
          style: const TextStyle(
            fontSize: FontSizeRes.body,
            color: ColorRes.textColor,
          ),
          decoration: InputDecoration(
            errorMaxLines: 2,
            filled: true,
            fillColor:
                widget.backgroundColor ??
                (widget.enabled
                    ? ColorRes.backgroundWhiteColor
                    : ColorRes.grey),
            disabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(ConstRes.defaultRadius),
              ),
              borderSide: BorderSide(color: ColorRes.grey, width: 1),
            ),
            hintStyle: const TextStyle(
              color: ColorRes.grey,
              fontSize: FontSizeRes.subBody,
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(ConstRes.defaultRadius),
              ),
              borderSide: BorderSide(color: ColorRes.grey, width: 1),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(ConstRes.defaultRadius),
              ),
              borderSide: BorderSide(color: ColorRes.grey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ConstRes.defaultRadius),
              borderSide: const BorderSide(color: ColorRes.grey, width: 1),
            ),
            errorStyle: const TextStyle(
              color: ColorRes.red,
              fontSize: FontSizeRes.subBody - 2,
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(ConstRes.defaultRadius),
              ),
              borderSide: BorderSide(color: ColorRes.red, width: 1),
            ),
            counterText: '',
            hintText:
                widget.hintText.isEmpty ? 'Nhập dữ liệu' : widget.hintText,
            prefix: const Padding(
              padding: EdgeInsets.only(left: 10),
              child: SizedBox(),
            ),
            suffix: const Padding(padding: EdgeInsets.only(right: 10)),
            contentPadding: const EdgeInsets.symmetric(vertical: 12.5),
            isDense: true,
            suffixIcon:
                widget.isPassword
                    ? IconButton(
                      icon: Icon(
                        isObscure
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                      ),
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                    )
                    : null,
          ),
          controller: widget.controller,
        ),
      ],
    );
  }
}

class CSelectModel<T> extends StatefulWidget {
  final List<T> items;
  final T? selectedValue;
  final Function(dynamic) onChanged;
  final String Function(dynamic) getName;
  final String? title;
  final String? hintText;
  final String Function(dynamic) getUrl;
  final bool isBottomSheet;

  const CSelectModel({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    required this.getName,
    this.title,
    this.hintText,
    required this.getUrl,
    this.isBottomSheet = false,
  });

  @override
  State<CSelectModel<T>> createState() => _CSelectModelState<T>();
}

class _CSelectModelState<T> extends State<CSelectModel<T>> {
  List<T> items = [];

  @override
  void initState() {
    super.initState();
    items = widget.items;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CText(
            text: widget.title ?? 'Vui lòng chọn',
            fontSize: FontSizeRes.body,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 15),
          const Divider(color: ColorRes.grey, height: 1),
          ...List.generate(items.length, (i) {
            final e = items[i];
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
                widget.onChanged.call(e);
              },
              behavior: HitTestBehavior.translucent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      if (widget.getUrl(e).isNotEmpty) ...[
                        CachedNetworkImage(
                          imageUrl: widget.getUrl(e),
                          width: 60,
                          fit: BoxFit.fitWidth,
                        ),
                        const SizedBox(width: 10),
                      ],
                      Expanded(
                        child: CText(
                          text: widget.getName(e),
                          fontSize: FontSizeRes.subBody,
                          color: ColorRes.textColor,
                          fontWeight: FontWeight.w500,
                          maxLines: 2,
                        ),
                      ),
                      if (widget.selectedValue == e)
                        const Icon(
                          Icons.check_circle_rounded,
                          color: ColorRes.green,
                        ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Divider(color: ColorRes.grey, height: 1),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class CSearchTextField extends StatefulWidget {
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final String? hintText;
  final Function(String) onSearch;
  final Color? backgroundColor;
  final Widget? icon;

  const CSearchTextField({
    super.key,
    this.focusNode,
    this.inputFormatters,
    this.hintText,
    required this.onSearch,
    this.backgroundColor,
    this.icon,
  });

  @override
  State<StatefulWidget> createState() => _CSearchTextFieldState();
}

class _CSearchTextFieldState extends State<CSearchTextField> {
  final TextEditingController _controller = TextEditingController();
  bool hasClose = false;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (val) {
        if (val.isEmpty) {
          hasClose = false;
        } else {
          hasClose = true;
        }
        setState(() {});
        if (_debounce?.isActive ?? false) _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 1000), () {
          widget.onSearch.call(val);
        });
      },
      onFieldSubmitted: (val) {
        FocusScope.of(context).unfocus();
        widget.onSearch.call(val);
      },
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      focusNode: widget.focusNode,
      inputFormatters: widget.inputFormatters,
      style: const TextStyle(
        fontSize: FontSizeRes.body,
        color: ColorRes.textColor,
      ),
      decoration: InputDecoration(
        fillColor: widget.backgroundColor,
        filled: widget.backgroundColor != null,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(ConstRes.defaultRadius),
          ),
          borderSide: BorderSide(color: ColorRes.grey, width: 1),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(ConstRes.defaultRadius),
          ),
          borderSide: BorderSide(color: ColorRes.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ConstRes.defaultRadius),
          borderSide: const BorderSide(color: ColorRes.grey, width: 1),
        ),
        errorStyle: const TextStyle(
          color: ColorRes.red,
          fontSize: FontSizeRes.subBody - 2,
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(ConstRes.defaultRadius),
          ),
          borderSide: BorderSide(color: ColorRes.red, width: 1),
        ),
        counterText: '',
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: ColorRes.grey,
          fontSize: FontSizeRes.subBody,
        ),
        prefix:
            widget.icon == null
                ? const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: SizedBox.shrink(),
                )
                : null,
        prefixIcon: widget.icon,
        suffix: const Padding(padding: EdgeInsets.only(right: 10)),
        contentPadding: const EdgeInsets.symmetric(vertical: 12.5),
        isDense: true,
        suffixIcon:
            hasClose
                ? IconButton(
                  icon: const Icon(Icons.close_rounded, color: ColorRes.grey),
                  onPressed: () {
                    hasClose = false;
                    _controller.clear();
                    FocusScope.of(context).unfocus();
                    setState(() {});
                    widget.onSearch.call('');
                  },
                )
                : const SizedBox.shrink(),
      ),
      controller: _controller,
    );
  }
}

class CAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subTitle;
  final bool centerTitle;
  final List<Widget>? actions;
  final Function? onBack;
  final Color? backgroundColor;
  final bool showBackButton;
  final Color? titleColor;
  final Widget? titleWidget;

  const CAppBar({
    super.key,
    required this.title,
    this.subTitle = '',
    this.centerTitle = false,
    this.actions,
    this.onBack,
    this.backgroundColor,
    this.showBackButton = true,
    this.titleColor,
    this.titleWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? ColorRes.primaryColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      titleSpacing: !showBackButton ? 15 : 0,
      title: CText(
        text: (!showBackButton ? ' ' : '') + title,
        fontSize: FontSizeRes.header,
        fontWeight: FontWeight.w600,
        color: titleColor ?? ColorRes.headerColor,
        textAlign: centerTitle ? TextAlign.center : TextAlign.start,
      ),
      centerTitle: centerTitle,
      actions: actions,
      automaticallyImplyLeading: showBackButton,
      leading:
          showBackButton
              ? IconButton(
                iconSize: 18,
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: titleColor ?? ColorRes.headerColor,
                ),
                onPressed: () {
                  if (onBack != null) {
                    onBack!.call();
                  } else {
                    Navigator.pop(context);
                  }
                },
              )
              : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final bool isDisabled;
  final bool showBorder;
  final double borderThickness;
  final bool isLoading;
  final double height;
  final FontWeight fontWeight;
  final bool isExpand;
  final Widget? suffixIcon;

  const CButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = ColorRes.primaryColor,
    this.textColor = ColorRes.headerColor,
    this.fontSize = FontSizeRes.body,
    this.isDisabled = false,
    this.showBorder = true,
    this.borderThickness = 1,
    this.isLoading = false,
    this.height = 50,
    this.fontWeight = FontWeight.w700,
    this.isExpand = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (isDisabled || isLoading) ? null : onPressed,
      borderRadius: const BorderRadius.all(
        Radius.circular(ConstRes.defaultRadius),
      ),
      child: Container(
        alignment: Alignment.center,
        height: height,
        constraints: const BoxConstraints(minWidth: 100),
        width: isExpand ? double.infinity : null,
        padding: const EdgeInsets.symmetric(
          horizontal: ConstRes.defaultHorizontal,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ConstRes.defaultRadius),
          border: Border.all(
            color:
                (isDisabled || isLoading)
                    ? backgroundColor.withValues(alpha: 0.5)
                    : (showBorder ? textColor : backgroundColor),
            width: borderThickness,
          ),
          color:
              (isDisabled || isLoading)
                  ? backgroundColor.withValues(alpha: 0.5)
                  : backgroundColor,
        ),
        child:
            isLoading
                ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      ColorRes.backgroundGreyColor,
                    ),
                    strokeWidth: 3,
                  ),
                )
                : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 2,
                  children: [
                    CText(
                      text: text,
                      textAlign: TextAlign.center,
                      fontSize: fontSize,
                      color: textColor,
                      fontWeight: fontWeight,
                      maxLines: 2,
                    ),
                    suffixIcon ?? const SizedBox(),
                  ],
                ),
      ),
    );
  }
}

class CText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign? textAlign;
  final Color color;
  final int? maxLines;
  final TextDecoration? decoration;
  final FontStyle fontStyle;
  final TextOverflow? overflow;

  const CText({
    super.key,
    required this.text,
    this.fontSize = FontSizeRes.body,
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.start,
    this.color = ColorRes.textColor,
    this.maxLines = 1,
    this.decoration = TextDecoration.none,
    this.fontStyle = FontStyle.normal,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        decoration: decoration,
        decorationColor: color,
        fontStyle: fontStyle,
      ),
    );
  }
}
