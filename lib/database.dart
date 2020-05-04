import 'dart:async';
import 'dart:html';
import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart' as fs;
import 'package:picture_album/model.dart';

abstract class BaseDB {
  Future deleteHotel(String id);
  Future deleteCat(String hid, String id);
  Stream<fs.QuerySnapshot> getHoteis();
  Future<void> addHotel(Hotel hotel, Blob image);
  Future<void> addCat(Categoria cat, String hotelid, Blob image);
  Future<void> addFoto(String catid, String hotelid, Blob image);
  Future<void> updateHotel(Hotel hotel);
  Future<Uri> getUrlFromFile(String filename);
  Stream<fs.QuerySnapshot> getCatFromHotel(String id);
  Stream<fs.QuerySnapshot> getFotosFromCat(String hotelid, String catid);
}

class FireService implements BaseDB {
  fs.Firestore store;
  Storage fbstorage;

  FireService() {
    store = firestore();
    store.enablePersistence();
    fbstorage = storage();
  }

  @override
  Stream<fs.QuerySnapshot> getHoteis() {
    return store.collection('hoteis').onSnapshot;
  }

  @override
  Stream<fs.QuerySnapshot> getCatFromHotel(String id) {
    return store
        .collection('hoteis')
        .doc(id)
        .collection('categorias')
        .onSnapshot;
  }

  @override
  Stream<fs.QuerySnapshot> getFotosFromCat(String hotelid, String catid) {
    return store
        .collection('hoteis')
        .doc(hotelid)
        .collection('categorias')
        .doc(catid)
        .collection('fotos')
        .onSnapshot;
  }

  @override
  Future deleteHotel(String id) {
    return store.collection('hoteis').doc(id).delete();
  }

  @override
  Future deleteCat(String hid, String id) {
    return store
        .collection('hoteis')
        .doc(hid)
        .collection('categorias')
        .doc(id)
        .delete();
  }

  @override
  Future addHotel(Hotel hotel, Blob image) async {
    String filename =
        'album/' + DateTime.now().millisecondsSinceEpoch.toString();
    fbstorage.ref(filename).put(image).future.then((onValue) {
      getUrlFromFile(filename).then((onData) {
        hotel.imageUrl = onData.toString();
        store.collection('hoteis').add(hotel.toJson()).then((data) {
          store.collection('hoteis').doc(data.id).update(data: {'id': data.id});
        });
      });
    });
  }

  @override
  Future addCat(Categoria cat, String hotelid, Blob image) async {
    String filename =
        'album/' + DateTime.now().millisecondsSinceEpoch.toString();
    fbstorage.ref(filename).put(image).future.then((onValue) {
      getUrlFromFile(filename).then((onData) {
        cat.imageurl = onData.toString();
        store
            .collection('hoteis')
            .doc(hotelid)
            .collection('categorias')
            .add(cat.toJson())
            .then((data) {
          store
              .collection('hoteis')
              .doc(hotelid)
              .collection('categorias')
              .doc(data.id)
              .update(data: {'id': data.id});
        });
      });
    });
  }

  @override
  Future updateHotel(Hotel hotel) async {
    store
        .collection('hoteis')
        .where('nome', '==', hotel.nome)
        .onSnapshot
        .first
        .then((querysnapshot) {
      store
          .collection('hoteis')
          .doc(querysnapshot.docs[0].id)
          .update(data: hotel.toJson());
    });
  }

  @override
  Future<Uri> getUrlFromFile(String filename) async {
    return await fbstorage.ref(filename).getDownloadURL();
  }

  @override
  Future addFoto(String catid, String hotelid, Blob image) {
    String filename =
        'album/' + DateTime.now().millisecondsSinceEpoch.toString();
    fbstorage.ref(filename).put(image).future.then((onValue) {
      getUrlFromFile(filename).then((onData) {
        store
            .collection('hoteis')
            .doc(hotelid)
            .collection('categorias')
            .doc(catid)
            .collection('fotos')
            .add({'url': onData.toString()});
      });
    });
  }
}

final FireService fireService = FireService();
