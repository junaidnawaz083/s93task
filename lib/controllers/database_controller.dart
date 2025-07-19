import 'package:s93task/models/task_model.dart';
import 'package:s93task/services/database_service.dart';

class DatabaseController {
  static final DatabaseController instance = DatabaseController._internal();
  factory DatabaseController() {
    return instance;
  }
  DatabaseController._internal();
  late DatabaseService _db;

  Future<void> init() async {
    _db = DatabaseService();
    await _db.init();
  }

  Future<int> createTask(TaskModel model) async {
    return _db.createTask(model);
  }

  Future<int> updateTask(TaskModel model) async {
    return _db.updateTask(model);
  }

  Future<int> deleteTask(TaskModel model) async {
    return _db.deleteTask(model);
  }

  Future<List<TaskModel>> readAllTasks() async {
    return _db.readAllTasks();
  }
}
