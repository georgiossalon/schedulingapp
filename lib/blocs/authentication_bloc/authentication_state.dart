import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final String userId;
  final String userEmail;

  const Authenticated(this.userId,this.userEmail);

  @override
  List<Object> get props => [userId,userEmail];

  @override
  String toString() => 'Authenticated { userId: $userId, userEmail: $userEmail }';
}

class Unauthenticated extends AuthenticationState {}