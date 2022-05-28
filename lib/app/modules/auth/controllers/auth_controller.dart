import 'dart:io';

import 'package:grafika_cafe/app/data/models/user_model.dart';
import 'package:grafika_cafe/app/routes/app_pages.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;

  static AuthController instance = Get.find<AuthController>();

  Stream<User?> streamAuth() => _auth.authStateChanges();

  var _currUser = UserModel().obs;
  UserModel get user => _currUser.value;
  set user(UserModel value) => _currUser.value = value;

  var _isSaving = false.obs;
  bool get isSaving => _isSaving.value;
  set isSaving(value) => _isSaving.value = value;

  late Rx<User?> firebaseUser;
  final count = 0.obs;
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController confirmPasswordC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  bool get isLoggedIn => firebaseUser.value != null;
  signIn() async {
    try {
      isSaving = true;
      await _auth
          .signInWithEmailAndPassword(
              email: emailC.text, password: passwordC.text)
          .then((value) async {
        user.id = value.user?.uid;
        var check = await user.getUser();
        if (check == null) {
          user.role = Role.admin;
          user.email = value.user?.email;
          await user.save();
        } else {
          user = check;
        }
        Get.toNamed(Routes.HOME);
      });
    } on FirebaseAuthException catch (e) {
      Get.snackbar(e.code, e.message ?? '');
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isSaving = false;
      clearController();
    }
  }

  Future signOut() async {
    await _auth.signOut();
    Get.offAllNamed(Routes.AUTH);
  }

  _streamUser(User? firebaseUser) {
    try {
      firebaseUser == null
          ? user = UserModel()
          : _currUser.bindStream(user.db.collectionReference
              .doc(firebaseUser.uid)
              .snapshots()
              .map((event) => UserModel.fromSnapshot(event)));
    } catch (e) {
      user = UserModel();
      // print(e);
    }
  }

  Future<UserCredential?> register(String email, String password, String name,
      String role, File? photo) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    try {
      UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        var newUser = UserModel(
          id: value.user?.uid,
          email: email,
          name: name,
          role: role,
        );
        newUser.db.collectionReference
            .doc(newUser.id)
            .set(newUser.toJson())
            .then((value) {
          Get.back();
          toast("Register Success");
        });

        return value;
      });
      await app.delete();
      return Future.sync(() => userCredential);
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? e.toString());
      print(e.toString());
    }
  }

  clearController() {
    emailC.clear();
    passwordC.clear();
  }

  @override
  void onInit() {
    super.onInit();
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _streamUser);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    clearController();
  }

  // void increment() => count.value++;
}
