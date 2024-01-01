import 'package:flutter/material.dart';
import 'package:to_do_con_db/objectbox.g.dart';
import 'package:to_do_con_db/src/models/group.dart';
import 'package:to_do_con_db/src/screens/add_group.dart';
import 'package:to_do_con_db/src/screens/tasks_screen.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final _groups = <Group>[];        // Se declara la variable _groups que es una lista de objetos de tipo Group
  late final Store _store;          // Store generalmente se asocia con la conexión a la base de datos ObjectBox
  late final Box<Group> _groupBox;  // _groupBox se utilizará para interactuar con la base de datos y realizar operaciones en objetos de la entidad Group.

  Future<void> _addGroup() async {
    final result = await showDialog(
      context: context,
      builder:  (_) => const AddGroupScreen(),
    );

    if (result != null && result is Group) {
      _groupBox.put(result);
      _loadGroups();
    }
  }

  void _loadGroups() {
    _groups.clear();
    setState(() {
      _groups.addAll(_groupBox.getAll());
    });
  }

  Future<void> _loadStore() async {
    _store = await openStore();
    _groupBox = _store.box<Group>();
    _loadGroups();
  }

  Future<void> _goToTasks(Group group) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TasksScreen(group: group, store: _store),
      ),
    );

    _loadGroups();
  }

  @override
  void initState() {
    _loadStore();
    super.initState();
  }

  @override
  void dispose() {
    _store.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TODO List"),
      ),
      body: _groups.isEmpty   // Si la lista de objetos de tipo Group _group esta vacia, genera el codigo siguiente al "?",  condicion ? expresionSiVerdadero : expresionSiFalso
          ? const Center(
              child: Text("There are no Groups"),
            )
          : GridView.builder( // Si la lista de objetos de tipo Group _group NO esta vacia, genera el codigo siguiente al ":"
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,  // Columnas de la Grid
              ),
              itemCount: _groups.length, // itemCount se utiliza para determinar cuántas veces se llama a la función itemBuilder, que es responsable de construir cada elemento individual de la cuadrícula
              itemBuilder: (BuildContext context, int index) {
                final group = _groups[index];
                return _GroupItem(
                  group: group,
                  onTap: () => _goToTasks(group),
                );
              }, // En todos estos casos, el "builder" en GridView.builder se refiere a una función que se encarga de construir widgets de manera dinámica
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: _addGroup, label: const Text("Add Group")),
    );
  }
}

class _GroupItem extends StatelessWidget {
  const _GroupItem({super.key, required this.group, required this.onTap});

  final Group group;
  final VoidCallback onTap;
  // Comúnmente se usa para representar un manejador de eventos o una función de devolución de llamada que se ejecutará cuando ocurra cierto evento, como cuando se toca un widget

  @override
  Widget build(BuildContext context) {
    final description = group.tasksDescription();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Color(group.color),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                group.name,
                style: const TextStyle(color: Colors.white, fontSize: 22),
              ),
              if (description.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  description,
                  style: const TextStyle(color: Colors.white, fontSize: 17),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
