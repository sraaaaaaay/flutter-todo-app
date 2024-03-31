import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TodoList(title: 'Todo Manager'),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({super.key, required this.title});

  final String title;

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<Todo> _todos = [];
  final TextEditingController _textFieldController = TextEditingController();

  // Method to add a todo - update the UI and clear the input text
  void _addTodoItem(String name) {
    setState(() {
      _todos.add(Todo(name: name, completed: false));
    });
    _textFieldController.clear();
  }

  void _handleTodoChange(Todo todo){
    setState(() {todo.completed = !todo.completed;});
  }

  Future<void> _displayDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Add a todo"),
              content: TextField(
                  controller: _textFieldController,
                  decoration: const InputDecoration(hintText: "Type a todo"),
                  autofocus: true),
              actions: <Widget>[
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancel")),
                OutlinedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _addTodoItem(_textFieldController.text);
                  },
                  child: const Text("Add"),
                )
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical:8),
        children: _todos.map((Todo todo){
          return TodoItem(todo:todo, onTodoChanged: _handleTodoChange);
        }).toList(),
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: () =>_displayDialog(),
        tooltip: 'Add a todo',
        child: const Icon(Icons.add),
      ),


    );
  }
}

class Todo {
  String name;
  bool completed;
  Todo({required this.name, required this.completed});
}

class TodoItem extends StatelessWidget {
  final Todo todo;
  TodoItem({required this.todo, required this.onTodoChanged}) : super(key:ObjectKey(todo));

  final void Function(Todo todo) onTodoChanged;

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override 
  Widget build(BuildContext context){
    return ListTile(
      onTap: (){ onTodoChanged(todo);},
      leading: Checkbox(
        checkColor: Colors.greenAccent,
        activeColor: Colors.red,
        value:todo.completed,
        onChanged: (value) {onTodoChanged(todo);},
      ),
      title: Row(children:<Widget>[
        Expanded(

          // Styles the text in accordance with whether the todo is completed.
          child:Text(todo.name, style:_getTextStyle(todo.completed))
        ),
        IconButton(
          iconSize: 30,
          icon:const Icon(Icons.delete, color:Colors.red),
          alignment: Alignment.centerRight,
          onPressed: () {},
        ),
      ])
    );
  }
}
