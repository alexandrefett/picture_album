import 'dart:html';
import 'package:firebase/firebase.dart';
import 'package:picture_album/albumbutton.dart';
import 'package:flutter/material.dart';
import 'package:picture_album/auth.dart';
import 'package:picture_album/database.dart';
import 'package:picture_album/widgets/widgets.dart';
import 'package:picture_album/widgets/upload.dart';

class FotoFormPage extends StatefulWidget {
  FotoFormPage({Key key, this.hotelid, this.catid}) : super(key: key);
  final String hotelid;
  final String catid;

  @override
  _FotoFormState createState() => _FotoFormState();
}

class _FotoFormState extends State<FotoFormPage> {
  final _formKey = GlobalKey<FormState>();
  String imageName;

  bool waiting = false;
  Blob image;

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
        appBar: AppBarAlbum(actions: actions),
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
                                    UploadWidget(onPressed: (onValue) {
                                      image = onValue;
                                    }),
                                    AlbumButton(
                                        text: 'Avançar',
                                        onPressed: () {
                                          if (_formKey.currentState
                                              .validate()) {
                                            _formKey.currentState.save();
                                            fireService
                                                .addFoto(widget.catid,
                                                    widget.hotelid, image)
                                                .then((onValue) {
                                              Navigator.pop(context);
                                            });
                                          }
                                        })
                                  ])),
                            ]))))));
  }
}
