import 'package:flutter/material.dart';
import 'package:hqr/common/custom_widget.dart';
import 'dart:async';
import 'package:hqr/contants/color_res.dart';
import 'package:hqr/contants/const_res.dart';
import 'package:hqr/contants/font_size_res.dart';
import 'package:hqr/screen/fines/fines_page.dart';
import 'package:hqr/screen/gen_qr/gen_qr_page.dart';
import 'package:hqr/screen/list_plate/list_plate_page.dart';
import 'package:hqr/screen/result_plate/result_plate_page.dart';
import 'package:hqr/screen/tax_code/tax_code_page.dart';
import 'package:intl/intl.dart';
part 'widgets/time_ui.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CAppBar(
        title: 'Super Hidro',
        centerTitle: true,
        showBackButton: false,
      ),
      backgroundColor: ColorRes.backgroundWhiteColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: ConstRes.defaultHorizontal,
          vertical: ConstRes.defaultVertical,
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    TimeUI(),
                    SizedBox(height: 20),
                    Center(
                      child: Column(
                        children: [
                          _buildItemMenu(
                            title: 'Tạo QR thanh toán',
                            icon: Icons.qr_code,
                            onTap: () => GenQRPage.navigate(context),
                          ),
                          SizedBox(height: ConstRes.defaultVertical),
                          _buildItemMenu(
                            title: 'Mã số thuế',
                            icon: Icons.numbers_rounded,
                            onTap: () => TaxCodePage.navigate(context),
                          ),
                          SizedBox(height: ConstRes.defaultVertical),
                          _buildItemMenu(
                            title: 'Kiểm tra phạt nguội',
                            icon: Icons.price_check_rounded,
                            onTap: () => FinesPage.navigate(context),
                          ),
                          SizedBox(height: ConstRes.defaultVertical),
                          _buildItemMenu(
                            title: 'Danh sách biển số',
                            icon: Icons.list,
                            onTap: () => ListPlatePage.navigate(context),
                          ),
                          SizedBox(height: ConstRes.defaultVertical),
                          _buildItemMenu(
                            title: 'Kết quả đấu giá',
                            icon: Icons.wysiwyg_rounded,
                            onTap: () => ResultPlatePage.navigate(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildItemMenu({
    required String title,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: ColorRes.backgroundWhiteColor,
          borderRadius: BorderRadius.circular(ConstRes.defaultRadius),
          border: Border.all(color: ColorRes.grey, width: 1),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: ConstRes.defaultHorizontal,
          vertical: ConstRes.defaultVertical,
        ),
        width: double.infinity,
        child: Column(
          children: [
            Icon(icon),
            const SizedBox(height: ConstRes.defaultVertical),
            CText(text: title, fontSize: FontSizeRes.subHeader),
          ],
        ),
      ),
    );
  }
}
