import 'dart:html';
import 'package:firebase/firebase.dart';
import 'package:picture_album/albumbutton.dart';
import 'package:flutter/material.dart';
import 'package:picture_album/auth.dart';
import 'package:picture_album/database.dart';
import 'package:picture_album/widgets/widgets.dart';
import 'package:picture_album/model.dart';
import 'package:picture_album/widgets/upload.dart';

class HotelFormPage extends StatefulWidget {
  HotelFormPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HotelFormState createState() => _HotelFormState();
}

class _HotelFormState extends State<HotelFormPage> {
  final _formKey = GlobalKey<FormState>();
  String nome;
  String descricao;
  String imageName;

  bool waiting = false;
  Blob image;

  User user;
  List<Widget> actions=[LoginButton()];

  @override
  void initState() {
    user = authService.currentUser();
    authService.onAuthStateChanged().listen((onData){
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
            actions: actions
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
                                'Detalhes do Hotel',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 20.0),
                              ),
                              Divider(height: 25),
                              Form(

                                  key: _formKey,
                                  child: Column(children: <Widget>[
                                    TextFormField(
                                        decoration: InputDecoration(
                                            labelText: 'nome do hotel',
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
                                            return 'Entre com nome válido';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          nome = value.toString();
                                        }),
                                    Padding(padding: EdgeInsets.all(4)),
                                    TextFormField(
                                        maxLines: 10,
                                        decoration: InputDecoration(
                                            labelText: 'Descrição do hotel',
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
                                            return 'Entre com uma descrição';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          descricao = value.toString();
                                        }),
                                    UploadWidget(
                                        onPressed: (onValue){
                                          image = onValue;
                                        }
                                    ),
                                    AlbumButton(
                                      text: 'Avançar',
                                      onPressed: () {
                                          if(_formKey.currentState.validate()) {
                                            _formKey.currentState.save();
                                            Hotel hotel = Hotel(
                                                nome: nome,
                                                descricao: descricao);
                                            fireService
                                                .addHotel(hotel, image)
                                                .then((onValue) {
                                                   Navigator.pop(context);
                                                }
                                                );
                                          }
                                        })
                                  ])),
                            ]))))));
  }
}
