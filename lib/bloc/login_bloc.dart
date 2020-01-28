import 'package:bloc/bloc.dart';
import 'package:belajar_login_bloc/bloc/login_event.dart';
import 'package:belajar_login_bloc/bloc/login_state.dart';
import 'package:belajar_login_bloc/data/login_repository.dart';
import 'package:belajar_login_bloc/bloc/authentication_bloc.dart';
import 'package:belajar_login_bloc/bloc/authentication_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {

  final LoginRepository loginRepository;

  final AuthenticationBloc authenticationBloc;

  LoginBloc(this.loginRepository, this.authenticationBloc);

  @override
  LoginState get initialState {
    return LoginInitial();
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    print('Proses bloc login');

    final username = event.username;
    final password = event.password;

    final TokenResponse tokenResponse = await loginRepository.authenticate(username, password);

    final status = tokenResponse.status;

    if (status == 1) {
      final accessToken = tokenResponse.accessToken;
      print(accessToken);

      authenticationBloc.add(LoggedIn(accessToken));  
    } else {
      yield LoginFailure(tokenResponse.message);     
    }

  }
}