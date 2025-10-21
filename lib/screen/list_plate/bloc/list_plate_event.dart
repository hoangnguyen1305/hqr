part of 'list_plate_bloc.dart';

abstract class ListPlateEvent {}

class OnInit extends ListPlateEvent {}

class OnSearch extends ListPlateEvent {
  final VehicleType? vehicleType;
  final PlateColor? plateColor;
  final ProvinceModel? selectedProvince;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? plateNumber;

  OnSearch({
    this.vehicleType,
    this.plateColor,
    this.selectedProvince,
    this.startDate,
    this.endDate,
    this.plateNumber,
  });
}

class OnLoadMore extends ListPlateEvent {}
