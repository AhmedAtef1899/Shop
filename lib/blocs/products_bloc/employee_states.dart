
abstract class EmployeeStates {}

class EmployeeInitial extends EmployeeStates {}

class EmployeeLoading extends EmployeeStates {}

class EmployeeLoaded extends EmployeeStates {}

class EmployeeFailure extends EmployeeStates {
  final String message;

  EmployeeFailure(this.message);
}
