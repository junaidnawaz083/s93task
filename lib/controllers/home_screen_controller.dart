import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:s93task/consts/enums.dart';
import 'package:s93task/controllers/database_controller.dart';
import 'package:s93task/models/parser_model.dart';
import 'package:s93task/models/task_model.dart';
import 'package:s93task/services/llm_service.dart';
import 'package:s93task/services/speech_to_text_service.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class HomeScreenController extends GetxController {
  bool loading = false;
  final _sst = SpeechToTextService();
  bool animate = false;
  String rescognizedText = '';
  bool isListenCompleted = false;
  ParserStatus status = ParserStatus.none;

  List<TaskModel> taskList = [];

  @override
  void onInit() async {
    super.onInit();
    await _sst.initSTT();
    await readAllTasks();
  }

  Future<void> listenToSpeech() async {
    await _sst.startListening(_onSpeechResult);
  }

  Future<void> _onSpeechResult(SpeechRecognitionResult result) async {
    rescognizedText = result.recognizedWords;
    animate = true;

    if (!await _sst.isListining()) {
      isListenCompleted = true;
      update();
      await parseCommand(command: rescognizedText);
      return;
    } else {}
    update();
  }

  Future<void> parseCommand({required String command}) async {
    LLMModel? model = await LLMService.instance.parseCommand(
      command: rescognizedText.replaceAll('task ', ''),
    );
    if (model == null || model.status == ParserStatus.invalid) {
      status = ParserStatus.invalid;
      update();
      return;
    }
    if (model.status == ParserStatus.success) {
      await processParserModel(model: model);
    }
  }

  Future<void> tryAgain() async {
    status = ParserStatus.none;
    animate = false;
    isListenCompleted = false;
    rescognizedText = '';
    update();
    listenToSpeech();
  }

  Future<void> processParserModel({required LLMModel model}) async {
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

  Future<void> createTask({required LLMModel model}) async {
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

  Future<void> updateTasks({required LLMModel model}) async {
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
      matchedModel.title = model.title;
    }

    if (model.description != null) {
      matchedModel.description = model.description;
    }
    if (model.time != null) {
      matchedModel.time = model.time;
    }
    if (model.date != null) {
      matchedModel.date = model.date;
    }
    matchedModel.timestemp =
        (tryParseDate('${matchedModel.date!} ${matchedModel.time!}') ??
                DateTime.now())
            .microsecondsSinceEpoch;
    await DatabaseController.instance.updateTask(matchedModel);

    await readAllTasks();
    Get.back();
    update();
    Get.showSnackbar(
      GetSnackBar(
        message: 'Task updated successfully',
        icon: Icon(Icons.check, color: Colors.green),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> deleteTasks({required LLMModel model}) async {
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
    await DatabaseController.instance.deleteTask(matchedModel);

    await readAllTasks();
    Get.back();
    update();
    Get.showSnackbar(
      GetSnackBar(
        message: 'Task deleted successfully',
        icon: Icon(Icons.check, color: Colors.green),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<TaskModel?> getMatchingTaskModels({required LLMModel model}) async {
    TaskModel? matchedModel;
    String? title = model.title;
    if (title == null) {
      return null;
    }
    if (model.oldTitle != null) {
      title = model.oldTitle!;
    }
    title = title.toLowerCase();

    matchedModel = taskList.firstWhere(
      (e) => (e.title ?? '').toLowerCase() == title,
      orElse: () => TaskModel(),
    );
    if (matchedModel.id != null) {
      return matchedModel;
    }
    if (title.contains('task')) {
      title = title.replaceFirst('task', '').replaceAll(' ', '');
      matchedModel = taskList.firstWhere(
        (e) => (e.title ?? '').toLowerCase().replaceAll(' ', '') == title,
        orElse: () => TaskModel(),
      );
    }

    return matchedModel.id == null ? null : matchedModel;
  }

  bool checkDate(int index) {
    DateTime time1 = DateTime.fromMicrosecondsSinceEpoch(
      taskList[index].timestemp!,
    );
    DateTime time2 = DateTime.fromMicrosecondsSinceEpoch(
      taskList[index - 1].timestemp!,
    );
    return time1.day != time2.day ||
        time1.month != time2.month ||
        time1.year != time2.year;
  }

  Future<bool> requestMicrophonePermission() async {
    var status = await Permission.microphone.status;

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      PermissionStatus newStatus = await Permission.microphone.request();
      if (newStatus.isGranted) {
        return true;
      } else {
        return false;
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings(); // Opens the app settings for the user to manually enable.
    } else if (status.isRestricted) {
      return false;
    }
    return false;
  }
}
