import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s93task/consts/enums.dart';
import 'package:s93task/controllers/database_controller.dart';
import 'package:s93task/models/parser_model.dart';
import 'package:s93task/models/task_model.dart';

class HomeScreenController extends GetxController {
  bool _loading = false;

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
  }

  List<TaskModel> taskList = [];

  @override
  void onInit() async {
    super.onInit();
    await readAllTasks();
  }

  Future<void> processParserModel({required ParserModel model}) async {
    switch (model.action) {
      case null:
        Get.back();
        Get.showSnackbar(
          GetSnackBar(
            message: 'something went wrong',
            icon: Icon(Icons.error, color: Colors.red),
            duration: Duration(seconds: 2),
          ),
        );
        return;

      case TaskAction.create:
        createTask(model: model);
        return;
      case TaskAction.update:
        updateTasks(model: model);
        return;
      case TaskAction.delete:
        deleteTasks(model: model);
        return;
      case TaskAction.none:
        Get.back();
        Get.showSnackbar(
          GetSnackBar(
            message: 'something went wrong',
            icon: Icon(Icons.error, color: Colors.red),
            duration: Duration(seconds: 2),
          ),
        );
        return;
    }
  }

  Future<void> readAllTasks() async {
    loading = true;
    update();
    // taskList.add(
    //   TaskModel(
    //     title: 'Testing Title',
    //     description: 'this is a dummy description,',
    //     date: 'june 11 1996',
    //     time: '12:00 am',
    //     timestemp: DateTime.now().microsecondsSinceEpoch,
    //   ),
    // );
    // taskList.add(
    //   TaskModel(
    //     title: 'Testing Title',
    //     description: 'this is a dummy description,',
    //     date: 'june 11 1996',
    //     time: '12:00 am',
    //     timestemp: DateTime.now().microsecondsSinceEpoch,
    //   ),
    // );
    // taskList.add(
    //   TaskModel(
    //     title: 'Testing Title',
    //     description: 'this is a dummy description,',
    //     date: 'june 11 1996',
    //     time: '12:00 am',
    //     timestemp: DateTime.now().microsecondsSinceEpoch,
    //   ),
    // );
    // taskList.add(
    //   TaskModel(
    //     title: 'Testing Title',
    //     description: 'this is a dummy description,',
    //     date: 'june 11 1996',
    //     time: '12:00 am',
    //     timestemp: DateTime.now().microsecondsSinceEpoch,
    //   ),
    // );
    // taskList.add(
    //   TaskModel(
    //     title: 'Testing Title',
    //     description: 'this is a dummy description,',
    //     date: 'june 11 1996',
    //     time: '12:00 am',
    //     timestemp:
    //         DateTime.now().subtract(Duration(days: 3)).microsecondsSinceEpoch,
    //   ),
    // );
    // taskList.add(
    //   TaskModel(
    //     title: 'Testing Title',
    //     description: 'this is a dummy description,',
    //     date: 'june 11 1996',
    //     time: '12:00 am',
    //     timestemp: DateTime.now().add(Duration(days: 4)).microsecondsSinceEpoch,
    //   ),
    // );

    taskList = await DatabaseController.instance.readAllTasks();
    taskList.sort(
      (a, b) => DateTime.fromMicrosecondsSinceEpoch(
        a.timestemp!,
      ).compareTo(DateTime.fromMicrosecondsSinceEpoch(b.timestemp!)),
    );
    loading = false;
    update();
  }

  Future<void> createTask({required ParserModel model}) async {
    var res = await DatabaseController.instance.createTask(
      TaskModel(
        title: model.title,
        description: model.description,
        date: model.date,
        time: model.time,
        timestemp: model.timestamp,
      ),
    );
    if (res == -1) {
      Get.back();
      Get.showSnackbar(
        GetSnackBar(
          message: 'something went wrong',
          icon: Icon(Icons.error, color: Colors.red),
          duration: Duration(seconds: 2),
        ),
      );
    }
    await readAllTasks();
    Get.back();
    update();
    Get.showSnackbar(
      GetSnackBar(
        message: 'Task added successfully',
        icon: Icon(Icons.check, color: Colors.green),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> updateTasks({required ParserModel model}) async {
    TaskModel? matchedModel = await getMatchingTaskModels(model: model);
    if (matchedModel == null) {
      Get.back();
      Get.showSnackbar(
        GetSnackBar(
          message: 'Task not found',
          icon: Icon(Icons.error, color: Colors.yellow),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    if (model.title != null) {
      matchedModel.time = model.title;
    }
    if (model.description != null) {
      matchedModel.description = model.description;
    }
    if (model.time != null) {
      matchedModel.time = model.time;
    }
    if (model.date != null) {
      matchedModel.date = model.date;
      matchedModel.timestemp = model.timestamp;
    }
    await DatabaseController.instance.updateTask(matchedModel);

    await readAllTasks();
    Get.back();
    update();
    Get.showSnackbar(
      GetSnackBar(
        message: 'Task added successfully',
        icon: Icon(Icons.check, color: Colors.green),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> deleteTasks({required ParserModel model}) async {}

  Future<TaskModel?> getMatchingTaskModels({required ParserModel model}) async {
    TaskModel? matchedModel;
    if (model.title != null) {
      matchedModel = taskList.firstWhere(
        (e) =>
            (e.title ?? '').toLowerCase() == (model.title ?? '').toLowerCase(),
      );
    }

    return matchedModel;
  }
}
