import 'package:equatable/equatable.dart';
import 'package:employees_repository/employees_repository.dart';

abstract class UnavailabilitiesState extends Equatable {
  const UnavailabilitiesState();

  @override
  List<Object> get props => [];
}

class UnavailabilitiesLoading extends UnavailabilitiesState {}

class UnavailabilitiesLoaded extends UnavailabilitiesState {
  final List<Unavailability> unavailabilities;

  const UnavailabilitiesLoaded([this.unavailabilities = const[]]);

  @override
  List<Object> get props => [unavailabilities];

  @override
  String toString() => 'Unavailabilities {unavailabilities $unavailabilities }';
}

class UnavailabilitiesNotLoaded extends UnavailabilitiesState {}