import 'package:flutter/material.dart';

class TextInputWidget extends StatefulWidget {
  final Function(String)? callback;
  const TextInputWidget(this.callback, {super.key});

  @override
  State<TextInputWidget> createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  final controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void publish() {
    print('text_input | controller: $controller');
    widget.callback!(controller.text);
    FocusScope.of(context).unfocus();
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onSubmitted: (text) => publish(),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.message_outlined),
        labelText: 'Write your post',
        suffixIcon: IconButton(
          splashColor: Colors.amber[900],
          color: Colors.amber,
          hoverColor: Colors.orange,
          tooltip: 'Publish the post',
          onPressed: publish,
          icon: const Icon(Icons.send),
        ),
      ),
    );
  }
}
