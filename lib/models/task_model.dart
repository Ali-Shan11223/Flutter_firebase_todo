class TaskModel {
  String? taskId;
  String? taskName;
  int? dateTime;

  TaskModel(
      {required this.taskId, required this.taskName, required this.dateTime});

  factory TaskModel.fromMap(Map<Object?, dynamic> map) {
    return TaskModel(
        taskId: map['taskId'],
        taskName: map['taskName'],
        dateTime: map['dateTime']);
  }
}
