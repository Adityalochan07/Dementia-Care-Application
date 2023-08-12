import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/task.dart';

void main() {
  runApp(
    MaterialApp(
      home: health(),
    ),
  );
}

class health extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return healthState();
  }
}

// ignore: camel_case_types
class healthState extends State<health> {
  // ignore: prefer_typing_uninitialized_variables
  var _taskController;
  late List<Task> _tasks;
  late List<bool> _taskDone;
  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Task t = Task.fromString(_taskController.text);
    String? tasks = prefs.getString('task');
    List list = (tasks == null) ? [] : json.decode(tasks);
    print(list);
    list.add(json.encode(t.getMap()));
    // ignore: avoid_print
    print(list);
    prefs.setString('task', json.encode(list));
    _taskController.text = '';
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();

    _getTask();
  }

  void _getTask() async {
    _tasks = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasks = prefs.getString('task');
    List list = (tasks == null) ? [] : json.decode(tasks);
    for (dynamic d in list) {
      _tasks.add(Task.fromMap(json.decode(d)));
    }
    _taskDone = List.generate(_tasks.length, (index) => false);
    setState(() {});
  }

  void UpdatePending() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Task> pendingList = [];
    for (var i = 0; i < _tasks.length; i++)
      if (!_taskDone[i]) pendingList.add(_tasks[i]);

    var pendingListEncoded = List.generate(
        pendingList.length, (i) => json.encode(pendingList[i].getMap()));

    prefs.setString('task', jsonEncode(pendingListEncoded));
    _getTask();
  }

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController();
    _getTask();
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Colors.orange,
        title: Text("To do...."),
        actions: [
          IconButton(onPressed: () => UpdatePending(), icon: Icon(Icons.delete)),
          // IconButton(
          //     onPressed: () async {
          //       SharedPreferences prefs = await SharedPreferences.getInstance();
          //       prefs.setString('tasks', json.encode([]));
          //       _getTask();
          //     },
          //     icon: Icon(Icons.delete)
          //     ),
        ],
      ),
      body: (_tasks == null)
          ? Center(child: Text("No Task Added Yet!"))
          : Column(
              children: _tasks
                  .map((e) => Container(
                        height: 70.0,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(
                          left: 10.0,
                        ),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                              color: Colors.black,
                              width: 0.5,
                            )),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(e.task!),
                              Checkbox(
                                value: _taskDone[_tasks.indexOf(e)],
                                key: GlobalKey(),
                                onChanged: (bool? val) {
                                  setState(() {
                                    _taskDone[_tasks.indexOf(e)] = val!;
                                  });
                                },
                              ),
                            ]),
                      ))
                  .toList(),
            ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => showModalBottomSheet(
              context: context,
              builder: (BuildContext context) => Container(
                  padding: EdgeInsets.all(10.0),
                  height: 500,
                  color: Colors.orange,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Add Task'),
                          GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Icon(
                                Icons.close,
                              ))
                        ],
                      ),
                      Divider(thickness: 2.2),
                      SizedBox(height: 20.0),
                      TextField(
                          controller: _taskController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Enter Task',
                          )),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.0,
                        ),
                        width: MediaQuery.of(context).size.width,
                        // height: 200.0,
                        child: Row(
                          children: [
                            Container(
                                // color: Colors.white,
                                width: (MediaQuery.of(context).size.width / 2) -
                                    20,
                                child: ElevatedButton(
                                    onPressed: () => _taskController.text = '',
                                    child: Text('Reset'))),
                            Container(
                                // color: Colors.blue,
                                width: (MediaQuery.of(context).size.width / 2) -
                                    20,
                                child: ElevatedButton(
                                    onPressed: () => saveData(),
                                    child: Text('Add'))),
                          ],
                        ),
                      )
                    ],
                  ))),
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Colors.orange),
    );
  }
}
