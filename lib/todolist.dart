// import 'package:flutter/material.dart';

// import 'screens/widgets/todo_listtile.dart';

// class TodoList extends StatefulWidget {
//   const TodoList({ Key? key }) : super(key: key);

//   Function(bool, int) onCheck;

//   @override
//   _TodoListState createState() => _TodoListState();
// }

// class _TodoListState extends State<TodoList> {



//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//             padding: const EdgeInsets.all(8),
//             itemCount: _currentTodos.length,
//             itemBuilder: (BuildContext context, int index) {
//               return ToDoListTile(
//                 todo: _currentTodos[index],
//                 onCheck: widget.onCheck,
//               );
//             },
//           ),
//   }
// }