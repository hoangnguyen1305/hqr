import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hqr/common/custom_widget.dart';
import 'package:hqr/contants/color_res.dart';
import 'package:hqr/contants/const_res.dart';
import 'package:hqr/contants/font_size_res.dart';
import 'package:hqr/model/plate_response.dart';
import 'package:hqr/screen/doul/bloc/doul_bloc.dart';
import 'package:hqr/utils/currency_utils.dart';
import 'package:hqr/utils/datetime_utils.dart';
import 'package:hqr/utils/enum.dart';

part 'widgets/doul_plate_list.dart';

class ListDoulPage extends StatelessWidget {
  const ListDoulPage({super.key});

  static Future<dynamic> navigate(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ListDoulPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DoulBloc()..add(const DoulStarted()),
      child: const _DoulView(),
    );
  }
}

class _DoulView extends StatelessWidget {
  const _DoulView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CAppBar(title: 'Danh sách Doul', centerTitle: true),
      backgroundColor: ColorRes.backgroundWhiteColor,
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            ConstRes.defaultHorizontal,
            ConstRes.defaultVertical,
            ConstRes.defaultHorizontal,
            ConstRes.defaultVertical,
          ),
          child: Column(
            children: [
              const _DoulFilters(),
              const SizedBox(height: ConstRes.defaultVertical),
              Expanded(
                child: BlocBuilder<DoulBloc, DoulState>(
                  buildWhen:
                      (previous, current) =>
                          previous.screenState != current.screenState ||
                          previous.listPlates != current.listPlates,
                  builder: (context, state) {
                    return _DoulPlateList(
                      title: 'Danh sách biển số',
                      plates: state.listPlates,
                      screenState: state.screenState,
                      priceType: _DoulPriceType.starting,
                    );
                  },
                ),
              ),
              const Divider(
                height: ConstRes.defaultVertical * 2,
                color: ColorRes.grey,
                thickness: 1,
              ),
              Expanded(
                child: BlocBuilder<DoulBloc, DoulState>(
                  buildWhen:
                      (previous, current) =>
                          previous.screenState != current.screenState ||
                          previous.resultPlates != current.resultPlates,
                  builder: (context, state) {
                    return _DoulPlateList(
                      title: 'Kết quả đấu giá',
                      plates: state.resultPlates,
                      screenState: state.screenState,
                      priceType: _DoulPriceType.auction,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DoulFilters extends StatelessWidget {
  const _DoulFilters();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DoulBloc>();

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: BlocSelector<DoulBloc, DoulState, VehicleType>(
                selector: (state) => state.vehicleType,
                builder: (context, vehicleType) {
                  return CDropdown<VehicleType>(
                    items: VehicleType.values,
                    selectedValue: vehicleType,
                    onChanged:
                        (value) => bloc.add(
                          DoulFilterChanged(vehicleType: value as VehicleType),
                        ),
                    title: 'Loại xe',
                    getName: (value) => (value as VehicleType).title,
                    getUrl: (_) => '',
                    context: context,
                  );
                },
              ),
            ),
            const SizedBox(width: ConstRes.defaultHorizontal),
            Expanded(
              child: CSearchTextField(
                hintText: 'Nhập biển số',
                onSearch:
                    (value) => bloc.add(DoulFilterChanged(plateNumber: value)),
              ),
            ),
          ],
        ),
        const SizedBox(height: ConstRes.defaultVertical),
        BlocBuilder<DoulBloc, DoulState>(
          buildWhen:
              (previous, current) =>
                  previous.vehicleType != current.vehicleType ||
                  previous.plateColor != current.plateColor ||
                  previous.provinces != current.provinces ||
                  previous.selectedProvince != current.selectedProvince,
          builder: (context, state) {
            return Row(
              children: [
                if (state.vehicleType.isCar) ...[
                  Expanded(
                    child: CDropdown<PlateColor>(
                      items: PlateColor.values,
                      selectedValue: state.plateColor,
                      onChanged:
                          (value) => bloc.add(
                            DoulFilterChanged(plateColor: value as PlateColor),
                          ),
                      title: 'Loại biển số',
                      getName: (value) => (value as PlateColor).title,
                      getUrl: (_) => '',
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
                        (value) => bloc.add(
                          DoulFilterChanged(selectedProvince: value),
                        ),
                    title: 'Tỉnh/TP',
                    getName: (value) => value.name,
                    getUrl: (_) => '',
                    context: context,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
