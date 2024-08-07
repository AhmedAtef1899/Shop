import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../../models/employee_model.dart';
import '../../src/app_endpoints.dart';

class EmployeeApi {
  Future<Map<String, dynamic>> fetchEmployees() async {
    try {
      final response = await http.get(Uri.parse(AppEndPoints.showEmployees));
      if (response.statusCode < 300) {
        return json.decode(response.body);
      } else {
        log('Error: ${response.statusCode} ${response.reasonPhrase}');
        return {'success': false, 'message': 'Failed to fetch employees'};
      }
    } catch (e) {
      log('Exception: $e');
      return {'success': false, 'message': 'An error occurred'};
    }
  }

  Future<Map<String, dynamic>> addEmployee(Employee employee) async {
    try {
      final response = await http.post(
        Uri.parse(AppEndPoints.addEmployee),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(employee.toJson()),
      );
      if (response.statusCode < 300) {
        return json.decode(response.body);
      } else {
        log('Error: ${response.statusCode} ${response.reasonPhrase}');
        return {'success': false, 'message': 'Failed to add employee'};
      }
    } catch (e) {
      log('Exception: $e');
      return {'success': false, 'message': 'An error occurred'};
    }
  }

  Future<Map<String, dynamic>> updateEmployee(Employee employee) async {
    try {
      final response = await http.put(
        Uri.parse(AppEndPoints.updateEmployee),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(employee.toJson()),
      );
      if (response.statusCode < 300) {
        return json.decode(response.body);
      } else {
        log('Error: ${response.statusCode} ${response.reasonPhrase}');
        return {'success': false, 'message': 'Failed to update employee'};
      }
    } catch (e) {
      log('Exception: $e');
      return {'success': false, 'message': 'An error occurred'};
    }
  }

  Future<Map<String, dynamic>> deleteEmployee(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('${AppEndPoints.deleteEmployee}?id=$id'),
      );
      if (response.statusCode < 300) {
        return json.decode(response.body);
      } else {
        log('Error: ${response.statusCode} ${response.reasonPhrase}');
        return {'success': false, 'message': 'Failed to delete employee'};
      }
    } catch (e) {
      log('Exception: $e');
      return {'success': false, 'message': 'An error occurred'};
    }
  }
}
