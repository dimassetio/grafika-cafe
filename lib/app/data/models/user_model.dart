import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grafika_cafe/app/data/helpers/Database.dart';
import 'package:nb_utils/nb_utils.dart';

class UserModel {
  static const ID = "id";
  static const NAME = "name";
  static const EMAIL = "email";
  static const ROLE = "role";
  static const PHOTO = "photo";

  String? id;
  String? name;
  String? email;
  String? role;
  String? photoUrl;
  // bool? isVerified;
  // String last_login;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.role,
    this.photoUrl,
  });

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? json = snapshot.data() as Map<String, dynamic>?;
    id = snapshot.id;
    name = json?[NAME];
    email = json?[EMAIL];
    role = json?[ROLE];
  }

  Map<String, dynamic> toJson() {
    return {
      ID: this.id,
      NAME: this.name,
      EMAIL: this.email,
      ROLE: this.role,
      PHOTO: this.photoUrl,
    };
  }

  bool hasRole(String value) {
    return role == value;
  }

  Database db = Database(
      collectionReference: firestore.collection(
        userCollection,
      ),
      storageReference: storage.ref(userCollection));

  Future<UserModel> save({File? file}) async {
    id.isEmptyOrNull ? id = await db.add(toJson()) : await db.edit(toJson());
    if (file != null && !id.isEmptyOrNull) {
      photoUrl = await db.upload(id: id!, file: file);
      db.edit(toJson());
    }
    return this;
  }

  Future<UserModel?> getUser() async {
    return id.isEmptyOrNull
        ? null
        : UserModel.fromSnapshot(await db.getID(id!));
  }
}

abstract class Role {
  static const admin = "Admin";
  static const kasir = "Kasir";
  static const manajer = "Manajer";

  static const list = [
    admin,
    manajer,
    kasir,
  ];
}
