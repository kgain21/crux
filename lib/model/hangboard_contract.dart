import 'package:cloud_firestore/cloud_firestore.dart';

class HangboardContract {
  DocumentReference hangboard;
  CollectionReference maxHangs;

  int depth;
  int resistance;
  int duration;
  int rest;
  int repetitions;
  String grip;

  HangboardContract(
      {this.depth,
      this.resistance,
      this.duration,
      this.rest,
      this.repetitions,
      this.grip});

  CollectionReference createCollection() {
    //CollectionReference hangboardCollection = new CollectionReference();
  }

  //Map<String, Object> maxHangs = LinkedHashMap();
  int sets;
}
