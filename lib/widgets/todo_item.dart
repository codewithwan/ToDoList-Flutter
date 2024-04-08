import 'package:flutter/material.dart';
import '../model/todo.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final onToDoChanged;
  final onDeleteItem;
  // final bool isCalendar;

  const ToDoItem(
      {Key? key,
      required this.todo,
      required this.onToDoChanged,
      required this.onDeleteItem,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: ListTile(
          onLongPress: () {
            print("object"); 
          },
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          tileColor:
              todo.isDone ? Color.fromARGB(255, 16, 16, 16) : Colors.white10,
          leading: IconButton(
            style: ButtonStyle(padding: MaterialStatePropertyAll(EdgeInsets.zero)),
            icon:Icon( todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,),
            onPressed: () {
              onToDoChanged(todo);
            },
            color: Colors.amber,
          ),
          title: Text(
            todo.todoText!,
            style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                decoration: todo.isDone ? TextDecoration.lineThrough : null,
                decorationColor: Colors.white),
          ),
          subtitle: Text(
            todo.date!,
            style: TextStyle(color: Colors.white38),
          ),
          // trailing: Container(
          //   padding: const EdgeInsets.all(0),
          //   margin: const EdgeInsets.symmetric(vertical: 12),
          //   width: 35,
          //   height: 35,
          //   decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(10), color: Colors.white10),
          //   child: IconButton(
          //       onPressed: () {
          //         // print("klik");
          //         onDeleteItem(todo.id);
          //       },
          //       icon: const Icon(
          //         Icons.delete,
          //         size: 20,
          //       )),
          // ),
        ));
  }
}
