import 'package:s93task/consts/enums.dart';
import 'package:intl/intl.dart';

class ParserModel {
  TaskAction? action;
  String? title;
  String? date;
  String? time;
  String? description;
  int? timestamp;
  ParserStatus? status;

  ParserModel({
    this.action,
    this.title,
    this.date,
    this.time,
    this.description,
    this.timestamp,
    this.status,
  });

  ParserModel.fromJson(Map<String, dynamic> json) {
    try {
      action =
          json['action'] == null
              ? null
              : TaskAction.values.byName(json['action']);
    } catch (e) {
      print(e);
      action = TaskAction.none;
    }
    title = json['title'];
    date = json['date'];
    time = json['time'];
    description = json['description'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['action'] = action?.name;
    data['title'] = title;
    data['date'] = date;
    data['time'] = time;
    data['description'] = description;
    data['timestamp'] = timestamp;
    return data;
  }

  DateTime? tryParseDate(String input) {
    List<String> formats = [
      "yyyy-MM-dd HH:mm:ss",
      "yyyy-MM-dd",
      "MM/dd/yyyy",
      "dd-MM-yyyy",
      "MMMM d, yyyy h:mm a", // July 19, 2025 2:30 PM
      "EEE, d MMM yyyy HH:mm:ss", // Sat, 19 Jul 2025 14:30:00
    ];

    for (String format in formats) {
      try {
        return DateFormat(format).parseStrict(input);
      } catch (_) {
        continue;
      }
    }
    return null; // or throw an error
  }
}
