class TaskModel {
  String? title;
  String? date;
  String? time;
  String? description;
  int? timestemp;
  int? id;

  TaskModel({
    this.id,
    this.title,
    this.date,
    this.time,
    this.description,
    this.timestemp,
  });

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    date = json['date'];
    time = json['time'];
    description = json['description'];
    timestemp = json['timestemp'] ?? DateTime.now().microsecondsSinceEpoch;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['title'] = title;
    data['date'] = date;
    data['time'] = time;
    data['description'] = description;
    data['timestemp'] = timestemp;
    return data;
  }
}
