import 'package:bloc/bloc.dart';
import 'package:belajar_login_bloc/bloc/authentication_event.dart';
import 'package:belajar_login_bloc/bloc/authentication_state.dart';
import 'package:belajar_login_bloc/data/login_repository.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {

  final LoginRepository _loginRepository;

  AuthenticationBloc(this._loginRepository);

  @override
  AuthenticationState get initialState => AuthInitState();

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    print('Proses bloc event');

    if (event is InitAuthEvent) {
      final bool hasToken = await _loginRepository.hasToken();

      if (hasToken) {
        yield AuthenticatedState();
      } else {
        yield UnauthenticatedState();
      }
    }
    if (event is LoggedIn) {
      await _loginRepository.saveToken(event.token);
      yield AuthenticatedState();
      print('Login success');
    }

    if (event is LoggedOut) {
      await _loginRepository.deleteToken();
      yield UnauthenticatedState();
      print('Logout success');
    }
  }
}