import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:picture_album/albumbutton.dart';

class UploadWidget extends StatefulWidget {
  UploadWidget({Key key, this.title, this.onPressed}) : super(key: key);
  final String title;

  final void Function(html.Blob) onPressed;

  @override
  _UploadWidget createState() => _UploadWidget();
}

class _UploadWidget extends State<UploadWidget> {
  String filename;
  html.Blob blob;

  @override
  void initState() {
    filename = 'nenhum';
    super.initState();
  }

  Future<html.Blob> getFile() {
    final completer = new Completer<html.Blob>();
    final html.InputElement input = html.document.createElement('input');
    input
      ..type = 'file'
      ..accept = 'image/*';
    input.onChange.listen((e) async {
      final List<html.File> files = input.files;
      //final reader = new FileReader();
      setState(() {
        filename = files[0].name;
      });
      //reader.readAsDataUrl(files[0]);
      //reader.onError.listen((error) => completer.completeError(error));
      //await reader.onLoad.first;
      completer.complete(files[0]);
    });
    input.click();
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Colors.indigo),
        child: Row(children: <Widget>[
          AlbumButton(
              text: 'Arquivo',
              onPressed: () =>
                  getFile().then((onValue) => widget.onPressed(onValue))),
          Text(
            filename,
            overflow: TextOverflow.fade,
            style: TextStyle(color: Colors.white),
          )
        ]));
  }
}
