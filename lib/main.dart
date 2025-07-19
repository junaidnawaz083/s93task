import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:s93task/controllers/database_controller.dart';
import 'package:s93task/screens/homescreen/home_screen.dart';
import 'package:s93task/services/parser_service.dart';

const apiKey = 'AIzaSyBwcUcND3PPrO7dfyhppTabxJS6y1FZAxc';
const command = 'create a task Daily Test at 9 37 am on july 18th 2025';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseController.instance.init();
  await ParserService.instance.init();
  runApp(GetMaterialApp(home: HomeScreen()));
  // final model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: apiKey);
  // try {
  //   final prompt =
  //       'Parse  \'$command\' and output should be only a json obejct with values  (action, title, decsription, time,date, timestemp,oldTitle) if both date and time are null then date time and datetime should be null else   use local date and time to complete fields ';
  //   final content = [Content.text(prompt)];
  //   final response = await model.generateContent(content);
  //   var res = response.text ?? "No relevant information extracted.";
  //   print("${res.substring(res.indexOf('{'), res.indexOf('}'))}}");
  // } catch (e) {
  //   print("Error parsing text with Gemini: $e");
  // }
}
