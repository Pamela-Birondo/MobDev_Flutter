import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
    static final _databaseName = 'my_database.db';
    static final _databaseVersion = 1;

    static final tableUser = 'user';
    static final tableStray = 'stray';

    static Database? _database;

    DatabaseHelper._privateConstructor();
    static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

    Future<Database> get database async {
        if (_database != null) return _database!;
        _database = await _initDatabase();
        return _database!;
    }

    Future<Database> _initDatabase() async {
        String dbPath = await getDatabasesPath();
        String path = join(dbPath, _databaseName);
        print('Database file path: $path');
        return openDatabase(
            path,
            version: _databaseVersion,
            onCreate: _onCreate,
        );
    }

    Future<void> _onCreate(Database db, int version) async {
        print('Creating tables...');
        await _createUserTable(db);
        await _createStrayTable(db);
        print('Tables created.');
    }

    Future<void> _createUserTable(Database db) async {
        await db.execute('''
            CREATE TABLE $tableUser (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT,
                username TEXT,
                email TEXT,
                phone TEXT,
                password TEXT
            )
        ''');
        print('User table created.');
    }

    Future<void> _createStrayTable(Database db) async {
        await db.execute('''
            CREATE TABLE $tableStray (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                images TEXT,
                date TEXT DEFAULT CURRENT_TIMESTAMP,
                gender TEXT,
                size TEXT,
                breed TEXT,
                color TEXT,
                actionTaken TEXT,
                condition TEXT,
                details TEXT,
                locationLat REAL,
                locationLng REAL
            )
        ''');
        print('Stray table created.');
    }

    // User operations
    Future<int> insertUser(Map<String, dynamic> user) async {
        final db = await database;
        return await db.insert(tableUser, user);
    }

    Future<List<Map<String, dynamic>>> getUsers() async {
        final db = await database;
        return await db.query(tableUser);
    }

    Future<Map<String, dynamic>?> getUserById(int id) async {
        final db = await database;
        List<Map<String, dynamic>> results = await db.query(
            tableUser,
            where: 'id = ?',
            whereArgs: [id],
        );
        if (results.isNotEmpty) {
            return results.first;
        }
        return null;
    }

    Future<int> updateUser(int id, Map<String, dynamic> user) async {
        final db = await database;
        return await db.update(
            tableUser,
            user,
            where: 'id = ?',
            whereArgs: [id],
        );
    }

    Future<int> deleteUser(int id) async {
        final db = await database;
        return await db.delete(
            tableUser,
            where: 'id = ?',
            whereArgs: [id],
        );
    }

Future<bool> validateUser(String email, String password) async {
    // Get the database instance
    final db = await database;

    // Query the user table for a user with the provided email and password
    List<Map<String, dynamic>> results = await db.query(
        tableUser,
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
    );

    // Return true if a matching user is found, false otherwise
    return results.isNotEmpty;
}

    // Stray operations
    Future<int> insertStray(Map<String, dynamic> stray) async {
        final db = await database;
        return await db.insert(tableStray, stray);
    }

    Future<List<Map<String, dynamic>>> getStrays() async {
        final db = await database;
        return await db.query(tableStray);
    }

    Future<Map<String, dynamic>?> getStrayById(int id) async {
        final db = await database;
        List<Map<String, dynamic>> results = await db.query(
            tableStray,
            where: 'id = ?',
            whereArgs: [id],
        );
        if (results.isNotEmpty) {
            return results.first;
        }
        return null;
    }

    Future<int> updateStray(int id, Map<String, dynamic> stray) async {
        final db = await database;
        return await db.update(
            tableStray,
            stray,
            where: 'id = ?',
            whereArgs: [id],
        );
    }

    Future<int> deleteStray(int id) async {
        final db = await database;
        return await db.delete(
            tableStray,
            where: 'id = ?',
            whereArgs: [id],
        );
    }
}
