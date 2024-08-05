import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../models/employee_model.dart';
import '../../services/apis/employee_api.dart';
import 'employee_states.dart';

class EmployeeCubit extends Cubit<EmployeeStates> {
  EmployeeCubit() : super(EmployeeInitial());

  static EmployeeCubit get(context) => BlocProvider.of(context);

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  List<Employee> employees = [];

  fetchEmployees() async {
    emit(EmployeeLoading());
    final response = await EmployeeApi().fetchEmployees();
    if (response['success'] == true) {
      employees = (response['data'] as List).map((e) => Employee.fromJson(e)).toList();
      emit(EmployeeLoaded());
    } else {
      emit(EmployeeFailure(response['message']));
    }
  }

  addEmployee() async {
    emit(EmployeeLoading());
    final newEmployee = Employee(
      username: usernameController.text,
      password: passwordController.text,
    );
    final response = await EmployeeApi().addEmployee(newEmployee);
    if (response['success'] == true) {
      fetchEmployees();
    } else {
      emit(EmployeeFailure(response['message']));
    }
  }

  updateEmployee(Employee employee) async {
    emit(EmployeeLoading());
    final updatedEmployee = Employee(
      id: employee.id,
      username: employee.username,
      password: employee.password,
    );
    final response = await EmployeeApi().updateEmployee(updatedEmployee);
    if (response['success'] == true) {
      fetchEmployees();
    } else {
      emit(EmployeeFailure(response['message']));
    }
  }

  deleteEmployee(String id) async {
    emit(EmployeeLoading());
    final response = await EmployeeApi().deleteEmployee(id);
    if (response['success'] == true) {
      fetchEmployees();
    } else {
      emit(EmployeeFailure(response['message']));
    }
  }

  clearControllers() {
    usernameController.clear();
    passwordController.clear();
  }
}
