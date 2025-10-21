part of 'gen_qr_bloc.dart';

class HomeState extends Equatable {
  final ScreenState screenState;
  final BankData bankData;
  final List<BankData> banks;
  final QrType qrType;
  final int trigger;

  const HomeState({
    this.screenState = ScreenState.success,
    this.bankData = const BankData(),
    this.banks = const [],
    this.qrType = QrType.compact2,
    this.trigger = 0,
  });

  HomeState copyWith({
    ScreenState? screenState,
    BankData? bankData,
    List<BankData>? banks,
    QrType? qrType,
    int? trigger,
  }) {
    return HomeState(
      screenState: screenState ?? this.screenState,
      bankData: bankData ?? this.bankData,
      banks: banks ?? this.banks,
      qrType: qrType ?? this.qrType,
      trigger: trigger ?? this.trigger,
    );
  }

  @override
  List<Object> get props => [screenState, bankData, banks, qrType, trigger];
}
