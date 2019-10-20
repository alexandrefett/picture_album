import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:picture_album/catform.dart';
import 'package:picture_album/fotoform.dart';
import 'package:picture_album/login.dart';
import 'package:picture_album/auth.dart';
import 'package:picture_album/hotelform.dart';

class LoginButton extends StatefulWidget {
  LoginButton({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginButton createState() => _LoginButton();
}

class _LoginButton extends State<LoginButton> {

  User user;

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
     return user != null ?
        Tooltip(
            message: 'Encerrar sessão',
            child: FlatButton(
              child: Text(user.email,style: TextStyle(color: Colors.white)),
              onPressed: () async => authService.signOut(),
          )
        )
        :
        FlatButton(
          child: Text('Entrar',style: TextStyle(color: Colors.white)),
          onPressed: () async => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage(title: widget.title))
          )
        );
  }
}


class HotelButton extends StatefulWidget {
  HotelButton({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HotelButton createState() => _HotelButton();
}

class _HotelButton extends State<HotelButton> {

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        child: Text('novo hotel',style: TextStyle(color: Colors.white)),
        onPressed:  () async => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HotelFormPage())
        )
    );
  }
}

class FotoButton extends StatefulWidget {
  FotoButton({Key key, this.hotelid, this.catid}) : super(key: key);
  final String hotelid;
  final String catid;

  @override
  _FotoButton createState() => _FotoButton();
}

class _FotoButton extends State<FotoButton> {

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        child: Text('nova foto',style: TextStyle(color: Colors.white)),
        onPressed:  () async => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FotoFormPage(hotelid: widget.hotelid,catid: widget.catid,))
        )
    );
  }
}

class CatButton extends StatefulWidget {
  CatButton({Key key, this.title, this.hotelid}) : super(key: key);
  final String title;
  final String hotelid;

  @override
  _CatButton createState() => _CatButton();
}

class _CatButton extends State<CatButton> {

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        child: Text('nova categoria',style: TextStyle(color: Colors.white)),
        onPressed:  () async => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CatFormPage(hotelid: widget.hotelid))
        )
    );
  }
}

class AppBarAlbum extends AppBar {
  AppBarAlbum({
    Key key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title = const Text('Hotéis Everest'),
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.shape,
    this.backgroundColor = Colors.indigo,
    this.brightness,
    this.iconTheme,
    this.actionsIconTheme,
    this.textTheme,
    this.primary = true,
    this.centerTitle,
    this.titleSpacing = NavigationToolbar.kMiddleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
  }) : assert(automaticallyImplyLeading != null),
        assert(elevation == null || elevation >= 0.0),
        assert(primary != null),
        assert(titleSpacing != null),
        assert(toolbarOpacity != null),
        assert(bottomOpacity != null),
        preferredSize = Size.fromHeight(kToolbarHeight + (bottom?.preferredSize?.height ?? 0.0)),
        super(key: key,
        title:title,
        actions:actions,
        backgroundColor:backgroundColor,
        leading:leading,
        automaticallyImplyLeading:automaticallyImplyLeading,
        actionsIconTheme:actionsIconTheme,
        bottom:bottom,
        elevation:elevation,
        shape:shape,
        bottomOpacity:bottomOpacity,
        brightness:brightness,
        iconTheme:iconTheme,
        textTheme:textTheme,
        primary:primary,
        centerTitle:centerTitle,
        titleSpacing:titleSpacing,
        toolbarOpacity:toolbarOpacity,
        flexibleSpace:flexibleSpace
      );

  final Widget leading;
  final bool automaticallyImplyLeading;
  final Widget title;
  final List<Widget> actions;
  final Widget flexibleSpace;
  final PreferredSizeWidget bottom;
  final double elevation;
  final ShapeBorder shape;
  final Color backgroundColor;
  final Brightness brightness;
  final IconThemeData iconTheme;
  final IconThemeData actionsIconTheme;
  final TextTheme textTheme;
  final bool primary;
  final bool centerTitle;
  final double titleSpacing;
  final double toolbarOpacity;
  final double bottomOpacity;
  @override
  final Size preferredSize;
}