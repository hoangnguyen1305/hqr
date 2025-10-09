part of 'fines_bloc.dart';

class FinesState extends Equatable {
  final ScreenState screenState;
  final DeviceType deviceType;

  const FinesState({
    this.screenState = ScreenState.success,
    this.deviceType = DeviceType.car,
  });

  FinesState copyWith({ScreenState? screenState, DeviceType? deviceType}) {
    return FinesState(
      screenState: screenState ?? this.screenState,
      deviceType: deviceType ?? this.deviceType,
    );
  }

  @override
  List<Object?> get props => [screenState, deviceType];
}
