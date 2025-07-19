import 'dart:developer';

import 'package:s93task/models/task_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  Database? _db;
  Future<void> init() async {
    if (_db != null) {
      closeDatabse();
    }
    _db = await openDatabase(
      'task1.db',

      version: 1,
      onCreate: (a, version) async {
        await a.execute(
          'CREATE TABLE Task (id INTEGER PRIMARY KEY, title TEXT, description TEXT,date TEXT, time TEXT,timestemp INTEGER)',
        );
      },
    );
  }

  Future<List<TaskModel>> readAllTasks() async {
    List<TaskModel> list = [];
    var result = await _db!.query('Task');
    for (var e in result) {
      list.add(TaskModel.fromJson(e));
    }
    return list;
  }

  Future<int> createTask(TaskModel model) async {
    if (_db == null) {
      return -1;
    }
    try {
      int id = await _db!.insert('Task', model.toJson());
      return id;
    } catch (e) {
      log('Error while adding Recovery   $e');
    }
    return -1;
  }

  Future<int> updateTask(TaskModel model) async {
    if (_db == null) {
      return -1;
    }
    try {
      int id = await _db!.update(
        'Task',
        model.toJson(),
        where: 'id = ${model.id}',
      );
      return id;
    } catch (e) {
      log('Error while updating Task :   $e');
    }
    return -1;
  }

  Future<int> deleteTask(TaskModel model) async {
    if (_db == null) {
      return -1;
    }
    try {
      int id = await _db!.delete('Task', where: 'id = ${model.id}');
      return id;
    } catch (e) {
      log('Error while updating Task :   $e');
    }
    return -1;
  }

  Future<void> closeDatabse() async {
    await _db!.close();
  }
}
