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
