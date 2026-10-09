import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hqr/model/plate_response.dart';
import 'package:hqr/model/province_response.dart';
import 'package:hqr/service/api_service.dart';
import 'package:hqr/utils/enum.dart';

part 'doul_event.dart';
part 'doul_state.dart';

class DoulBloc extends Bloc<DoulEvent, DoulState> {
  DoulBloc({ApiService? apiService})
    : _apiService = apiService ?? ApiService(),
      super(
        DoulState(
          selectedProvince: ProvinceModel.all(),
          provinces: [ProvinceModel.all()],
        ),
      ) {
    on<DoulStarted>(_onStarted);
    on<DoulFilterChanged>(_onFilterChanged);
  }

  static const int _page = 1;
  static const int _take = 50;

  final ApiService _apiService;
  late final Future<List<ProvinceModel>> _provincesRequest =
      _apiService.getListProvince();
  int _requestId = 0;

  Future<void> _onStarted(DoulStarted event, Emitter<DoulState> emit) async {
    await _loadPlates(emit);
  }

  Future<void> _onFilterChanged(
    DoulFilterChanged event,
    Emitter<DoulState> emit,
  ) async {
    emit(
      state.copyWith(
        vehicleType: event.vehicleType,
        plateColor: event.plateColor,
        selectedProvince: event.selectedProvince,
        plateNumber: event.plateNumber,
      ),
    );
    await _loadPlates(emit);
  }

  Future<void> _loadPlates(Emitter<DoulState> emit) async {
    final requestId = ++_requestId;
    emit(state.copyWith(screenState: ScreenState.loading));

    try {
      final commonParams = <String, dynamic>{
        'page': _page,
        'take': _take,
        'vehicle': state.vehicleType.keys,
        if (!state.plateColor.isAll && state.vehicleType.isCar)
          'color': state.plateColor.idx,
        'q': state.plateNumber,
        if (!state.selectedProvince.isAll)
          'provinceCode': state.selectedProvince.code,
      };

      final responses = await Future.wait([
        _provincesRequest,
        _apiService.searchPlates(param: commonParams),
        _apiService.resultPlates(
          param: {
            ...commonParams,
            'sortBy': 'auction_time',
            'sortOrder': SortBy.desc.keys,
          },
        ),
      ]);

      if (requestId != _requestId) return;

      final provinces = responses[0] as List<ProvinceModel>;
      final listPlates = responses[1] as PlateResponse;
      final resultPlates = responses[2] as PlateResponse;

      emit(
        state.copyWith(
          screenState: ScreenState.success,
          provinces: [ProvinceModel.all(), ...provinces],
          listPlates: listPlates.data,
          resultPlates: resultPlates.data,
        ),
      );
    } catch (_) {
      if (requestId == _requestId) {
        emit(state.copyWith(screenState: ScreenState.failure));
      }
    }
  }
}
