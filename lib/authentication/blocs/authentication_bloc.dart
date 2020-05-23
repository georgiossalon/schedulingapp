import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/user_repository.dart';
import 'package:snapshot_test/authentication/blocs/authentication.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    //!Rolly
    //todo: currently if a user has signed in once, he does not have to re sign in
    //todo... in the future I might want to change that
    final isSignedIn = await _userRepository.isSignedIn();
    if (isSignedIn) {
      final userId = await _userRepository.getUserId();
      final userEmail = await _userRepository.getUserEmail();
      yield Authenticated(userId, userEmail);
    } else {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    yield Authenticated(
      await _userRepository.getUserId(),
      await _userRepository.getUserEmail(),
    );
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _userRepository.signOut();
  }
}
