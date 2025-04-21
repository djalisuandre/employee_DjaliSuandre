import 'package:employee/services/employee_service.dart';
import 'package:flutter/material.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final EmployeeService _employeeService = EmployeeService();
  late Stream<Map<String, String>> _employeeStream;

  @override
  void initState() {
    super.initState();
    _employeeStream = _employeeService.getEmployeeList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employee List')),
      body: StreamBuilder<Map<String, String>>(
        stream: _employeeStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No employees found'));
          } else {
            final employeeList = snapshot.data!;
            return ListView.builder(
              itemCount: employeeList.length,
              itemBuilder: (context, index) {
                final key = employeeList.keys.elementAt(index);
                final value = employeeList[key]!;
                return ListTile(title: Text(value), subtitle: Text(key));
              },
            );
          }
        },
      ),
    );
  }
}
