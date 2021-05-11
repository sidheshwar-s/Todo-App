import 'package:flutter/material.dart';
import 'package:todo/database_helper.dart';
import 'package:todo/models/task.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/screens/widgets.dart';

class TaskPage extends StatefulWidget {
  final Task task;
  TaskPage({@required this.task});

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  int _taskId = 0;
  String _taskTitle = "";
  String _taskDescription = "";
  String todotext = "";

  FocusNode _titleFocus;
  FocusNode _description;
  FocusNode _todoFocus;

  bool _contentvisible = false;
  @override
  void initState() {
    if (widget.task != null) {
      //set visibility
      _contentvisible = true;
      _taskTitle = widget.task.title;
      _taskId = widget.task.id;
      _taskDescription = widget.task.description;
    }
    _titleFocus = FocusNode();
    _description = FocusNode();
    _todoFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _description.dispose();
    _todoFocus.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(
            top: 32,
            right: 24,
            left: 12,
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Image(
                              image: AssetImage(
                                  'assets/images/back_arrow_icon.png')),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          focusNode: _titleFocus,
                          onSubmitted: (value) async {
                            // check if the field in null
                            if (value != "") {
                              // check if the task is null

                              if (widget.task == null) {
                                DatabaseHelper _dbHelper = DatabaseHelper();
                                Task _newTask = Task(
                                  title: value,
                                );

                                _taskId = await _dbHelper.insertTask(_newTask);
                                setState(() {
                                  _taskTitle = value;
                                  _contentvisible = true;
                                });
                                print("New task id: $_taskId");
                              } else {
                                await _dbHelper.updateTasktitle(_taskId, value);
                                print("update");
                              }

                              _description.requestFocus();
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Enter Task Title",
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff211551),
                          ),
                          controller: TextEditingController()
                            ..text = _taskTitle,
                        ),
                      )
                    ],
                  ),
                  Visibility(
                    visible: _contentvisible,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 12,
                      ),
                      child: TextField(
                        focusNode: _description,
                        onSubmitted: (value) async {
                          if (value != "") {
                            if (_taskId != 0) {
                              await _dbHelper.updateTaskdescription(
                                  _taskId, value);
                              _taskDescription = value;
                            }
                          }
                          _todoFocus.requestFocus();
                        },
                        controller: TextEditingController()
                          ..text = _taskDescription,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter Description for the task...",
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _contentvisible,
                    child: FutureBuilder(
                      builder: (context, snapshot) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  if (snapshot.data[index].isDone == 0) {
                                    await _dbHelper.updateTodoDone(
                                        snapshot.data[index].id, 1);
                                  } else {
                                    await _dbHelper.updateTodoDone(
                                        snapshot.data[index].id, 0);
                                  }
                                  setState(() {});
                                },
                                child: TodoWidget(
                                  isdone: snapshot.data[index].isDone == 0
                                      ? false
                                      : true,
                                  text: snapshot.data[index].title,
                                ),
                              );
                            },
                          ),
                        );
                      },
                      initialData: [],
                      future: _dbHelper.getTodos(_taskId),
                    ),
                  ),
                  Visibility(
                    visible: _contentvisible,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            margin: EdgeInsets.only(
                              right: 12,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.transparent,
                              border: Border.all(
                                color: Color(0xff86829D),
                                width: 1.5,
                              ),
                            ),
                            child: Image(
                              image: AssetImage(
                                'assets/images/check_icon.png',
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              focusNode: _todoFocus,
                              controller: TextEditingController()
                                ..text = todotext,
                              onSubmitted: (value) async {
                                // check if the field in null
                                if (value != "") {
                                  // check if the task is null

                                  if (_taskId != 0) {
                                    Todo _newTodo = Todo(
                                      title: value,
                                      isDone: 0,
                                      taskId: _taskId,
                                    );
                                    await _dbHelper.insertTodo(_newTodo);
                                    setState(() {});
                                    _todoFocus.requestFocus();
                                    print("Creating new todo");
                                  }
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "Enter Todo item",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
              Visibility(
                visible: _contentvisible,
                child: Positioned(
                  bottom: 24,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      _dbHelper.deletetask(_taskId);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xffFE3577),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Image(
                        image: AssetImage("assets/images/delete_icon.png"),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
