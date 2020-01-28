import 'package:flutter/material.dart';
import 'package:belajar_login_bloc/data/login_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:belajar_login_bloc/bloc/authentication_event.dart';
import 'package:belajar_login_bloc/bloc/authentication_state.dart';
import 'package:belajar_login_bloc/bloc/authentication_bloc.dart';
import 'package:belajar_login_bloc/login.dart';

void main() {
  final LoginRepository _loginRepository = LoginRepository();

  runApp(
    BlocProvider<AuthenticationBloc>(
      builder: (context) {
        return AuthenticationBloc(_loginRepository)..add(InitAuthEvent());
      },
      child: RouterApp(_loginRepository),
    )
  );
}

class RouterApp extends StatelessWidget {

  final LoginRepository _loginRepository;

  RouterApp(this._loginRepository);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if(state is UnauthenticatedState) {
            return LoginPage(_loginRepository);
          } else if(state is AuthenticatedState) {
            return DashboardPage();
          } else {
            return Text('Not Found');
          }
        },
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('HOME'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(buildContext).add(LoggedOut());
            },
            child: Text('Log out', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Center(child: Text('Hello World')),
    );
  }
}