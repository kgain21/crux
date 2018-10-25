import 'package:cloud_firestore/cloud_firestore.dart';

class HangboardContract {
  DocumentReference hangboard;
  CollectionReference maxHangs;

  //Map<String, Object> maxHangs = LinkedHashMap();
  int sets;
}
