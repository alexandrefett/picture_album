import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:picture_album/auth.dart';
import 'package:picture_album/database.dart';
import 'package:picture_album/model.dart';
import 'package:picture_album/widgets/widgets.dart';
import 'package:picture_album/album.dart';

class CatPage extends StatefulWidget {
  CatPage({Key key, this.hotelid}) : super(key: key);
  final String hotelid;

  @override
  _CatPageState createState() => _CatPageState();
}

class _CatPageState extends State<CatPage> {
  User user;
  List<Widget> actions = [];

  @override
  void initState() {
    user = authService.currentUser();
    if (user != null)
      actions = [CatButton(hotelid: widget.hotelid), LoginButton()];
    else
      actions = [LoginButton()];
    authService.onAuthStateChanged().listen((onData) {
      setState(() {
        user = onData;
        if (user != null)
          actions = [CatButton(hotelid: widget.hotelid), LoginButton()];
        else
          actions = [LoginButton()];
      });
    });

    super.initState();
  }

  Widget catItem(Categoria cat) {
    return Container(
        width: 200,
        child: Column(children: <Widget>[
          user != null
              ? Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      icon: Icon(Icons.delete_forever),
                      onPressed: () =>
                          fireService.deleteCat(widget.hotelid, cat.id)))
              : Container(),
          FlatButton(
              focusColor: Colors.blue,
              onPressed: () async => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AlbumPage(
                            hotelid: widget.hotelid,
                            catid: cat.id,
                          ))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                      borderRadius: new BorderRadius.circular(8.0),
                      child: Image.network(
                        cat.imageurl,
                        fit: BoxFit.fitHeight,
                      )),
                  Text(cat.categoria, style: TextStyle(fontSize: 18))
                ],
              ))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarAlbum(actions: actions),
        body: Container(
            alignment: Alignment.topCenter,
            child: StreamBuilder<QuerySnapshot>(
                stream: fireService.getCatFromHotel(widget.hotelid),
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> event) {
                  if (event.data != null) {
                    if (!event.data.empty) {
                      print(event.data.docs.length);
                      return Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          alignment: WrapAlignment.center,
                          spacing: 20,
                          children: event.data.docs
                              .map((data) =>
                                  catItem(Categoria.fromJson(data.data())))
                              .toList());
                    } else {
                      return Center(
                        child: Text('Sem dados'),
                      );
                    }
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                })));
  }
}
