import 'package:flutter/material.dart';

import 'layout/cubit/cubit.dart';

class SellItem extends StatefulWidget {
  const SellItem({super.key});

  @override
  _SellItemState createState() => _SellItemState();
}

class _SellItemState extends State<SellItem> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  Map? _itemData;
  double _price = 0.0;

  @override
  Widget build(BuildContext context) {
    final cubit = AppCubit.get(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _codeController,
                    onChanged: (value) async {
                      _itemData = await cubit.getItemByCode(value);
                      setState(() {
                        _price = _itemData != null ? double.parse(_itemData!['price']) : 0.0;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'الكود',
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(_itemData != null ? _itemData!['name'] : 'النوع'),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(_itemData != null ? _itemData!['amount'].toString() : 'العدد'),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(_price.toStringAsFixed(2)),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)
                  )
              ),
              child: Column(
                children: [
                   SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _discountController,
                      onChanged: (value) {
                        setState(() {
                          double discount = double.tryParse(value) ?? 0.0;
                          _price = _itemData != null
                              ? double.parse(_itemData!['price']) - discount
                              : 0.0;
                        });
                      },
                      decoration: const InputDecoration(
                          labelText: 'الخصم'
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      MaterialButton(
                        onPressed: () {
                          if (_itemData != null) {
                            double discount = double.tryParse(_discountController.text) ?? 0.0;
                            cubit.updateQuantity(_itemData!['code'].toString(), 1, discount.toString());
                            _codeController.text = "";
                            _discountController.text = "";
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blue,
                          ),
                          child: const Text('بيع بفاتورة'),
                        ),
                      ),
                      const Spacer(),
                      MaterialButton(
                        onPressed: () {
                          if (_itemData != null) {
                            double discount = double.tryParse(_discountController.text) ?? 0.0;
                            cubit.updateQuantity(_itemData!['code'].toString(), 1, discount.toString());
                            _codeController.text = "";
                            _discountController.text = "";
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blue,
                          ),
                          child: const Text('بيع بدون فاتورة'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
