import 'package:flutter/material.dart';
import '../models/todo.dart';
import 'add_button.dart';

class ToDoTextField extends StatefulWidget {
  const ToDoTextField({Key? key, required this.onFinish}) : super(key: key);

  final void Function(ToDo) onFinish;

  @override
  State<ToDoTextField> createState() => _ToDoTextFieldState();
}

class _ToDoTextFieldState extends State<ToDoTextField> {
  String text = "";

  void _onFinishHandler(String text, BuildContext context) {
    DateTime now = DateTime.now();
    ToDo newToDo = ToDo(name: text, isDone: false, id: now.millisecondsSinceEpoch);
    widget.onFinish(newToDo);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    text = value;
                  });
                },
                onSubmitted: (text) => _onFinishHandler(text, context),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: text == ""
                ? const AddButton(onPress: null)
                : AddButton(onPress: () => _onFinishHandler(text, context)),
          )
        ],
      ),
      padding: MediaQuery.of(context).viewInsets,
    );
  }
}
