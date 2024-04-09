import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../model/event.dart';
import '../model/todo.dart';
import '../widgets/todo_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todosList = ToDo.todoList();
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();
  bool _isCalendar = false; // default = false
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  Map<DateTime, List<Event>> events = {};
  late final ValueNotifier<List<Event>> _selectedEvents;
  DateTime? _isSelected;
  late bool Function(DateTime) selectedDayPredicate;

  @override
  // Initializes the state of the object. Copies the todosList to _foundToDo, sets _selectedDay to _focusedDay, and initializes _selectedEvents with events for the selected day.
  void initState() {
    super.initState();
    _foundToDo = todosList;
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  // Builds the main UI scaffold of the app, including the app bar, search box, task list, calendar, and add task functionality.
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: _buildAppBar(),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  searchBox(),
                  Expanded(
                      child: ListView(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "All Task",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isCalendar = !_isCalendar;
                                  });
                                },
                                icon: Icon(
                                  _isCalendar
                                      ? Icons.close
                                      : Icons.calendar_month,
                                  color: Colors.white70,
                                ))
                          ],
                        ),
                      ),
                      Visibility(visible: _isCalendar, child: _buildCalendar()),
                      Container(
                          child: todosList.isEmpty
                              ? Center(
                                  heightFactor: _isCalendar ? 5 : 20,
                                  child: const Text(
                                    "No tasks available.",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                )
                              : Column(
                                  children: [
                                    for (ToDo todoo in _foundToDo.reversed)
                                      ToDoItem(
                                        todo: todoo,
                                        onToDoChanged: _handleToDoChange,
                                        onDeleteItem: _deleteToDoItem,
                                      ) 
                                  ],
                                )),
                      const SizedBox(
                        height: 60,
                      )
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
                    margin: const EdgeInsets.only(left: 20, bottom: 12, right: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 39, 39, 39),
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
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.amber,
                      decoration: const InputDecoration(
                          hintText: "Add New Task...",
                          hintStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none),
                    ),
                  )),
                  Container(
                    margin: const EdgeInsets.only(top: 5, bottom: 20, right: 20),
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
                      child: const Text(
                        "+",
                        style: TextStyle(color: Colors.black87, fontSize: 40),
                      ),
                      onPressed: () {
                        if (_todoController.text.isNotEmpty) {
                          _addToDoItem(_todoController.text);
                          events.addAll({
                            _selectedDay!: [Event(_todoController.text)]
                          });
                        }
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }

  // Builds and returns a Container widget containing a TableCalendar widget with specified properties and styles.
  Container _buildCalendar() {
    return Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: TableCalendar(
          focusedDay: _focusedDay,
          firstDay: DateTime(2020),
          lastDay: DateTime(2030),
          weekendDays: const [DateTime.sunday],
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarFormat: _calendarFormat,
          availableCalendarFormats: {_calendarFormat: 'Month'},
          eventLoader: _getEventsForDay,
          headerStyle: HeaderStyle(
            titleCentered: true,
            titleTextStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            headerMargin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: Colors.amber, borderRadius: BorderRadius.circular(20)),
          ),
          daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.white),
              weekendStyle: TextStyle(color: Color.fromARGB(255, 252, 99, 88))),
          calendarStyle: const CalendarStyle(
              markerDecoration: BoxDecoration(
                  color: Colors.purpleAccent, shape: BoxShape.circle),
              selectedTextStyle:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              selectedDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 255, 193, 7)),
              outsideDaysVisible: false,
              todayDecoration: BoxDecoration(
                  color: Color.fromARGB(116, 255, 194, 12),
                  shape: BoxShape.circle),
              weekendTextStyle: TextStyle(
                  color: Color.fromARGB(179, 252, 99, 88),
                  fontWeight: FontWeight.bold),
              defaultTextStyle:
                  TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
              todayTextStyle:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          selectedDayPredicate: (day) => isSameDay(_isSelected, day),
          onDaySelected: _onDaySelected,
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  // A function that returns a predicate function to check if a given DateTime is the same as a selected DateTime.
  bool Function(DateTime) getSelectedDayPredicate() {
    return (day) => isSameDay(_isSelected, day);
  }

  // Updates the state and predicate based on the selected day and focused day.
  void _updateStateAndPredicate(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _selectedEvents.value = _getEventsForDay(selectedDay);
    });
    _isSelected = selectedDay;
    selectedDayPredicate = getSelectedDayPredicate();
  }

  // A function that handles the selection of a day. It compares the selected day with the currently selected day and updates the state and predicate accordingly. If the selected day is the same as the focused day, it resets the selected day and predicate.
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      _updateStateAndPredicate(selectedDay, focusedDay);
    } else if (selectedDay == focusedDay) {
      setState(() {
        _selectedDay = null;
      });
      _isSelected = null;
      selectedDayPredicate = getSelectedDayPredicate();
    }
  }

  // Get the events for a specific day from the events map, returns an empty list if no events are found.
  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  // This function filters the todosList based on the enteredKeyword and updates the _foundToDo state.
  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundToDo = results;
    });
  }

  // Add a new to-do item to the todosList with the provided toDo text and the selected date. Clears the todoController after adding the item.
  void _addToDoItem(String toDo) {
    var selectDate = _selectedDay!;
    String formatter = DateFormat.MMMEd().format(selectDate).toString();
    setState(() {
      todosList.add(ToDo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          todoText: toDo,
          date: formatter));
    });
    _todoController.clear();
  }

  // Handles the change of a ToDo item, toggling its 'isDone' property.
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

  // Builds and returns the app bar widget with specific styling and elements.
  AppBar _buildAppBar() {
    return AppBar(
      shape: const Border(bottom: BorderSide(color: Colors.white10)),
      elevation: 0,
      toolbarHeight: 80,
      backgroundColor: Colors.black87,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat.MMMEd().format(DateTime.now()),
            style: const TextStyle(
                fontWeight: FontWeight.w500, fontSize: 30, color: Colors.white),
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white70,
                size: 30,
              ))
        ],
      ),
    );
  }

  // Creates a search box widget with a text field for user input, which triggers a filter function when the text is changed. The search box is contained within a styled container with specified margin and decoration.
  Widget searchBox() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 32, 32, 32),
          borderRadius: BorderRadius.circular(20)),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        cursorColor: Colors.amberAccent,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
        decoration: const InputDecoration(
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
