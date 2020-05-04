import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:picture_album/auth.dart';
import 'package:picture_album/widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;

  bool waiting = false;
  User user;
  List<Widget> actions = [LoginButton()];

  @override
  void initState() {
    user = authService.currentUser();
    authService.onAuthStateChanged().listen((onData) {
      setState(() {
        user = onData;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarAlbum(
          actions: actions,
        ),
        body: Container(
            child: Center(
                child: Align(
                    alignment: Alignment.center,
                    child: Container(
                        width: 300,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Fazer login com:',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 20.0),
                              ),
                              Divider(height: 25),
                              Form(
                                  key: _formKey,
                                  child: Column(children: <Widget>[
                                    TextFormField(
                                        decoration: InputDecoration(
                                            labelText: 'email',
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 12.0,
                                                    horizontal: 12.0),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.black54))),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Entre com email válido';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          email = value.toString();
                                          print(email);
                                        }),
                                    Padding(padding: EdgeInsets.all(4)),
                                    TextFormField(
                                        obscureText: true,
                                        decoration: InputDecoration(
                                            labelText: 'senha',
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 12.0,
                                                    horizontal: 12.0),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.black54))),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Entre com uma senha';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          password = value.toString();
                                        }),
                                    MaterialButton(
                                        color: Colors.blueAccent,
                                        elevation: 10.0,
                                        minWidth: 100.0,
                                        child: Text('Entrar'),
                                        onPressed: () {
                                          if (_formKey.currentState
                                              .validate()) {
                                            _formKey.currentState.save();
                                            print(email);
                                            print(password);
                                            authService
                                                .signInWithEmailAndPassword(
                                                    email, password)
                                                .then((onValue) {
                                              print(onValue.email);
                                              Navigator.pop(context);
                                            });
                                          }
                                        })
                                  ])),
                            ]))))));
  }
}
