import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hqr/model/traffic_response.dart';
import 'package:hqr/service/api_service.dart';
import 'package:hqr/utils/enum.dart';

part 'fines_event.dart';
part 'fines_state.dart';

class FinesBloc extends Bloc<FinesEvent, FinesState> {
  FinesBloc() : super(FinesState()) {
    on<OnSearch>(_onSearch);
    on<OnChangeDeviceType>(_onChangeDeviceType);
  }

  final plateEC = TextEditingController();

  void _onChangeDeviceType(OnChangeDeviceType event, Emitter<FinesState> emit) {
    if (event.deviceType == state.deviceType) {
      return;
    }
    plateEC.clear();
    emit(state.copyWith(deviceType: event.deviceType));
  }

  Future<void> _onSearch(OnSearch event, Emitter<FinesState> emit) async {
    emit(state.copyWith(screenState: ScreenState.loading));
    final mst = await ApiService().getTrafficViolations(
      body: {'licensePlate': plateEC.text, 'trafficType': state.deviceType.idx},
    );
    emit(state.copyWith(screenState: ScreenState.success));
    event.onSuccess.call(mst);
  }
}
