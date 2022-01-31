import 'package:path/path.dart';
import 'package:reminder/event_handler/notification_sender.dart';
import 'package:reminder/model/reminder_model.dart';
import 'package:sqflite/sqflite.dart';

class ReminderDatabase {
  static final ReminderDatabase instance = ReminderDatabase._init();

  static Database? _database;

  ReminderDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('reminder.db');

    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE $tableReminder(
      ${ReminderFields.id} $idType,
      ${ReminderFields.reminderText} $textType,
      ${ReminderFields.reminderDate} $textType,
      ${ReminderFields.isComplete} $boolType,
      ${ReminderFields.nextNotificaitonHour} $integerType
    )
    ''');
  }

  Future<Reminder> create(Reminder reminder) async {
    final db = await instance.database;

    final id = await db.insert(tableReminder, reminder.toJson());

    // final json = note.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');
    var reminderResponse = reminder.copy(id: id);
    sendReminderNotifiction(reminderResponse);
    return reminderResponse;
  }

  Future<Reminder> getReminder(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableReminder,
      columns: ReminderFields.values,
      where: '${ReminderFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Reminder.fromJson(maps.first);
    }

    throw Exception('ID $id not found');
  }

  Future<List<Reminder>> getAllReminder() async {
    final db = await instance.database;

    const orderBy = '${ReminderFields.id} DSEC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');
    final result = await db.query(tableReminder);
    // final result = await db.query(tableReminder, orderBy: orderBy);

    return result.map((json) => Reminder.fromJson(json)).toList();
  }

  Future<List<Reminder>> getCompletedRemidner() async {
    String whereClause = '${ReminderFields.isComplete} = 1';

    return await _getReminder(whereClause);
  }

  Future<List<Reminder>> getPendingReminder() async {
    String whereClause = '${ReminderFields.isComplete} = 0';

    return await _getReminder(whereClause);
  }

  Future<List<Reminder>> _getReminder(String whereClause) async {
    final db = await instance.database;

    // const orderBy = '${ReminderFields.reminderDate} DESC';
    final result =
        await db.rawQuery('SELECT * FROM $tableReminder where $whereClause');

    return result.map((json) => Reminder.fromJson(json)).toList();
  }

  Future<int> update(Reminder reminder) async {
    final db = await instance.database;

    return db.update(
      tableReminder,
      reminder.toJson(),
      where: '${ReminderFields.id} = ?',
      whereArgs: [reminder.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return db.delete(
      tableReminder,
      where: '${ReminderFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
