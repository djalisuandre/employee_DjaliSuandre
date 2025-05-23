import 'package:firebase_database/firebase_database.dart';

class EmployeeService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref().child(
    'employee_list',
  );
  Stream<Map<String, String>> getEmployeeList() {
    return _database.onValue.map((event) {
      final Map<String, String> items = {};
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          items[key] = value['name'] as String;
          items[key] = value['position'] as String;
        });
      }
      return items;
    });
  }

  void addEmployee(String name, String position) {
    _database.push().set({'name': name, 'position': position});
  }

  Future<void> updateEmployee(String key, String name, String position) async {
    await _database.child(key).update({'name': name, 'position': position});
  }
}
