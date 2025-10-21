part of 'gen_qr_bloc.dart';

abstract class HomeEvent {}

class OnInit extends HomeEvent {}

class OnGenarateQr extends HomeEvent {
  final Function(String) onSuccess;
  final Function(String) onError;

  OnGenarateQr({required this.onSuccess, required this.onError});
}

class OnChangeQrType extends HomeEvent {
  final QrType qrType;

  OnChangeQrType(this.qrType);
}

class OnChangeBank extends HomeEvent {
  final BankData bankData;

  OnChangeBank(this.bankData);
}
