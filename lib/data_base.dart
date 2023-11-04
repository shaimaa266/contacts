


import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'model.dart';


String contactName = 'name';
final String contactId = 'id';
final String contactNumber = 'number';
final dynamic contactImage = 'image';

class DataBase {
  late Database db;
  static final DataBase instance = DataBase._internal();

  factory DataBase() {
    return instance;
  }
 DataBase._internal();

  Future open() async {
    db = await openDatabase(join(await getDatabasesPath(), 'contacts.db'),
        version: 1, onCreate: (Database db, int version) async {
          await db.execute('''
create table ContactTable ( 
  $contactId integer primary key autoincrement,
  $contactName text not null,
  $contactNumber integer not null,
  $contactImage text not null
  )
''');
        });
  }

  Future<ContactModel> insert(ContactModel contactModel) async {
 contactModel.id = await db.insert('ContactTable', contactModel.toMap());
    return contactModel;
  }

  Future<List<ContactModel>> getContact() async {
    List<Map<String, dynamic>> maps = await db.query('ContactTable');
    if (maps.isEmpty)
      return [];
    else {
      List<ContactModel> contacts = [];
      maps.forEach((element) {
        contacts.add(ContactModel.fromMap(element as Map<String, dynamic>));
      });
      print(maps);
      return contacts;
    }
  }

  Future<int> delete(int? id) async {
    return await db
        .delete('ContactTable', where: '$contactId = ?', whereArgs: [id]);
  }

  Future<int> update(ContactModel contactModel) async {
    return await db.update('ContactTable', contactModel.toMap(),
        where: '$contactId = ?', whereArgs: [contactModel.id]);
  }

  Future close() async => db.close();
}