import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hqr/common/custom_dialog.dart';
import 'package:hqr/common/custom_widget.dart';
import 'package:hqr/contants/color_res.dart';
import 'package:hqr/contants/const_res.dart';
import 'package:hqr/contants/font_size_res.dart';
import 'package:hqr/model/mst_response.dart';
import 'package:hqr/screen/tax_code/bloc/tax_code_bloc.dart';

class TaxCodePage extends StatefulWidget {
  const TaxCodePage({super.key});

  @override
  State<TaxCodePage> createState() => _TaxCodePageState();

  static Future<dynamic> navigate(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TaxCodePage()),
    );
  }
}

class _TaxCodePageState extends State<TaxCodePage> {
  late final TaxCodeBloc _bloc;
  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _bloc = TaxCodeBloc();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: CAppBar(title: 'Mã số thuế', centerTitle: true),
        backgroundColor: ColorRes.backgroundWhiteColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: ConstRes.defaultHorizontal,
            vertical: ConstRes.defaultVertical,
          ),
          child: Form(
            key: _key,
            child: Column(
              children: [
                Spacer(),
                CTextFormField(
                  controller: _bloc.taxEC,
                  title: 'Mã số thuế',
                  isRequired: true,
                  hintText: 'Nhập mã số thuế',
                ),
                Spacer(),
                BlocBuilder<TaxCodeBloc, TaxCodeState>(
                  builder: (ctx, state) {
                    return CButton(
                      text: 'Kiểm tra',
                      isLoading: state.screenState.isLoading,
                      onPressed: () {
                        if (_key.currentState?.validate() ?? false) {
                          _bloc.add(
                            OnSearch(
                              onSuccess: (mst) {
                                CDialogConfirm.show(
                                  context: context,
                                  title: 'Thông tin công ty',
                                  content: _buildMST(mst),
                                  confirmText: 'Đồng ý',
                                  onConfirm: () {
                                    Navigator.pop(context);
                                  },
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
      ),
    );
  }

  Widget _buildMST(MSTData mst) {
    if (mst.id.isEmpty) {
      return CText(
        text: 'Tax not found - Mã số thuế không tồn tại',
        textAlign: TextAlign.center,
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: 'MST: ',
              children: [
                TextSpan(
                  text: mst.id,
                  style: TextStyle(
                    color: ColorRes.textColor,
                    fontSize: FontSizeRes.body,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.left,
            style: TextStyle(
              color: ColorRes.textColor,
              fontSize: FontSizeRes.body,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10),
          Text.rich(
            TextSpan(
              text: 'Tên công ty: ',
              children: [
                TextSpan(
                  text: mst.name,
                  style: TextStyle(
                    color: ColorRes.textColor,
                    fontSize: FontSizeRes.body,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            style: TextStyle(
              color: ColorRes.textColor,
              fontSize: FontSizeRes.body,
              fontWeight: FontWeight.w400,
            ),
          ),
          if (mst.internationalName.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text.rich(
              TextSpan(
                text: 'Tên công ty (EN): ',
                children: [
                  TextSpan(
                    text: mst.internationalName,
                    style: TextStyle(
                      color: ColorRes.textColor,
                      fontSize: FontSizeRes.body,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              style: TextStyle(
                color: ColorRes.textColor,
                fontSize: FontSizeRes.body,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
          if (mst.shortName.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text.rich(
              TextSpan(
                text: 'Tên công ty (rút gọn): ',
                children: [
                  TextSpan(
                    text: mst.shortName,
                    style: TextStyle(
                      color: ColorRes.textColor,
                      fontSize: FontSizeRes.body,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              style: TextStyle(
                color: ColorRes.textColor,
                fontSize: FontSizeRes.body,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
          const SizedBox(height: 10),
          Text.rich(
            TextSpan(
              text: 'Địa chỉ: ',
              children: [
                TextSpan(
                  text: mst.address,
                  style: TextStyle(
                    color: ColorRes.textColor,
                    fontSize: FontSizeRes.body,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            style: TextStyle(
              color: ColorRes.textColor,
              fontSize: FontSizeRes.body,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      );
    }
  }
}
