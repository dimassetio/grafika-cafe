import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grafika_cafe/app/data/helpers/Database.dart';
import 'package:grafika_cafe/app/data/models/log_model.dart';
import 'package:grafika_cafe/app/modules/auth/controllers/auth_controller.dart';
import 'package:nb_utils/nb_utils.dart';

class MenuModel {
  static const ID = "id";
  static const NAME = "name";
  static const HARGA = "harga";
  static const JENIS = "jenis";
  static const KETERANGAN = "keterangan";
  static const PHOTO = "photo";
  static const DATECREATED = "dateCreated";

  String? id;
  String? name;
  int? harga;
  String? jenis;
  String? keterangan;
  String? photo;
  DateTime? dateCreated;
  // bool? isVerified;
  // String last_login;

  MenuModel({
    this.id,
    this.name,
    this.harga,
    this.jenis,
    this.keterangan,
    this.photo,
    this.dateCreated,
  });

  MenuModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? json = snapshot.data() as Map<String, dynamic>?;
    id = snapshot.id;
    name = json?[NAME];
    harga = json?[HARGA];
    jenis = json?[JENIS];
    keterangan = json?[KETERANGAN];
    photo = json?[PHOTO];
    dateCreated = (json?[DATECREATED] as Timestamp?)?.toDate();
  }

  Map<String, dynamic> toJson() {
    return {
      ID: this.id,
      NAME: this.name,
      HARGA: this.harga,
      JENIS: this.jenis,
      KETERANGAN: this.keterangan,
      PHOTO: this.photo,
      DATECREATED: this.dateCreated,
    };
  }

  Database db = Database(
      collectionReference: firestore.collection(
        menuCollection,
      ),
      storageReference: storage.ref(menuCollection));

  Future<MenuModel> save({File? file}) async {
    if (id.isEmptyOrNull) {
      dateCreated = DateTime.now();
    }
    if (id.isEmptyOrNull) {
      id = await db.add(toJson());
      Log.add("${AuthController.instance.user.name} membuat menu baru '$name'")
          .save();
    } else {
      await db.edit(toJson());
      Log.add("${AuthController.instance.user.name} mengedit menu '$name'")
          .save();
    }
    if (file != null && !id.isEmptyOrNull) {
      photo = await db.upload(id: id!, file: file);
      db.edit(toJson());
    }
    return this;
  }

  Future<bool> delete() async {
    if (id.isEmptyOrNull) {
      return false;
    } else {
      await db.delete(id!, url: photo);
      return true;
    }
  }

  Future<MenuModel?> get() async {
    return id.isEmptyOrNull
        ? null
        : MenuModel.fromSnapshot(await db.getID(id!));
  }
}

abstract class Jenis {
  static const makanan = "Makanan";
  static const minuman = "Minuman";

  static const list = [
    makanan,
    minuman,
  ];
}
