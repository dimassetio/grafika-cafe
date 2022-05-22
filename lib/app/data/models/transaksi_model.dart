import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grafika_cafe/app/data/helpers/Database.dart';
import 'package:grafika_cafe/app/data/models/menu_model.dart';
import 'package:nb_utils/nb_utils.dart';

class TransaksiModel {
  static const ID = "id";
  static const NOMEJA = "noMeja";
  static const USERID = "userId";
  static const TOTALHARGA = "totalHarga";
  static const DATECREATED = "dateCreated";

  String? id;
  String? noMeja;
  String? userId;
  int? totalHarga;
  List<DetailTransaksi>? detailTransaksi;

  DateTime? dateCreated;

  TransaksiModel({
    this.id,
    this.noMeja,
    this.userId,
    this.totalHarga,
    this.dateCreated,
    this.detailTransaksi,
  });

  TransaksiModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? json = snapshot.data() as Map<String, dynamic>?;
    id = snapshot.id;
    noMeja = json?[NOMEJA];
    userId = json?[USERID];
    totalHarga = json?[TOTALHARGA];
    dateCreated = (json?[DATECREATED] as Timestamp?)?.toDate();
  }

  Map<String, dynamic> toJson() {
    return {
      ID: this.id,
      NOMEJA: this.noMeja,
      USERID: this.userId,
      TOTALHARGA: this.totalHarga,
      DATECREATED: this.dateCreated,
    };
  }

  Database db = Database(
      collectionReference: firestore.collection(
        transaksiCollection,
      ),
      storageReference: storage.ref(transaksiCollection));

  Future<TransaksiModel> save({File? file}) async {
    if (id.isEmptyOrNull) {
      dateCreated = DateTime.now();
    }
    id.isEmptyOrNull ? id = await db.add(toJson()) : await db.edit(toJson());
    if (file != null && !id.isEmptyOrNull) {
      // photo = await db.upload(id: id!, file: file);
      db.edit(toJson());
    }
    return this;
  }

  Future<bool> delete() async {
    if (id.isEmptyOrNull) {
      return false;
    } else {
      await db.delete(
        id!,
      );
      return true;
    }
  }

  Future<TransaksiModel?> get() async {
    return id.isEmptyOrNull
        ? null
        : TransaksiModel.fromSnapshot(await db.getID(id!));
  }
}

class DetailTransaksi {
  static const ID = "id";
  static const MENUID = "menuId";
  static const JUMLAH = "jumlah";
  static const SUBTOTALHARGA = "subTotalharga";
  static const DATECREATED = "dateCreated";

  TransaksiModel transaksi;
  String? id;
  String? menuId;
  int? jumlah;
  int? subTotalHarga;
  MenuModel? menuModel;
  DateTime? dateCreated;

  DetailTransaksi({
    required this.transaksi,
    this.id,
    this.menuId,
    this.jumlah,
    this.subTotalHarga,
    this.menuModel,
    this.dateCreated,
  });

  DetailTransaksi fromSnapshot(
      DocumentSnapshot snapshot, TransaksiModel transaksi) {
    Map<String, dynamic>? json = snapshot.data() as Map<String, dynamic>?;
    transaksi = transaksi;
    id = snapshot.id;
    menuId = json?[MENUID];
    jumlah = json?[JUMLAH];
    subTotalHarga = json?[SUBTOTALHARGA];
    dateCreated = (json?[DATECREATED] as Timestamp?)?.toDate();
    return this;
  }

  Map<String, dynamic> toJson() {
    return {
      ID: this.id,
      MENUID: this.menuId ?? this.menuModel?.id,
      JUMLAH: this.jumlah,
      SUBTOTALHARGA: this.subTotalHarga,
      DATECREATED: this.dateCreated,
    };
  }

  Database get db => Database(
        collectionReference: firestore
            .collection(detailTransaksiCollection)
            .doc(transaksi.id)
            .collection(detailTransaksiCollection),
      );
  Future<DetailTransaksi> save({File? file}) async {
    if (id.isEmptyOrNull) {
      dateCreated = DateTime.now();
    }
    id.isEmptyOrNull ? id = await db.add(toJson()) : await db.edit(toJson());
    if (file != null && !id.isEmptyOrNull) {
      // photo = await db.upload(id: id!, file: file);
      db.edit(toJson());
    }
    return this;
  }

  Future<bool> delete() async {
    if (id.isEmptyOrNull) {
      return false;
    } else {
      await db.delete(
        id!,
      );
      return true;
    }
  }

  Future<TransaksiModel?> get() async {
    return id.isEmptyOrNull
        ? null
        : TransaksiModel.fromSnapshot(await db.getID(id!));
  }
}
