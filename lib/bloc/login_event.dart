enum ButtonAction {login, logout}

class LoginEvent {
  final String username;
  final String password;

  LoginEvent(this.username, this.password);
}