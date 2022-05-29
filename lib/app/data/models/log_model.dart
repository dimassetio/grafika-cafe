import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grafika_cafe/app/data/helpers/Database.dart';

class Log {
  static const ID = "id";
  static const MESSAGE = "message";
  static const DATE = "date";

  String? id;
  String? message;
  DateTime? date;

  Log({
    this.id,
    this.message,
    this.date,
  });

  Log.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? json = snapshot.data() as Map<String, dynamic>?;
    id = snapshot.id;
    message = json?[MESSAGE];
    date = (json?[DATE] as Timestamp).toDate();
  }

  Map<String, dynamic> toJson() {
    return {
      ID: this.id,
      MESSAGE: this.message,
      DATE: this.date,
    };
  }

  Database db = Database(
    collectionReference: firestore.collection(
      logCollection,
    ),
  );
  Future save() async {
    db.add(toJson());
  }

  Log.add(String value) {
    message = value;
    date = DateTime.now();
  }
}
