import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/report_model.dart';

abstract class ReportsLocalDataSource {
  Future<Database> get database;
  Future<void> cacheReport(ReportModel report);
  Future<List<ReportModel>> getCachedReports();
  Future<void> deleteCachedReport(String id);
  Future<void> clearCache();
}

@LazySingleton(as: ReportsLocalDataSource)
class ReportsLocalDataSourceImpl implements ReportsLocalDataSource {
  static Database? _database;

  @override
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final pathString = join(dbPath, 'incident_reports.db');

    return await openDatabase(
      pathString,
      version: 8,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE reports (
            id TEXT PRIMARY KEY,
            title TEXT,
            description TEXT,
            category TEXT,
            reporter_name TEXT,
            reporter_email TEXT,
            reporter_building TEXT,
            reporter_footbridge TEXT,
            reporter_floor TEXT,
            reporter_apartment TEXT,
            status TEXT,
            status_enum TEXT,
            timestamp INTEGER,
            estate_id TEXT,
            photo_path TEXT,
            latitude REAL,
            longitude REAL,
            assigned_to TEXT,
            assigned_to_user_id TEXT,
            assigned_to_name TEXT,
            assigned_to_role TEXT,
            board_notes TEXT,
            tech_notes TEXT,
            attachments_json TEXT,
            reveal_board_notes_to_tech INTEGER,
            priority TEXT DEFAULT 'normal',
            sla_deadline TEXT,
            csat_rating INTEGER,
            audit_trail TEXT,
            is_synced INTEGER DEFAULT 0
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // v1 -> v2: add is_synced column for offline sync tracking.
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE reports ADD COLUMN is_synced INTEGER DEFAULT 0',
          );
        }
        // v2 -> v3: add estate_id column for multi-estate support.
        if (oldVersion < 3) {
          await db.execute(
            'ALTER TABLE reports ADD COLUMN estate_id TEXT',
          );
        }
        // v3 -> v4: add assigned_to_user_id for technician assignment.
        if (oldVersion < 4) {
          await db.execute(
            'ALTER TABLE reports ADD COLUMN assigned_to_user_id TEXT',
          );
        }
        // v4 -> v5: add status_enum for type-safe status.
        if (oldVersion < 5) {
          await db.execute(
            'ALTER TABLE reports ADD COLUMN status_enum TEXT',
          );
        }
        // v5 -> v6: add assigned_to_name and assigned_to_role display columns.
        if (oldVersion < 6) {
          await db.execute(
            'ALTER TABLE reports ADD COLUMN assigned_to_name TEXT',
          );
          await db.execute(
            'ALTER TABLE reports ADD COLUMN assigned_to_role TEXT',
          );
        }
        // v6 -> v7: add priority, sla_deadline, csat_rating, audit_trail columns.
        if (oldVersion < 7) {
          await db.execute(
            "ALTER TABLE reports ADD COLUMN priority TEXT DEFAULT 'normal'",
          );
          await db.execute(
            'ALTER TABLE reports ADD COLUMN sla_deadline TEXT',
          );
          await db.execute(
            'ALTER TABLE reports ADD COLUMN csat_rating INTEGER',
          );
          await db.execute(
            'ALTER TABLE reports ADD COLUMN audit_trail TEXT',
          );
        }
        // v7 -> v8: drop dead columns (client_notes, notified_roles_json).
        if (oldVersion < 8) {
          await db.execute('ALTER TABLE reports DROP COLUMN client_notes');
          await db.execute('ALTER TABLE reports DROP COLUMN notified_roles_json');
        }
      },
    );
  }

  @override
  Future<void> cacheReport(ReportModel report) async {
    final db = await database;
    // toJson() no longer emits `is_synced` (excluded via @JsonKey) — we persist
    // sync state via an explicit column controlled by the repository.
    final json = report.toJson();
    json['reveal_board_notes_to_tech'] = report.revealBoardNotesToTech ? 1 : 0;
    json['is_synced'] = report.isSynced ? 1 : 0;

    // Convert audit_trail list to JSON string for SQLite
    if (json['audit_trail'] != null) {
      json['audit_trail'] = jsonEncode(json['audit_trail']);
    }

    await db.insert(
      'reports',
      json,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<ReportModel>> getCachedReports() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'reports',
      orderBy: 'timestamp DESC',
    );
    return List.generate(maps.length, (i) {
      final map = Map<String, dynamic>.from(maps[i]);
      // Re-hydrate booleans that SQLite stores as integers.
      map['reveal_board_notes_to_tech'] = map['reveal_board_notes_to_tech'] == 1;
      
      // Decode audit_trail from JSON string back to List
      if (map['audit_trail'] is String && (map['audit_trail'] as String).isNotEmpty) {
        try {
          map['audit_trail'] = jsonDecode(map['audit_trail'] as String);
        } catch (e) {
          map['audit_trail'] = null;
        }
      } else {
        map['audit_trail'] = null;
      }

      final isSynced = map.remove('is_synced') == 1;
      return ReportModel.fromJson(map).copyWith(isSynced: isSynced);
    });
  }

  @override
  Future<void> deleteCachedReport(String id) async {
    final db = await database;
    await db.delete(
      'reports',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> clearCache() async {
    final db = await database;
    await db.delete('reports');
  }
}
