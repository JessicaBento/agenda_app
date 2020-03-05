import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imagemColumn = "imagemColumn";

class ContactHelper{
  static final ContactHelper _instance = ContactHelper.internal();
  factory ContactHelper() => _instance;
  ContactHelper.internal();

  Database _database;
  Future<Database>get database async{
    if(_database!=null){
      return _database;
    }else{
      _database = await initDatabase();
      return _database;
    }
  }
  Future <Database> initDatabase() async{
    final databasesPath = await getDatabasesPath();
    final path = join (databasesPath, "contacts.db");
    
    return await openDatabase(path, version: 1, onCreate: (Database database, int newrVersion)async {
      await database.execute("CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT"
      "$phoneColumn TEXT, $imagemColumn TEXT)"
          );
    });
  }



}
class Contact{
  int id;
  String name;
  String email;
  String phone;
  String imagem;

  Contact.fromMap(Map map){
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    imagem = map[imagemColumn];

  }

  Map toMap(){
    Map<String, dynamic>map={
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imagemColumn: imagem
    };
    if (id != null){
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, imagem: $imagem)";
  }

}