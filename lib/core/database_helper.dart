import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  initDb() async {
    String path = join(await getDatabasesPath(), "telegram.db");
    return await openDatabase(
      path, 
      version: 1, 
      onConfigure: (db) async {
        // تفعيل مفاتيح الربط الخارجية (مهم جداً للعلاقات بين الجداول)
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        // 1. جدول المستخدمين (جهات الاتصال + المجموعات)
        // نستخدم عمود 'phone' لتمييز المجموعات بكلمة 'Group'
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT, 
            phone TEXT, 
            image TEXT,
            last_msg TEXT DEFAULT 'No messages yet'
          )
        ''');

        // 2. جدول الرسائل (علاقة One-to-Many مع جدول users)
        await db.execute('''
          CREATE TABLE messages (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            text TEXT, 
            is_read INTEGER DEFAULT 0,
            FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
          )
        ''');

        // 3. جدول بياناتك الشخصية (Profile)
        await db.execute('''
          CREATE TABLE profile (
            id INTEGER PRIMARY KEY, 
            name TEXT, 
            phone TEXT, 
            image TEXT
          )
        ''');

        // 4. جدول المستخدمين المسجلين (Login/Register)
        await db.execute('''
          CREATE TABLE auth_users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE,
            password TEXT,
            name TEXT
          )
        ''');

        // 5. جدول المجموعات (لتخزين بيانات المجموعات بشكل منفصل)
        await db.execute('''
          CREATE TABLE groups (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            group_name TEXT,
            group_image TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
          )
        ''');

        // 6. جدول أعضاء المجموعات (علاقة Many-to-Many بين المجموعات والمستخدمين)
        await db.execute('''
          CREATE TABLE group_members (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            group_id INTEGER,
            user_id INTEGER,
            FOREIGN KEY (group_id) REFERENCES groups (id) ON DELETE CASCADE,
            FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }
}