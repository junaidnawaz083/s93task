import 'package:s93task/consts/enums.dart';
import 'package:intl/intl.dart';

class LLMModel {
  TaskAction? action;
  String? title;
  String? oldTitle;

  String? date;
  String? time;
  String? description;
  int? timestamp;
  ParserStatus? status;

  LLMModel({
    this.action,
    this.title,
    this.date,
    this.time,
    this.description,
    this.timestamp,
    this.oldTitle,
    this.status,
  });

  LLMModel.fromJson(Map<String, dynamic> json) {
    try {
      action =
          json['action'] == null
              ? null
              : TaskAction.values.byName(json['action']);
    } catch (e) {
      action = TaskAction.none;
    }
    title = json['title'];
    oldTitle = json['oldTitle'];

    description = json['description'];

    time = json['time'];
    if (time == null) return;
    time = time!.replaceAll('p.m.', 'PM');
    time = time!.replaceAll('a.m.', 'AM');
    date = json['date'];
    if (date == null) return;
    DateTime? datetime = tryParseDate('${date!} ${time!}');

    if (datetime == null) return;

    timestamp = datetime.microsecondsSinceEpoch;
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
}

DateTime? tryParseDate(String input) {
  List<String> timeFormets = [
    'HH:mm',
    'h:mm a',
    'h:mm aaaa',
    'HH:mm:ss',
    'h a',
  ];
  List<String> dateFormats = [
    'EEEE, MMM d, yyyy',
    'MM-dd-yyyy',
    'd MMM yyyy',
    'd MM, yyyy',
    'd MMM, yyyy',

    'd MM yyyy',
    "yyyy-MM-dd",
    'yyyy/MM/dd',
    'yyyy-MM-dd',
    'dd.MM.yy',
    "MM/dd/yyyy",
    "dd-MM-yyyy",
    "MMMM d, yyyy",
    "EEE, d MMM yyyy",
  ];
  input = input.replaceAll('p.m.', 'PM');
  input = input.replaceAll('a.m.', 'AM');

  for (String date in dateFormats) {
    for (String time in timeFormets) {
      try {
        return DateFormat('$date $time').parseStrict(input);
      } catch (_) {
        continue;
      }
    }
  }
  return null;
}
