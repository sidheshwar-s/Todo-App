import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/models/task.dart';
import 'package:todo/models/todo.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'todo.db'),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)",
        );
        await db.execute(
          "CREATE TABLE todo(id INTEGER PRIMARY KEY, title TEXT, taskId INTEGER, isDone INTEGER)",
        );
        return db;
      },
      version: 1,
    );
  }

  Future<void> updateTasktitle(int id, String Title) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE tasks SET title = '$Title' WHERE id = '$id'");
  }

  Future<void> updateTaskdescription(int id, String Description) async {
    Database _db = await database();
    await _db.rawUpdate(
        "UPDATE tasks SET description = '$Description' WHERE id = '$id'");
  }

  Future<void> updateTodoDone(int id, int isDone) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE todo SET isDone = '$isDone' WHERE id = '$id'");
  }

  Future<void> deletetask(int id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM tasks WHERE id = '$id'");
    await _db.rawDelete("DELETE FROM todo WHERE taskId ='$id'");
  }

  Future<int> insertTask(Task task) async {
    int taskId = 0;
    Database _db = await database();
    await _db
        .insert('tasks', task.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then(
      (value) {
        taskId = value;
      },
    );
    return taskId;
  }

  Future<void> insertTodo(Todo todo) async {
    Database _db = await database();
    await _db.insert('todo', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Task>> getTasks() async {
    Database _db = await database();
    List<Map<String, dynamic>> taskmap = await _db.query('tasks');
    return List.generate(
      taskmap.length,
      (index) {
        return Task(
            id: taskmap[index]['id'],
            title: taskmap[index]['title'],
            description: taskmap[index]['description']);
      },
    );
  }

  Future<List<Todo>> getTodos(int taskId) async {
    Database _db = await database();
    List<Map<String, dynamic>> todoMap =
        await _db.rawQuery("SELECT * FROM todo WHERE taskId = $taskId ");
    return List.generate(
      todoMap.length,
      (index) {
        return Todo(
          id: todoMap[index]['id'],
          title: todoMap[index]['title'],
          taskId: todoMap[index]['taskId'],
          isDone: todoMap[index]['isDone'],
        );
      },
    );
  }
}
