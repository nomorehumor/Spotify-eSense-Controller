import 'package:flutter/material.dart';
import '../../models/todo.dart';

class ToDoListTile extends StatefulWidget {
  const ToDoListTile({Key? key, required this.todo, required this.onCheck}) : super(key: key);

  final void Function(bool, int)? onCheck;
  final ToDo todo;


  @override
  _ToDoListTileState createState() => _ToDoListTileState();
}

class _ToDoListTileState extends State<ToDoListTile> {

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.todo.inFocus ? 1.0 : 0.5,
      // opacity: 1,
      child: Card(
        color: widget.todo.isDone ? Colors.grey.shade400 : Colors.white,
        child: CheckboxListTile(
          onChanged: (newValue) {
            if (newValue != null) {
              widget.onCheck!(newValue, widget.todo.id);
            }
          },
          value: widget.todo.isDone,
          title: Text(widget.todo.name),
        ),
      ),
    );
  }
}
