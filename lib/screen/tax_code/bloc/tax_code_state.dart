part of 'tax_code_bloc.dart';

class TaxCodeState extends Equatable {
  final ScreenState screenState;

  const TaxCodeState({this.screenState = ScreenState.success});

  TaxCodeState copyWith({ScreenState? screenState, String? taxCode}) {
    return TaxCodeState(screenState: screenState ?? this.screenState);
  }

  @override
  List<Object> get props => [screenState];
}
