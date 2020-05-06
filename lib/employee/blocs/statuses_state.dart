import 'package:equatable/equatable.dart';
import 'package:employees_repository/employees_repository.dart';

abstract class StatusesState extends Equatable {
  const StatusesState();

  @override
  List<Object> get props => [];
}

class StatusesLoading extends StatusesState {}

class StatusesLoaded extends StatusesState {
  final List<Status> statuses;

  const StatusesLoaded([this.statuses = const[]]);

  @override
  List<Object> get props => [statuses];

  @override
  String toString() => 'Statuses {statuses $statuses }';
}

class StatusesNotLoaded extends StatusesState {}