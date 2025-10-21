enum ScreenState {
  loading,
  success,
  failure;

  bool get isLoading => this == ScreenState.loading;
  bool get isSuccess => this == ScreenState.success;
  bool get isFailure => this == ScreenState.failure;
}

enum QrType {
  compact2('compact2'),
  compact('compact'),
  qrOnly('qr_only'),
  print('print');

  final String key;
  const QrType(this.key);
}

enum DeviceType {
  car(1),
  motobike(2),
  ebike(3);

  final int idx;
  const DeviceType(this.idx);

  bool get isCar => this == DeviceType.car;

  String get title {
    switch (this) {
      case DeviceType.car:
        return 'Ô Tô';
      case DeviceType.motobike:
        return 'Xe Máy';
      case DeviceType.ebike:
        return 'Xe Máy Điện';
    }
  }
}

enum PlateColor {
  all(-1),
  white(0),
  yellow(3);

  final int idx;
  const PlateColor(this.idx);

  bool get isWhite => this == PlateColor.white;
  bool get isYellow => this == PlateColor.yellow;
  bool get isAll => this == PlateColor.all;

  String get title {
    switch (this) {
      case PlateColor.white:
        return 'Biển Trắng';
      case PlateColor.yellow:
        return 'Biển Vàng';
      case PlateColor.all:
        return 'Tất Cả';
    }
  }
}

enum VehicleType {
  car('car'),
  motobike('motor_bike');

  final String keys;
  const VehicleType(this.keys);

  bool get isCar => this == VehicleType.car;

  String get title {
    switch (this) {
      case VehicleType.car:
        return 'Ô Tô';
      case VehicleType.motobike:
        return 'Xe Máy';
    }
  }
}

enum SortBy {
  desc('desc'),
  asc('asc');

  final String keys;
  const SortBy(this.keys);

   String get title {
    switch (this) {
      case SortBy.desc:
        return 'Giảm dần';
      case SortBy.asc:
        return 'Tăng dần';
    }
  }
}
