import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:picture_album/auth.dart';
import 'package:picture_album/database.dart';
import 'package:picture_album/model.dart';
import 'package:picture_album/widgets/widgets.dart';
import 'package:picture_album/categorias.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.indigo,
        primaryColor: Colors.indigo,
        buttonColor: Colors.indigo,
      ),
      home: MyHomePage(title: 'Hotéis Everest'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  User user;
  List<Widget> actions = [];

  @override
  void initState() {
    user = authService.currentUser();
    if (user != null)
      actions = [HotelButton(), LoginButton()];
    else
      actions = [LoginButton()];
    authService.onAuthStateChanged().listen((onData) {
      setState(() {
        user = onData;
        if (user != null)
          actions = [HotelButton(), LoginButton()];
        else
          actions = [LoginButton()];
      });
    });

    super.initState();
  }

  Widget hotelItem(Hotel hotel) {
    return Container(
        width: 200,
        child: Column(
          children: <Widget>[
            user != null
                ? Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        icon: Icon(Icons.delete_forever),
                        onPressed: () => fireService.deleteHotel(hotel.id)))
                : Container(),
            FlatButton(
                padding: EdgeInsets.all(5),
                hoverColor: Colors.blueGrey,
                onPressed: () async => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CatPage(hotelid: hotel.id))),
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                        borderRadius: new BorderRadius.circular(8.0),
                        child: Image.network(
                          hotel.imageUrl,
                          fit: BoxFit.fitHeight,
                        )),
                    Text(hotel.nome, style: TextStyle(fontSize: 18)),
                  ],
                ))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarAlbum(actions: actions),
        body: Container(
            alignment: Alignment.topCenter,
            child: StreamBuilder<QuerySnapshot>(
                stream: fireService.getHoteis(),
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> event) {
                  if (event.data != null) {
                    if (!event.data.empty) {
                      return Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          alignment: WrapAlignment.center,
                          spacing: 20,
                          children: event.data.docs
                              .map((data) =>
                                  hotelItem(Hotel.fromJson(data.data())))
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
