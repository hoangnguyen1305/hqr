import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hqr/model/mst_response.dart';
import 'package:hqr/service/api_service.dart';
import 'package:hqr/utils/enum.dart';

part 'tax_code_event.dart';
part 'tax_code_state.dart';

class TaxCodeBloc extends Bloc<TaxCodeEvent, TaxCodeState> {
  TaxCodeBloc() : super(TaxCodeState()) {
    on<OnSearch>(_onSearch);
  }

  TextEditingController taxEC = TextEditingController();

  Future<void> _onSearch(OnSearch event, Emitter<TaxCodeState> emit) async {
    emit(state.copyWith(screenState: ScreenState.loading));
    final mst = await ApiService().getMST(taxCode: taxEC.text);
    emit(state.copyWith(screenState: ScreenState.success));
    event.onSuccess.call(mst);
  }
}
