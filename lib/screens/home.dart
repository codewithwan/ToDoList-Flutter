import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/todo.dart';
import '../widgets/todo_item.dart';
// import 'package:todolist/constants/color.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todosList = ToDo.todoList();
  final _todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: _buildAppBar(),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  searchBox(),
                  Expanded(
                      child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 30, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "All ToDos",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.date_range,
                                  color: Colors.white70,
                                ))
                          ],
                        ),
                      ),
                      for (ToDo todoo in todosList)
                        ToDoItem(
                          todo: todoo,
                          onToDoChanged: _handleToDoChange,
                          onDeleteItem: _deleteToDoItem,
                        ),
                    ],
                  ))
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(left: 20, bottom: 12, right: 20),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromARGB(255, 39, 39, 39),
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromARGB(52, 0, 0, 0),
                            offset: Offset(0.0, 0.0),
                            blurRadius: 5.0,
                            spreadRadius: 0.0)
                      ],
                    ),
                    child: TextField(
                      controller: _todoController,
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.amber,
                      decoration: InputDecoration(
                          hintText: "Add New Task...",
                          hintStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none),
                    ),
                  )),
                  Container(
                    // decoration: BoxDecoration(
                    //   boxShadow: const [
                    //     BoxShadow(
                    //       color: Color.fromARGB(52, 0, 0, 0),
                    //         offset: Offset(0.0, 0.0),
                    //         blurRadius: 10.0,
                    //         spreadRadius: 0.0
                    //     )
                    //   ]
                    // ),
                    margin: EdgeInsets.only(top: 5, bottom: 20, right: 20),
                    // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.amberAccent),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20)))),
                      child: Text(
                        "+",
                        style: TextStyle(color: Colors.black87, fontSize: 40),
                      ),
                      onPressed: () {
                        _addToDoItem(_todoController.text);
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }

  void _addToDoItem(String toDo) {
    setState(() {
      todosList.add(ToDo (
        id : DateTime.now().millisecondsSinceEpoch.toString(),
        todoText : toDo, 
      ));
    });
    _todoController.clear();
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteToDoItem(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
    });
  }

  AppBar _buildAppBar() {
    return AppBar(
      shape: Border(bottom: BorderSide(color: Colors.white10)),
      elevation: 0,
      toolbarHeight: 80,
      backgroundColor: Colors.black87,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat.MMMEd().format(DateTime.now()),
            style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: 30, color: Colors.white),
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert,
                color: Colors.white70,
                size: 30,
              ))
        ],
      ),
    );
  }
}

class searchBox extends StatelessWidget {
  const searchBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 32, 32, 32),
          borderRadius: BorderRadius.circular(20)),
      child: TextField(
        cursorColor: Colors.amberAccent,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
        decoration: InputDecoration(
            hintText: "Search",
            hintStyle: TextStyle(color: Colors.white30),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white54,
              size: 25,
            ),
            fillColor: Colors.white70,
            contentPadding: EdgeInsets.symmetric(vertical: 15),
            border: InputBorder.none,
            focusColor: Colors.amber),
      ),
    );
  }
}
