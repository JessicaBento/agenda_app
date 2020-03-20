import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imagemColumn = "imagemColumn";

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await initDatabase();
      return _database;
    }
  }

  Future <Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "contacts.db");

    return await openDatabase(
        path, version: 1, onCreate: (Database database, int newrVersion) async {
      await database.execute(
          "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT"
              "$phoneColumn TEXT, $imagemColumn TEXT)"
      );
    });
  }

  Future<Contact> saveContact(Contact contact) async {
    Database dbContact = await database;
    contact.id = await dbContact.insert(contactTable, contact.toMap());
    return contact;
  }

  Future<Contact> getContact(int id) async {
    Database dbContact = await database;
    List<Map> maps = await dbContact.query(contactTable,
        columns: [idColumn, nameColumn, emailColumn, phoneColumn, imagemColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Contact.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteContact(int id) async {
    Database dbContact = await database;
    return await dbContact.delete(
        contactTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateContact(Contact contact) async {
    Database dbContact = await database;
    return await dbContact.update(
        contactTable, contact.toMap(), where: "$idColumn = ?",
        whereArgs: [contact.id]);
  }
  Future<List> getAllContacts(Contact contact) async {
    Database dbContact = await database;
    List listMap = await dbContact.rawQuery("SELLECT * FROM $contactTable");
    List<Contact> listContact = List();
    for (Map m in listMap) {
      listContact.add(Contact.fromMap(m));
    }
    return listContact;
  }
  Future<int> getNumber() async {
    Database dbContact = await database;
    return Sqflite.firstIntValue(
        await dbContact.rawQuery("SELECT COUNT (*) FROM $contactTable"));
  }
  Future close() async{
    Database dbContact = await database;
    dbContact.close();
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