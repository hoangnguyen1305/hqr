import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hqr/model/bank_response.dart';
import 'package:hqr/service/api_service.dart';
import 'package:hqr/utils/enum.dart';

part 'gen_qr_event.dart';
part 'gen_qr_state.dart';

class GenQRBloc extends Bloc<HomeEvent, HomeState> {
  GenQRBloc() : super(HomeState()) {
    on<OnInit>(_onInit);
    on<OnGenarateQr>(_onGenarateQr);
    on<OnChangeQrType>(_onChangeQrType);
    on<OnChangeBank>(_onChangeBank);
  }

  TextEditingController amountEC = TextEditingController();
  TextEditingController accountNameEC = TextEditingController();
  TextEditingController accountNoEC = TextEditingController();
  TextEditingController descEC = TextEditingController();

  Future<void> _onInit(OnInit event, Emitter<HomeState> emit) async {
    final banks = await ApiService().getBanks();
    banks.data.sort((a, b) => a.shortName.compareTo(b.shortName));
    emit(state.copyWith(banks: banks.data, bankData: banks.data.first));
  }

  void _onChangeQrType(OnChangeQrType event, Emitter<HomeState> emit) {
    if (event.qrType == state.qrType) {
      return;
    }
    emit(state.copyWith(qrType: event.qrType));
  }

  void _onChangeBank(OnChangeBank event, Emitter<HomeState> emit) {
    if (event.bankData == state.bankData) {
      return;
    }
    emit(state.copyWith(bankData: event.bankData));
  }

  Future<void> _onGenarateQr(
    OnGenarateQr event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(screenState: ScreenState.loading));
    final res = await ApiService().generateQR(
      body: {
        'accountNo': accountNoEC.text,
        'accountName': accountNameEC.text,
        'acqId': state.bankData.bin,
        'amount': amountEC.text.replaceAll(',', ''),
        'addInfo': descEC.text,
        'format': 'text',
        'template': state.qrType.key,
      },
    );
    emit(state.copyWith(screenState: ScreenState.success));
    if (res.code == '00') {
      event.onSuccess.call(res.data.qrDataURL);
    } else {
      event.onError.call(res.desc);
    }
  }
}
