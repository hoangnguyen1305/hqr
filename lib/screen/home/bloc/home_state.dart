part of 'home_bloc.dart';

class HomeState extends Equatable {
  final ScreenState screenState;
  final BankData bankData;
  final List<BankData> banks;
  final String accountNo;
  final String accountName;
  final QrType qrType;
  final int trigger;

  const HomeState({
    this.screenState = ScreenState.success,
    this.bankData = const BankData(),
    this.banks = const [],
    this.accountNo = '123123',
    this.accountName = 'NVH',
    this.qrType = QrType.compact2,
    this.trigger = 0,
  });

  HomeState copyWith({
    ScreenState? screenState,
    BankData? bankData,
    List<BankData>? banks,
    String? accountNo,
    String? accountName,
    QrType? qrType,
    int? trigger,
  }) {
    return HomeState(
      screenState: screenState ?? this.screenState,
      bankData: bankData ?? this.bankData,
      banks: banks ?? this.banks,
      accountNo: accountNo ?? this.accountNo,
      accountName: accountName ?? this.accountName,
      qrType: qrType ?? this.qrType,
      trigger: trigger ?? this.trigger,
    );
  }

  @override
  List<Object> get props => [
    screenState,
    bankData,
    banks,
    accountNo,
    accountName,
    qrType,
    trigger,
  ];
}
