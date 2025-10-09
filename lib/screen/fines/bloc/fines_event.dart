part of 'fines_bloc.dart';

abstract class FinesEvent {}

class OnSearch extends FinesEvent {
  final Function(List<TrafficViolations>) onSuccess;

  OnSearch({required this.onSuccess});
}

class OnChangeDeviceType extends FinesEvent {
  final DeviceType deviceType;

  OnChangeDeviceType(this.deviceType);
}
