part of 'doul_bloc.dart';

sealed class DoulEvent {
  const DoulEvent();
}

final class DoulStarted extends DoulEvent {
  const DoulStarted();
}

final class DoulFilterChanged extends DoulEvent {
  const DoulFilterChanged({
    this.vehicleType,
    this.plateColor,
    this.selectedProvince,
    this.plateNumber,
  });

  final VehicleType? vehicleType;
  final PlateColor? plateColor;
  final ProvinceModel? selectedProvince;
  final String? plateNumber;
}
