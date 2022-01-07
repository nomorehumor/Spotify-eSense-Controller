import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  const AddButton({Key? key, required this.onPress}) : super(key: key);

  final void Function()? onPress;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPress,
      child: const Icon(Icons.add),
      backgroundColor: onPress == null ? Colors.grey : Colors.blue,
    );
  }
}
