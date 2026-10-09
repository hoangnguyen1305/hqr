part of 'doul_bloc.dart';

class DoulState extends Equatable {
  const DoulState({
    this.screenState = ScreenState.loading,
    this.vehicleType = VehicleType.car,
    this.plateColor = PlateColor.all,
    this.provinces = const [],
    required this.selectedProvince,
    this.plateNumber = '',
    this.listPlates = const [],
    this.resultPlates = const [],
  });

  final ScreenState screenState;
  final VehicleType vehicleType;
  final PlateColor plateColor;
  final List<ProvinceModel> provinces;
  final ProvinceModel selectedProvince;
  final String plateNumber;
  final List<PlateModel> listPlates;
  final List<PlateModel> resultPlates;

  DoulState copyWith({
    ScreenState? screenState,
    VehicleType? vehicleType,
    PlateColor? plateColor,
    List<ProvinceModel>? provinces,
    ProvinceModel? selectedProvince,
    String? plateNumber,
    List<PlateModel>? listPlates,
    List<PlateModel>? resultPlates,
  }) {
    return DoulState(
      screenState: screenState ?? this.screenState,
      vehicleType: vehicleType ?? this.vehicleType,
      plateColor: plateColor ?? this.plateColor,
      provinces: provinces ?? this.provinces,
      selectedProvince: selectedProvince ?? this.selectedProvince,
      plateNumber: plateNumber ?? this.plateNumber,
      listPlates: listPlates ?? this.listPlates,
      resultPlates: resultPlates ?? this.resultPlates,
    );
  }

  @override
  List<Object> get props => [
    screenState,
    vehicleType,
    plateColor,
    provinces,
    selectedProvince,
    plateNumber,
    listPlates,
    resultPlates,
  ];
}
