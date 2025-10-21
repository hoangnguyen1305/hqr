part of 'result_plate_bloc.dart';

class ResultPlateState extends Equatable {
  final ScreenState screenState;
  final VehicleType vehicleType;
  final PlateColor plateColor;
  final List<ProvinceModel> provinces;
  final ProvinceModel selectedProvince;
  final List<PlateModel> plates;
  final String plateNumber;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool hasReachedMax;
  final SortBy sortBy;

  const ResultPlateState({
    this.screenState = ScreenState.loading,
    this.vehicleType = VehicleType.car,
    this.plateColor = PlateColor.all,
    this.provinces = const [],
    required this.selectedProvince,
    this.plates = const [],
    this.plateNumber = '',
    this.startDate,
    this.endDate,
    this.hasReachedMax = false,
    this.sortBy = SortBy.desc,
  });

  ResultPlateState copyWith({
    ScreenState? screenState,
    VehicleType? vehicleType,
    PlateColor? plateColor,
    List<ProvinceModel>? provinces,
    ProvinceModel? selectedProvince,
    List<PlateModel>? plates,
    String? plateNumber,
    DateTime? startDate,
    DateTime? endDate,
    bool? hasReachedMax,
    SortBy? sortBy,
  }) {
    return ResultPlateState(
      screenState: screenState ?? this.screenState,
      vehicleType: vehicleType ?? this.vehicleType,
      plateColor: plateColor ?? this.plateColor,
      provinces: provinces ?? this.provinces,
      selectedProvince: selectedProvince ?? this.selectedProvince,
      plates: plates ?? this.plates,
      plateNumber: plateNumber ?? this.plateNumber,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  @override
  List<Object?> get props => [
    screenState,
    vehicleType,
    plateColor,
    provinces,
    selectedProvince,
    plates,
    plateNumber,
    hasReachedMax,
    startDate,
    endDate,
    sortBy,
  ];
}
