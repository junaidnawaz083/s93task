import 'dart:convert';
import 'dart:developer';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:s93task/consts/enums.dart';
import 'package:s93task/models/llm_model.dart';

class LLMService {
  static final LLMService instance = LLMService._internal();

  factory LLMService() {
    return instance;
  }

  LLMService._internal();

  final _apiKey = 'AIzaSyBwcUcND3PPrO7dfyhppTabxJS6y1FZAxc';
  late GenerativeModel _model;

  Future<void> init() async {
    _model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: _apiKey);
  }

  Future<LLMModel?> parseCommand({required String command}) async {
    final prompt =
        'Parse  \'$command\' and output should be only a json obejct with values  (action, title, date, time, decsription,oldTitle,) and formet date and time, ignore seconds';

    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);
    var res = response.text ?? "No relevant information extracted.";
    String result = "${res.substring(res.indexOf('{'), res.indexOf('}'))}}";

    var parserModel = LLMModel.fromJson(
      jsonDecode(result.replaceAll('\n', '')),
    );
    log(parserModel.toJson().toString());
    if (await validateModel(parserModel)) {
      parserModel.status = ParserStatus.success;
    } else {
      parserModel.status = ParserStatus.invalid;
    }
    return parserModel;
  }

  Future<bool> validateModel(LLMModel model) async {
    if (model.action == null || model.action == TaskAction.none) return false;
    if (model.action == TaskAction.create) {
      return model.title != null && model.date != null && model.time != null;
    } else if (model.action == TaskAction.update) {
      return model.title != null ||
          model.date != null ||
          model.time != null ||
          model.description != null;
    } else {
      return model.title != null;
    }
  }
}
