import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hqr/common/custom_widget.dart';
import 'package:hqr/contants/color_res.dart';
import 'package:hqr/contants/const_res.dart';
import 'package:hqr/model/plate_response.dart';
import 'package:hqr/screen/result_plate/bloc/result_plate_bloc.dart';
import 'package:hqr/utils/currency_utils.dart';
import 'package:hqr/utils/datetime_utils.dart';
import 'package:hqr/utils/enum.dart';

part 'widgets/result_plate.dart';

class ResultPlatePage extends StatefulWidget {
  const ResultPlatePage({super.key});

  @override
  State<ResultPlatePage> createState() => _ResultPlatePageState();

  static Future<dynamic> navigate(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ResultPlatePage()),
    );
  }
}

class _ResultPlatePageState extends State<ResultPlatePage> {
  late final ResultPlateBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ResultPlateBloc();
    _bloc.add(OnInit());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: CAppBar(title: 'Kết quả đấu giá', centerTitle: true),
        backgroundColor: ColorRes.backgroundWhiteColor,
        body: Padding(
          padding: EdgeInsets.only(
            left: ConstRes.defaultHorizontal,
            right: ConstRes.defaultHorizontal,
            top: ConstRes.defaultVertical,
            bottom:
                ConstRes.defaultVertical +
                MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: BlocSelector<
                      ResultPlateBloc,
                      ResultPlateState,
                      VehicleType
                    >(
                      selector: (state) => state.vehicleType,
                      builder: (ctx, vehicleType) {
                        return CDropdown(
                          items: VehicleType.values,
                          selectedValue: vehicleType,
                          onChanged:
                              (val) => _bloc.add(OnSearch(vehicleType: val)),
                          title: 'Loại xe',
                          getName: (e) => e.title,
                          getUrl: (e) => '',
                          context: context,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: ConstRes.defaultHorizontal),
                  Expanded(
                    child: CSearchTextField(
                      hintText: 'Nhập biển số',
                      onSearch: (val) {
                        _bloc.add(OnSearch(plateNumber: val));
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: ConstRes.defaultVertical),
              BlocBuilder<ResultPlateBloc, ResultPlateState>(
                buildWhen:
                    (pre, cur) =>
                        pre.plateColor != cur.plateColor ||
                        pre.vehicleType != cur.vehicleType ||
                        pre.provinces != cur.provinces ||
                        pre.selectedProvince != cur.selectedProvince,
                builder: (ctx, state) {
                  return Row(
                    children: [
                      if (state.vehicleType.isCar) ...[
                        Expanded(
                          child: CDropdown(
                            items: PlateColor.values,
                            selectedValue: state.plateColor,
                            onChanged:
                                (val) => _bloc.add(OnSearch(plateColor: val)),
                            title: 'Loại biển số',
                            getName: (e) => e.title,
                            getUrl: (e) => '',
                            context: context,
                          ),
                        ),
                        const SizedBox(width: ConstRes.defaultHorizontal),
                      ],
                      Expanded(
                        child: CDropdown(
                          items: state.provinces,
                          selectedValue: state.selectedProvince,
                          onChanged:
                              (val) =>
                                  _bloc.add(OnSearch(selectedProvince: val)),
                          title: 'Tỉnh/TP',
                          getName: (e) => e.name,
                          getUrl: (e) => '',
                          context: context,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: ConstRes.defaultVertical),
              Row(
                children: [
                  Expanded(
                    child: BlocBuilder<ResultPlateBloc, ResultPlateState>(
                      buildWhen:
                          (pre, cur) =>
                              pre.startDate != cur.startDate ||
                              pre.endDate != cur.endDate,
                      builder: (ctx, state) {
                        return CInputDateForm(
                          isRequired: false,
                          title: 'Ngày bắt đầu',
                          hintText: 'Nhập ngày bắt đầu',
                          limitEndDate: true,
                          initialValue: state.startDate,
                          endDate: state.endDate,
                          context: context,
                          onSaved: (val) {
                            _bloc.add(OnSearch(startDate: val));
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: ConstRes.defaultHorizontal),
                  Expanded(
                    child: BlocBuilder<ResultPlateBloc, ResultPlateState>(
                      buildWhen:
                          (pre, cur) =>
                              pre.startDate != cur.startDate ||
                              pre.endDate != cur.endDate,
                      builder: (ctx, state) {
                        return CInputDateForm(
                          isRequired: false,
                          title: 'Ngày kết thúc',
                          hintText: 'Nhập ngày kết thúc',
                          limitStartDate: true,
                          initialValue: state.endDate,
                          startDate: state.startDate,
                          context: context,
                          onSaved: (val) {
                            _bloc.add(OnSearch(endDate: val));
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: ConstRes.defaultVertical),
              Expanded(child: ResultPlate()),
            ],
          ),
        ),
      ),
    );
  }
}
