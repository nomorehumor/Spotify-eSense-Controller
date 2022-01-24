import 'package:esense_todos/settings/screens/widgets/headset_settings.dart';
import 'package:esense_todos/settings/screens/settings.dart';
import 'package:esense_todos/todos/controllers/todo_controller.dart';
import 'package:esense_todos/utils/text_speaker.dart';
import 'package:esense_todos/todos/models/todolist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/todo_gestures_handler.dart';
import '../models/todo.dart';
import '../models/todolist.dart';
import 'widgets/todo_textfield.dart';
import 'widgets/todo_listtile.dart';
import 'dart:developer' as dev;

class TodoListView extends StatefulWidget {
  const TodoListView({ Key? key }) : super(key: key);


  @override
  _TodoListViewState createState() => _TodoListViewState();
}

class _TodoListViewState extends State<TodoListView> {

  TextSpeaker textSpeaker = TextSpeaker();

  late TodoController controller;

  @override
  void initState() {
    super.initState();
    controller = TodoController(
      Provider.of<CurrentToDoList>(context, listen: false), 
      Provider.of<DoneToDoList>(context, listen: false)
    );
  }

  void _showTextField(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ToDoTextField(onFinish: controller.addToDo);
      },
    );
  }

  void _onSettingsCalled() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Settings()));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("TODOs"),
          backgroundColor: Colors.black87,
          bottom: const TabBar(
            indicatorColor: Color(0xFFBB86FC),
            tabs: [
              Tab(text: "Current"),
              Tab(text: "Done",)
            ]
            // overlayColor: MaterialStateProperty<Color>,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: controller.playTodos,
                child: const Icon(
                  Icons.play_arrow
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: _onSettingsCalled,
                child: const Icon(
                  Icons.settings
                ),
              ),
            )
          ],
        ),
        body: TabBarView(
          children: [
            Consumer<CurrentToDoList>(
              builder: (context, list, child) {
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: list.count(),
                  itemBuilder: (BuildContext context, int index) {
                    return ToDoListTile(
                      todo: list.getToDo(index),
                      onCheck: controller.checkToDo,
                    );
                  }
                );
              },
            ),
            Consumer<DoneToDoList>(
              builder: (context, list, child) {
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: list.count(),
                  itemBuilder: (BuildContext context, int index) {
                    return ToDoListTile(
                      todo: list.getToDo(index),
                      onCheck: controller.uncheckToDo,
                    );
                  }
                );
              },
            ),
          ]
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => _showTextField(context),
          backgroundColor: const Color(0xFFBB86FC),
        ),
      ),
    );
  }
}