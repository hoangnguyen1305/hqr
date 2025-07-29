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
