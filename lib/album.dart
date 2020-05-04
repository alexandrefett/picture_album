import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:picture_album/auth.dart';
import 'package:picture_album/database.dart';
import 'package:picture_album/model.dart';
import 'package:picture_album/widgets/widgets.dart';

class AlbumPage extends StatefulWidget {
  AlbumPage({Key key, this.hotelid, this.catid}) : super(key: key);
  final String hotelid;
  final String catid;

  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  User user;
  List<Widget> actions = [];
  PageController pageController;

  @override
  void initState() {
    user = authService.currentUser();
    if (user != null)
      actions = [
        FotoButton(hotelid: widget.hotelid, catid: widget.catid),
        LoginButton()
      ];
    else
      actions = [LoginButton()];
    authService.onAuthStateChanged().listen((onData) {
      setState(() {
        user = onData;
        if (user != null)
          actions = [
            FotoButton(hotelid: widget.hotelid, catid: widget.catid),
            LoginButton()
          ];
        else
          actions = [LoginButton()];
      });
    });
    pageController = PageController(initialPage: 1, viewportFraction: 0.8);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarAlbum(actions: actions),
        body: Container(
            alignment: Alignment.topCenter,
            child: StreamBuilder<QuerySnapshot>(
                stream:
                    fireService.getFotosFromCat(widget.hotelid, widget.catid),
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> event) {
                  if (event.data != null) {
                    if (!event.data.empty) {
                      print(event.data.docs.length);
                      return PageView.builder(
                          controller: pageController,
                          itemBuilder: (context, index) {
                            return imageSlider(
                                index,
                                event.data.docs[index]
                                    .data()['url']
                                    .toString());
                          });
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

  imageSlider(int index, String url) {
    return AnimatedBuilder(
        animation: pageController,
        builder: (context, widget) {
          double value = 1;
          if (pageController.position.haveDimensions) {
            value = pageController.page - index;
            value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
          }
          return Center(
              child: SizedBox(
                  width: Curves.easeInOut.transform(value) * 300,
                  height: Curves.easeInOut.transform(value) * 200,
                  child: widget));
        },
        child: Container(
            margin: EdgeInsets.all(10),
            child: Image.network(
              url,
              fit: BoxFit.fill,
            )));
  }
}
