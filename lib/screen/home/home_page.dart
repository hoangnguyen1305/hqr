import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hqr/common/custom_dialog.dart';
import 'package:hqr/common/custom_widget.dart';
import 'dart:async';
import 'package:hqr/contants/color_res.dart';
import 'package:hqr/contants/const_res.dart';
import 'package:hqr/contants/font_size_res.dart';
import 'package:hqr/model/bank_response.dart';
import 'package:hqr/screen/home/bloc/home_bloc.dart';
import 'package:hqr/screen/tax_code/tax_code_page.dart';
import 'package:hqr/utils/enum.dart';
import 'package:hqr/utils/input_formatter.dart';
import 'package:intl/intl.dart';
part 'widgets/time_ui.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeBloc _bloc;
  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _bloc = HomeBloc();
    _bloc.add(OnInit());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: CAppBar(
          title: 'HQR',
          centerTitle: true,
          showBackButton: false,
          actions: [
            IconButton(
              onPressed: () => TaxCodePage.navigate(context),
              icon: Icon(Icons.search_rounded, color: ColorRes.headerColor),
            ),
          ],
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
                  child: Form(
                    key: _key,
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        TimeUI(),
                        SizedBox(height: 20),
                        BlocBuilder<HomeBloc, HomeState>(
                          buildWhen:
                              (pre, cur) =>
                                  pre.bankData != cur.bankData ||
                                  pre.banks != cur.banks,
                          builder: (ctx, state) {
                            return CDropdown(
                              title: 'Ngân hàng',
                              getName: (e) => e.shortName,
                              getUrl: (e) => e.logo,
                              context: context,
                              items: state.banks,
                              selectedValue: state.bankData,
                              onChanged: (val) {
                                if (val != null && val is BankData) {
                                  _bloc.add(OnChangeBank(val));
                                }
                              },
                            );
                          },
                        ),
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: BlocSelector<HomeBloc, HomeState, QrType>(
                                selector: (state) => state.qrType,
                                builder: (ctx, qrType) {
                                  return CDropdown(
                                    title: 'Loại QR',
                                    getName: (e) => e.key,
                                    getUrl: (e) => '',
                                    context: context,
                                    items: QrType.values,
                                    selectedValue: qrType,
                                    onChanged: (val) {
                                      if (val != null && val is QrType) {
                                        _bloc.add(OnChangeQrType(val));
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CTextFormField(
                                title: 'STK',
                                isRequired: true,
                                hintText: 'Nhập STK',
                                controller: _bloc.accountNoEC,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CTextFormField(
                                title: 'Tên chủ TK',
                                isRequired: true,
                                hintText: 'Nhập tên chủ TK',
                                controller: _bloc.accountNameEC,
                                inputFormatters: [UpperCaseInputFormatter()],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CTextFormField(
                                title: 'Số tiền',
                                isRequired: true,
                                hintText: 'Nhập số tiền',
                                controller: _bloc.amountEC,
                                inputFormatters: [NormalPriceInputFormatter()],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        CTextFormField(
                          title: 'Mô tả',
                          isRequired: true,
                          hintText: 'Nhập mô tả',
                          controller: _bloc.descEC,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              BlocSelector<HomeBloc, HomeState, ScreenState>(
                selector: (state) => state.screenState,
                builder: (ctx, screenState) {
                  return CButton(
                    text: 'Tạo QR',
                    isLoading: screenState.isLoading,
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if (_key.currentState?.validate() ?? false) {
                        _bloc.add(
                          OnGenarateQr(
                            onSuccess: (res) {
                              String base64String = res.split(',').last;
                              Uint8List imageBytes = base64Decode(base64String);
                              CDialogConfirm.show(
                                context: context,
                                title: 'Vui lòng quét QR để thanh toán',
                                content: Image.memory(imageBytes),
                              );
                            },
                            onError: (error) {
                              CDialogConfirm.show(
                                context: context,
                                title: 'Vui lòng quét QR để thanh toán',
                                content: CText(
                                  text: error,
                                  textAlign: TextAlign.center,
                                  fontSize: FontSizeRes.body,
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  );
                },
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }
}
