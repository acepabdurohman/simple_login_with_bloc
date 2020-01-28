abstract class AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final String token;

  LoggedIn(this.token);
}

class InitAuthEvent extends AuthenticationEvent {}

class LoggedOut extends AuthenticationEvent {}