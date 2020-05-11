import 'package:employees_repository/employees_repository.dart';
import 'package:equatable/equatable.dart';

abstract class DesignationsState extends Equatable {
  const DesignationsState();

 @override
  List<Object> get props => [];
}

class DesignationsLoading extends DesignationsState {}

class DesignationsLoaded extends DesignationsState {
  final List<Designation> designations;

  const DesignationsLoaded([this.designations = const[]]);

  @override
  List<Object> get props => [designations];

  @override
  String toString() => 'Designations { designations $designations }';
}

class DesignationsNotLoaded extends DesignationsState {}

