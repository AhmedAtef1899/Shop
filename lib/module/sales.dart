import 'package:desktop/module/layout/cubit/cubit.dart';
import 'package:desktop/module/layout/cubit/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final TextEditingController _dateController = TextEditingController();
  List<Map> _salesData = [];
  double _totalPrice = 0.0;

  void _fetchSalesData() async {
    if (_dateController.text.isNotEmpty) {
      var salesData = await AppCubit.get(context).getSalesByDate(_dateController.text);
      setState(() {
        _salesData = salesData;
        _calculateTotalPrice();
      });
    }
  }

  void _calculateTotalPrice() {
    _totalPrice = _salesData.fold(0.0, (sum, sale) {
      double price = double.tryParse(sale['price'].toString()) ?? 0.0;
      double discount = double.tryParse(sale['discount'].toString()) ?? 0.0;
      return sum + (price - discount);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.calendar_today),
                        labelText: 'التاريخ',
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                          _fetchSalesData();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    onPressed: _fetchSalesData,
                    child: const Text('بحث'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'إجمالي الأسعار: $_totalPrice',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _salesData.length,
                  itemBuilder: (context, index) {
                    var sale = _salesData[index];
                    return ListTile(
                      title: Text('الاسم: ${sale['name']}'),
                      subtitle: Text('الكمية: ${sale['amount']} - السعر: ${sale['price']} - الخصم: ${sale['discount']}'),
                      trailing: Text('الكود: ${sale['code']}'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
