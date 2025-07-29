part of 'tax_code_bloc.dart';

abstract class TaxCodeEvent {}

class OnSearch extends TaxCodeEvent {
  final Function(MSTData) onSuccess;

  OnSearch({required this.onSuccess});
}
