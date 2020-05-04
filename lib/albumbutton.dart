import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class AlbumButton extends StatefulWidget {
  AlbumButton({@required this.text, @required this.onPressed});
  final String text;
  final VoidCallback onPressed;

  @override
  State<StatefulWidget> createState() => _AlbumButtonState();
}

class _AlbumButtonState extends State<AlbumButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(5),
        child: FlatButton(
          shape: StadiumBorder(side: BorderSide(width: 1, color: Colors.white)),
          color: Colors.indigo,
          onPressed: widget.onPressed,
          child: Text(widget.text, style: TextStyle(color: Colors.white)),
        ));
  }
}
