import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hqr/model/plate_response.dart';
import 'package:hqr/model/province_response.dart';
import 'package:hqr/service/api_service.dart';
import 'package:hqr/utils/datetime_utils.dart';
import 'package:hqr/utils/enum.dart';

part 'list_plate_event.dart';
part 'list_plate_state.dart';

class ListPlateBloc extends Bloc<ListPlateEvent, ListPlateState> {
  ListPlateBloc()
    : super(
        ListPlateState(
          selectedProvince: ProvinceModel.all(),
          provinces: [ProvinceModel.all()],
        ),
      ) {
    on<OnInit>(_onInit);
    on<OnSearch>(_onSearch);
    on<OnLoadMore>(_onLoadMore);
  }

  int currentPage = 1;
  int totalPage = 1;
  int take = 50;

  bool isLoadingMore = false;

  Future<void> _onInit(OnInit event, Emitter<ListPlateState> emit) async {
    try {
      final param = {
        'page': currentPage,
        'take': take,
        'vehicle': state.vehicleType.keys,
        'status': 'waiting_auction',
        if (!state.plateColor.isAll && state.vehicleType.isCar)
          'color': state.plateColor.idx,
        if (state.startDate != null)
          'startDate': DateTimeUtils.getStringDateApi(state.startDate),
        if (state.endDate != null)
          'endDate': DateTimeUtils.getStringDateApi(state.endDate),
      };
      final res = await Future.wait([
        ApiService().getListProvince(),
        ApiService().searchPlates(param: param),
      ]);

      final provinces = res[0] as List<ProvinceModel>;
      final plates = res[1] as PlateResponse;

      currentPage = plates.meta.page;
      totalPage = plates.meta.pageCount;

      emit(
        state.copyWith(
          screenState: ScreenState.success,
          provinces: [ProvinceModel.all(), ...provinces],
          plates: plates.data,
          hasReachedMax: currentPage >= totalPage,
        ),
      );
    } catch (_) {
      emit(state.copyWith(screenState: ScreenState.success));
    }
  }

  Future<void> _onSearch(OnSearch event, Emitter<ListPlateState> emit) async {
    try {
      currentPage = 1;
      totalPage = 1;

      emit(
        state.copyWith(
          startDate: event.startDate,
          endDate: event.endDate,
          vehicleType: event.vehicleType,
          plateColor: event.plateColor,
          selectedProvince: event.selectedProvince,
          plateNumber: event.plateNumber,
          screenState: ScreenState.loading,
        ),
      );

      final param = {
        'page': currentPage,
        'take': take,
        'vehicle': state.vehicleType.keys,
        'status': 'waiting_auction',
        if (!state.plateColor.isAll && state.vehicleType.isCar)
          'color': state.plateColor.idx,
        if (state.startDate != null)
          'startDate': DateTimeUtils.getStringDateApi(state.startDate),
        if (state.endDate != null)
          'endDate': DateTimeUtils.getStringDateApi(state.endDate),
        'q': state.plateNumber,
        if (!state.selectedProvince.isAll)
          'provinceCode': state.selectedProvince.code,
      };
      final res = await ApiService().searchPlates(param: param);

      currentPage = res.meta.page;
      totalPage = res.meta.pageCount;

      emit(
        state.copyWith(
          screenState: ScreenState.success,
          plates: res.data,
          hasReachedMax: currentPage >= totalPage,
        ),
      );
    } catch (_) {
      emit(state.copyWith(screenState: ScreenState.success));
    }
  }

  Future<void> _onLoadMore(
    OnLoadMore event,
    Emitter<ListPlateState> emit,
  ) async {
    try {
      if (state.hasReachedMax) {
        return;
      }

      currentPage += 1;
      isLoadingMore = true;

      final param = {
        'page': currentPage,
        'take': take,
        'vehicle': state.vehicleType.keys,
        'status': 'waiting_auction',
        if (!state.plateColor.isAll && state.vehicleType.isCar)
          'color': state.plateColor.idx,
        if (state.startDate != null)
          'startDate': DateTimeUtils.getStringDateApi(state.startDate),
        if (state.endDate != null)
          'endDate': DateTimeUtils.getStringDateApi(state.endDate),
        'q': state.plateNumber,
        if (!state.selectedProvince.isAll)
          'provinceCode': state.selectedProvince.code,
      };
      final res = await ApiService().searchPlates(param: param);

      currentPage = res.meta.page;
      totalPage = res.meta.pageCount;

      emit(
        state.copyWith(
          screenState: ScreenState.success,
          plates: state.plates + res.data,
          hasReachedMax: currentPage >= totalPage,
        ),
      );
      isLoadingMore = false;
    } catch (_) {
      isLoadingMore = false;
    }
  }
}
