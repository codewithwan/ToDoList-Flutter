class ToDo {
  String? id;
  String? todoText;
  bool isDone;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
  });
  static List<ToDo> todoList(){
    return [
      ToDo(id: "01", todoText: "Makan", isDone: true),
      ToDo(id: "02", todoText: "Minum", isDone: true),
      ToDo(id: "03", todoText: "Malas"),
      ToDo(id: "04", todoText: "Mandi"),
      ToDo(id: "05", todoText: "Main"),
      ToDo(id: "06", todoText: "Main"),
      ToDo(id: "07", todoText: "Main"),
      ToDo(id: "08", todoText: "Main"),
      ToDo(id: "09", todoText: "Main"),
      ToDo(id: "010", todoText: "Main"),
    ];
  }
}