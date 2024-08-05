import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/products_bloc/employee_cubit.dart';
import '../blocs/products_bloc/employee_states.dart';

class EmployeeScreen extends StatelessWidget {
  const EmployeeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EmployeeCubit()..fetchEmployees(),
      child: BlocConsumer<EmployeeCubit,EmployeeStates>(builder: (context,state)=>Scaffold(
        appBar: AppBar(
          title: const Text('ادارة الموظفين', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.teal[800],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: EmployeeCubit.get(context).passwordController,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Row(
                          children: const [
                            Spacer(),
                            Text('كلمة المرور'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: EmployeeCubit.get(context).usernameController,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Row(
                          children: const [
                            Spacer(),
                            Text('اسم المستخدم'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  EmployeeCubit.get(context).addEmployee();
                },
                child: Container(
                  height: 40,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.teal[800],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'اضافة',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(height: 1, color: Colors.grey),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<EmployeeCubit, EmployeeStates>(
                  builder: (context, state) {
                    if (state is EmployeeLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is EmployeeLoaded) {
                      final employees = EmployeeCubit.get(context).employees;
                      return ListView.builder(
                        itemCount: employees.length,
                        itemBuilder: (context, index) {
                          final employee = employees[index];
                          return ListTile(
                            title: Text(employee.username, textDirection: TextDirection.rtl),
                            subtitle: Text(employee.password, textDirection: TextDirection.rtl),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    // Handle edit
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    EmployeeCubit.get(context).deleteEmployee(employee.id!);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else if (state is EmployeeFailure) {
                      return Center(child: Text(state.message));
                    } else {
                      return const Center(child: Text('No employees found'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ), listener: (context,state){}),
    );
  }
}
