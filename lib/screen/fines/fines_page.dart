import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hqr/common/custom_dialog.dart';
import 'package:hqr/common/custom_widget.dart';
import 'package:hqr/contants/color_res.dart';
import 'package:hqr/contants/const_res.dart';
import 'package:hqr/contants/font_size_res.dart';
import 'package:hqr/model/traffic_response.dart';
import 'package:hqr/screen/fines/bloc/fines_bloc.dart';
import 'package:hqr/utils/enum.dart';
import 'package:hqr/utils/input_formatter.dart';

class FinesPage extends StatefulWidget {
  const FinesPage({super.key});

  static void navigate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FinesPage()),
    );
  }

  @override
  State<FinesPage> createState() => _FinesPageState();
}

class _FinesPageState extends State<FinesPage> {
  late final FinesBloc _bloc;

  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _bloc = FinesBloc();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: CAppBar(title: 'Tra cứu phạt nguội', centerTitle: true),
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
                BlocSelector<FinesBloc, FinesState, DeviceType>(
                  selector: (state) => state.deviceType,
                  builder: (ctx, deviceType) {
                    return CTextFormField(
                      controller: _bloc.plateEC,
                      title: 'Biển số',
                      isRequired: true,
                      hintText: 'Nhập biển số',
                      inputFormatters: [
                        PlateNumberFormatter(isCar: deviceType.isCar),
                        LicensePlateFormatter(isCar: deviceType.isCar),
                      ],
                      validator: (_) => _plateValidator(deviceType.isCar),
                      onSubmitted: (_) => _onSubmit(),
                    );
                  },
                ),
                const SizedBox(height: ConstRes.defaultVertical),
                BlocSelector<FinesBloc, FinesState, DeviceType>(
                  selector: (state) => state.deviceType,
                  builder: (ctx, deviceType) {
                    return CDropdown(
                      title: 'Loại phương tiện',
                      getName: (e) => e.title,
                      getUrl: (e) => '',
                      context: context,
                      items: DeviceType.values,
                      selectedValue: deviceType,
                      onChanged: (val) {
                        if (val != null && val is DeviceType) {
                          _bloc.add(OnChangeDeviceType(val));
                        }
                      },
                    );
                  },
                ),
                Spacer(),
                BlocBuilder<FinesBloc, FinesState>(
                  builder: (ctx, state) {
                    return CButton(
                      text: 'Kiểm tra',
                      isLoading: state.screenState.isLoading,
                      onPressed: _onSubmit,
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

  void _onSubmit() {
    if (_key.currentState?.validate() ?? false) {
      _bloc.add(
        OnSearch(
          onSuccess: (listViolation) {
            CDialogConfirm.show(
              context: context,
              title: 'Thông tin phạt nguội',
              showClose: true,
              content: _buildListViolations(
                listViolation,
                _bloc.state.deviceType,
              ),
              confirmText: 'Đồng ý',
              onConfirm: () {
                Navigator.pop(context);
              },
            );
          },
        ),
      );
    }
  }

  Widget _buildViolation(TrafficViolations violation, DeviceType deviceType) {
    return Container(
      decoration: BoxDecoration(
        color: ColorRes.backgroundWhiteColor,
        borderRadius: BorderRadius.circular(ConstRes.defaultRadius),
        border: Border.all(color: ColorRes.grey, width: 1),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: ConstRes.defaultHorizontal,
        vertical: ConstRes.defaultVertical,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: CText(
                  text: 'Vi phạm giao thông',
                  color: ColorRes.textColor,
                  fontSize: FontSizeRes.body,
                  fontWeight: FontWeight.w600,
                  maxLines: 3,
                ),
              ),
              const SizedBox(width: ConstRes.defaultHorizontal),
              Container(
                decoration: BoxDecoration(
                  color: ColorRes.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ConstRes.defaultRadius),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: ConstRes.defaultHorizontal,
                  vertical: ConstRes.defaultVertical,
                ),
                child: CText(
                  text: violation.violationStatus.toUpperCase(),
                  color: ColorRes.textColor,
                  fontSize: FontSizeRes.body,
                  fontWeight: FontWeight.w600,
                  maxLines: 20,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: ConstRes.defaultVertical),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: CText(
                  text: 'Loại phương tiện',
                  color: ColorRes.textColor,
                  fontSize: FontSizeRes.body,
                  fontWeight: FontWeight.w600,
                  maxLines: 10,
                ),
              ),
              const SizedBox(width: ConstRes.defaultHorizontal),
              CText(
                text: deviceType.title,
                color: ColorRes.textColor,
                fontSize: FontSizeRes.body,
                fontWeight: FontWeight.w600,
                maxLines: 20,
              ),
            ],
          ),
          const SizedBox(height: ConstRes.defaultVertical),
          _buildContent(title: 'Lỗi vi phạm', content: violation.description),
          const SizedBox(height: ConstRes.defaultVertical),
          _buildContent(
            title: 'Thời gian vi phạm',
            content: violation.violationTime,
          ),
          const SizedBox(height: ConstRes.defaultVertical),
          _buildContent(title: 'Địa điểm vi phạm', content: violation.location),
          const SizedBox(height: ConstRes.defaultVertical),
          _buildContent(
            title: 'Đơn vị phát hiện',
            content: violation.detectionAgency,
          ),
          const SizedBox(height: ConstRes.defaultVertical),
          _buildContent(
            title: 'Đơn vị xử phạt',
            content: violation.enforcementAgency,
          ),
        ],
      ),
    );
  }

  Widget _buildContent({required String title, required String content}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: CText(
            text: '$title: ',
            color: ColorRes.textColor,
            fontSize: FontSizeRes.body,
            fontWeight: FontWeight.w600,
            maxLines: 10,
          ),
        ),
        const SizedBox(width: ConstRes.defaultHorizontal),
        Expanded(
          flex: 2,
          child: CText(
            text: content,
            color: ColorRes.textColor,
            fontSize: FontSizeRes.body,
            fontWeight: FontWeight.w400,
            maxLines: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildListViolations(
    List<TrafficViolations> violations,
    DeviceType deviceType,
  ) {
    if (violations.isEmpty) {
      return CText(
        text:
            '🎉 Chúc mừng! Biển số ${_formatPlate(_bloc.plateEC.text, isCar: deviceType.isCar)} không có vi phạm phạt nguội.',
        textAlign: TextAlign.center,
        fontSize: FontSizeRes.body,
        maxLines: 10,
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: ConstRes.defaultVertical,
          children: List.generate(violations.length, (index) {
            return _buildViolation(violations[index], deviceType);
          }),
        ),
      );
    }
  }

  String? _plateValidator(bool isCar) {
    final value = _bloc.plateEC.text.replaceAll('-', '').replaceAll('.', '');
    if (value.isEmpty) {
      return 'Vui lòng nhập biển số xe';
    }

    final plate = value.toUpperCase().replaceAll(RegExp(r'\s|-'), '');

    // Ô tô: 2 số + 1 chữ + 4 hoặc 5 số  → ví dụ: 30A12345, 51B5678
    final carRegex = RegExp(r'^[0-9]{2}[A-Z]{1}[0-9]{4,5}$');

    // Xe máy: 2 số + (2 chữ hoặc 1 chữ + 1 số) + 4 hoặc 5 số
    // Ví dụ: 59AB12345, 59C112345
    final bikeRegex = RegExp(
      r'^[0-9]{2}([A-Z]{2}|[A-Z]{1}[0-9]{1})[0-9]{4,5}$',
    );

    if (isCar && !carRegex.hasMatch(plate)) {
      return 'Biển số ô tô không hợp lệ';
    }

    if (!isCar && !bikeRegex.hasMatch(plate)) {
      return 'Biển số xe máy không hợp lệ';
    }

    return null;
  }

  String _formatPlate(String plate, {bool isCar = false}) {
    final value = _bloc.plateEC.text.replaceAll('-', '').replaceAll('.', '');
    if (isCar) {
      if (value.substring(3).length > 4) {
        return '${value.substring(0, 3)}-${value.substring(3, 6)}.${value.substring(6)}';
      } else {
        return '${value.substring(0, 3)}-${value.substring(3)}';
      }
    } else {
      if (value.substring(4).length > 4) {
        return '${value.substring(0, 4)}-${value.substring(4, 7)}.${value.substring(7)}';
      } else {
        return '${value.substring(0, 4)}-${value.substring(4)}';
      }
    }
  }
}
