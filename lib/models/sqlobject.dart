abstract class SQLObject {

  // convert to and from dict type
  Map<String, dynamic> toMap();
  SQLObject.fromMap(Map<String, dynamic> res);

  // print
  @override
  String toString();

}