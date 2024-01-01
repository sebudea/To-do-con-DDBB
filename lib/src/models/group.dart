import 'package:objectbox/objectbox.dart';
import 'package:to_do_con_db/src/models/task.dart';

// Entidad/objeto de la base de datos
@Entity()
class Group {
  int id = 0;
  late String name;
  late int color;

  @Backlink()
  final tasks = ToMany<Task>(); // Muchas task pertenecen a un group

  // Metodo Constructor
  Group({
    required this.name,
    required this.color,
  });

  // Metodo pa saber cuantas tasks hay completadas
  String tasksDescription() {
    final tasksCompleted = tasks.where((task) => task.completed).length;
    if (tasks.isEmpty) {
      return "";
    }
    return "$tasksCompleted of ${tasks.length}";
  }
}
