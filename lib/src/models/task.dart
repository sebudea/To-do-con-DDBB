import 'package:objectbox/objectbox.dart';
import 'package:to_do_con_db/src/models/group.dart';

// Entidad/objeto de la base de datos
@Entity()
class Task {
  int id = 0;
  late String description;
  bool completed = false;

  final group = ToOne<Group>(); // Muchas task pertenecen a un group

  // Metodo Constructor
  Task({
    required this.description,
  });
}
