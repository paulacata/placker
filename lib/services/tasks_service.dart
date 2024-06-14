import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:placker/models/models.dart';

//aquest codi ha estat adaptat del vídeo Flutter Tutorial - Calendar Event App | With Day View & Week View - Flutter Syncfusion Calendar de HeyFlutter.com https://www.youtube.com/watch?v=LoDtxRkGDTw 

//fa les peticions http per la tasca
class TasksService extends ChangeNotifier {

  final String _baseUrl = 'placker-app-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Task> tasks = [];
  late Task selectedTask;
  bool isSaving = false;
  final storage = new FlutterSecureStorage();

  TasksService() {
    selectedTask = Task();
    loadTasks();
  }

  Future<String?> _getUid() async {
    return await storage.read(key: 'uid');
  }

  Future<void> loadTasks() async {
    final uid = await _getUid();
    final url = Uri.https(_baseUrl, 'users/$uid/tasks.json');
    final response = await http.get(url);
    final Map<String, dynamic> tasksMap = json.decode(response.body);

    tasks.clear(); 

    tasksMap.forEach((key, value) {
      final temporalTask = Task.fromMap(value);
      temporalTask.id = key;
      tasks.add(temporalTask);
    });

    notifyListeners();
  }

  Future<void> updateOrCreateTask(Task task) async {
    isSaving = true;
    notifyListeners();

    if (task.id == null ) {
      await createTask(task);
    } else {
      await updateTask(task);
    }

    isSaving = false;
    notifyListeners();
  }
  
  Future<void> updateTask(Task task) async {
    final uid = await _getUid();
    final url = Uri.https(_baseUrl, 'users/$uid/tasks/${task.id}.json');
    await http.put(url, body: task.toJson());

    final index = tasks.indexWhere((element) => element.id == task.id);
    tasks[index] = task;

    notifyListeners();
  }

  Future<void> createTask(Task task) async {
    final uid = await _getUid();
    final url = Uri.https(_baseUrl, 'users/$uid/tasks.json');
    final response = await http.post(url, body: task.toJson());
    final decodedData = json.decode(response.body);

    task.id = decodedData['name'];

    tasks.add(task);
    
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    final uid = await _getUid();
    final url = Uri.https(_baseUrl, 'users/$uid/tasks/$id.json');
    await http.delete(url);

    tasks.removeWhere((task) => task.id == id);

    notifyListeners();
  }

  Future<void> updateTaskRegister(Task task, String resultTotal, String resultFocus, String resultPausa) async {
    final uid = await _getUid();
    final url = Uri.https(_baseUrl, 'users/$uid/tasks/${task.id}.json');

    task.tempsTotal = resultTotal;
    task.tempsFocus = resultFocus;
    task.tempsPausa = resultPausa;

    await http.put(url, body: json.encode(task.toMap()));

    final index = tasks.indexWhere((element) => element.id == task.id);
    
    if (index != -1) {
      tasks[index] = task;
      notifyListeners();
    } else {
      return;
    }

    notifyListeners();
  }

  List<Task> getTasksForDay(String day) {
    String formattedDay = DateFormat('yyyy-MM-dd').format(DateFormat('dd-MM-yyyy').parse(day));
    return tasks.where((task) => task.dia == formattedDay).toList();
  }

  List<String> getAllDays() {
    if (tasks.isEmpty) return [];

    DateTime firstDay = tasks.map((task) => DateFormat('yyyy-MM-dd').parse(task.dia!)).reduce((a, b) => a.isBefore(b) ? a : b);
    DateTime lastDay = tasks.map((task) => DateFormat('yyyy-MM-dd').parse(task.dia!)).reduce((a, b) => a.isAfter(b) ? a : b);

    List<String> allDays = [];
    for (DateTime date = firstDay; date.isBefore(lastDay.add(const Duration(days: 1))); date = date.add(const Duration(days: 1))) {
      allDays.add(DateFormat('dd-MM-yyyy').format(date));
    }

    return allDays;
  }

  List<Task> getTasksForWeek(String startOfWeek) {
    DateTime start = DateFormat('dd-MM-yyyy').parse(startOfWeek);
    DateTime end = start.add(const Duration(days: 6));

    return tasks.where((task) {
      DateTime taskDate = DateFormat('yyyy-MM-dd').parse(task.dia!);
      return taskDate.isAtSameMomentAs(start) || taskDate.isAfter(start) && taskDate.isBefore(end) || taskDate.isAtSameMomentAs(end);
    }).toList();
  }

  List<String> getAllWeeks() {
    if (tasks.isEmpty) return [];

    DateTime firstDay = tasks.map((task) => DateFormat('yyyy-MM-dd').parse(task.dia!)).reduce((a, b) => a.isBefore(b) ? a : b);
    DateTime lastDay = tasks.map((task) => DateFormat('yyyy-MM-dd').parse(task.dia!)).reduce((a, b) => a.isAfter(b) ? a : b);

    firstDay = firstDay.subtract(Duration(days: firstDay.weekday - 1));
    lastDay = lastDay.add(Duration(days: 7 - lastDay.weekday));

    List<String> allWeeks = [];
    for (DateTime date = firstDay; date.isBefore(lastDay.add(const Duration(days: 1))); date = date.add(const Duration(days: 7))) {
      allWeeks.add(DateFormat('dd-MM-yyyy').format(date));
    }

    return allWeeks;
  }

  List<Task> getTasksForMonth(String startOfMonth) {
    DateTime start = DateFormat('dd-MM-yyyy').parse(startOfMonth);
    DateTime end = DateTime(start.year, start.month + 1, 0);

    return tasks.where((task) {
      DateTime taskDate = DateFormat('yyyy-MM-dd').parse(task.dia!);
      return taskDate.isAtSameMomentAs(start) || taskDate.isAfter(start) && taskDate.isBefore(end) || taskDate.isAtSameMomentAs(end);
    }).toList();
  }

  List<String> getAllMonths() {
    if (tasks.isEmpty) return [];

    DateTime firstDay = tasks.map((task) => DateFormat('yyyy-MM-dd').parse(task.dia!)).reduce((a, b) => a.isBefore(b) ? a : b);
    DateTime lastDay = tasks.map((task) => DateFormat('yyyy-MM-dd').parse(task.dia!)).reduce((a, b) => a.isAfter(b) ? a : b);

    List<String> allMonths = [];
    for (DateTime date = DateTime(firstDay.year, firstDay.month, 1); date.isBefore(DateTime(lastDay.year, lastDay.month + 1, 1)); date = DateTime(date.year, date.month + 1, 1)) {
      allMonths.add(DateFormat('dd-MM-yyyy').format(date));
    }

    return allMonths;
  }

  List<Task> getAllTasks() {
    return List<Task>.from(tasks);
  }
}