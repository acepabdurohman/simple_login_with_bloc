import 'package:flutter/material.dart';
import 'package:belajar_login_bloc/data/login_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:belajar_login_bloc/bloc/login_bloc.dart';
import 'package:belajar_login_bloc/bloc/login_state.dart';
import 'package:belajar_login_bloc/bloc/login_event.dart';
import 'package:belajar_login_bloc/bloc/authentication_bloc.dart';

class LoginPage extends StatelessWidget {

  final LoginRepository _loginRepository;

  LoginPage(this._loginRepository);

  @override
  Widget build(BuildContext buildContext) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
      ),
      body: BlocProvider(
        builder: (buildContext) {
          return LoginBloc(
            _loginRepository,
            BlocProvider.of<AuthenticationBloc>(buildContext)
          );
        },
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {

  @override
  State<LoginForm> createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  TextStyle textStyle = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  Widget build(BuildContext buildContext) {

    final txtUsername = TextField(
      controller: _usernameController,
      obscureText: false,
      style: textStyle,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: 'Masukan username',
        border: OutlineInputBorder(),
        labelText: 'Username'
      ),
    );

    final txtPassword = TextField(
      controller: _passwordController,
      obscureText: true,
      style: textStyle,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: 'Masukan password',
        border: OutlineInputBorder(),
        labelText: 'Password'
      ),
    );

    return BlocListener<LoginBloc, LoginState>(
      listener: (buildContext, state) {
        if (state is LoginFailure) {
          Scaffold.of(buildContext).showSnackBar(
            SnackBar(
              content: Text(
                '${state.errorMessage}'
              ),
            )
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (buildContext, state) {
          return Scaffold(
            body: Center(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 155.0,
                        child: Image.asset("images/logo.png", fit: BoxFit.contain,),
                      ),
                      SizedBox(height: 45.0,),
                      txtUsername,
                      SizedBox(height: 25.0,),
                      txtPassword,
                      SizedBox(height: 35.0,),
                      Material(
                        elevation: 5.0,
                        color: Colors.blue,
                        child: MaterialButton(
                          minWidth: MediaQuery.of(buildContext).size.width,
                          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          onPressed: () {
                            _onLoginButtonPressed();
                          },
                          child: Text(
                            'LOGIN',
                            textAlign: TextAlign.center,
                            style: textStyle.copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      )
    );
  }

  _onLoginButtonPressed() {
    BlocProvider.of<LoginBloc>(context).add(
      LoginEvent(_usernameController.text, _passwordController.text)
    );
  }

}