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
            onUpgrade: _onUpgrade, // Add this line for database upgrades
        );
    }

Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    try {
        // Debug: Print received email
        print('Received email in getUserByEmail: $email');

        // Obtain the database instance
        final db = await database;

        // Perform a case-insensitive query
        List<Map<String, dynamic>> results = await db.query(
            tableUser,
            where: 'LOWER(email) = LOWER(?)',
            whereArgs: [email],
        );

        // Debug: Print query results
        print('Query results for email: $email: $results');

        // Return the first user record if found
        if (results.isNotEmpty) {
            return results.first;
        }

        print('No user found with email: $email');
        return null;
    } catch (error) {
        print('Error querying user by email: $error');
        return null;
    }
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
                password TEXT,
                profileImage TEXT, -- New column for profile image
                address TEXT -- New column for address
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
          locationLng REAL,
          isRescued INTEGER, -- Add the isRescued column
          postedBy TEXT
      )
  ''');
  print('Stray table created.');
}

    Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
        // Check if the schema needs to be updated
        if (oldVersion < newVersion) {
            // Add columns if they don't already exist
            await db.execute('''
                ALTER TABLE $tableUser
                ADD COLUMN profileImage TEXT
            ''');
            await db.execute('''
                ALTER TABLE $tableUser
                ADD COLUMN address TEXT
            ''');
            print('User table upgraded.');
        }
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

    // Debugging: Print the query results and other information
    print('Querying user by id: $id');
    print('Results: $results');

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

    // User validation
Future<bool> validateUser(String email, String password) async {
    final db = await database; // Ensure you have the database instance

    List<Map<String, dynamic>> results = await db.query(
        tableUser,
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
    );

    // Return true if results are not empty (meaning the user exists)
    return results.isNotEmpty;
}




    // Stray operations
  Future<int> insertStray(Map<String, dynamic> stray) async {
    final db = await database;
    // Ensure 'postedBy' and 'isRescued' are provided correctly in the 'stray' map
    return await db.insert(tableStray, stray);
  }

 // Add a method to retrieve the first three rows from the stray table
    Future<List<Map<String, dynamic>>> getFirstThreeStrays() async {
        final db = await database;
        // Query the first three rows from the stray table
        List<Map<String, dynamic>> results = await db.query(
            tableStray,
            limit: 3, // Limit to the first three rows
        );
        return results;
    }

      // Query all pets from the database
  Future<List<Map<String, dynamic>>> queryAllPets() async {
    final Database db = await instance.database;
    return await db.query('stray');
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
