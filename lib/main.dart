import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s93task/controllers/database_controller.dart';
import 'package:s93task/screens/homescreen/home_screen.dart';
import 'package:s93task/services/parser_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseController.instance.init();
  await ParserService.instance.init();
  runApp(GetMaterialApp(home: HomeScreen()));
}
