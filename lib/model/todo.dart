class ToDo {
  String? id;
  String? todoText;
  String? date;
  bool isDone;

  ToDo({
    required this.id,
    required this.todoText,
    required this.date,
    this.isDone = false,
  });
  static List<ToDo> todoList(){
    return 
    [
      // ToDo(id: "01", todoText: "Makan", date: "", isDone: true),
      // ToDo(id: "02", todoText: "Minum", date: "", isDone: true),
      // ToDo(id: "03", todoText: "Malas", date: ""),
      // ToDo(id: "04", todoText: "Mandi", date: "",),
      // ToDo(id: "05", todoText: "Main", date: "",),
      // ToDo(id: "06", todoText: "Main", date: "",),
      // ToDo(id: "07", todoText: "Main", date: "",),
      // ToDo(id: "08", todoText: "Main", date: "",),
      // ToDo(id: "09", todoText: "Main", date: "",),
      // ToDo(id: "010", todoText: "Main", date: "",),
    ];
  }
}