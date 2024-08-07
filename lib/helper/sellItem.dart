
import 'package:desktop/blocs/products_bloc/products_cubit.dart';
import 'package:desktop/models/products_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class SellItem extends StatefulWidget {
  const SellItem({super.key});

  @override
  _SellItemState createState() => _SellItemState();
}

class _SellItemState extends State<SellItem> {
  final List<Product> _searchResultData = [];
  final List<Product> _cartProducts = [];
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  String searchKey = "";

  void getMatch({model}) {
    _searchResultData.clear();
    for (var item in model) {
      if (item.productcode
          .toLowerCase()
          .contains(_codeController.text.toLowerCase()) &&
          !_searchResultData.contains(item)) {
        setState(() => _searchResultData.add(item));
      }
      if (_codeController.text == "") {
        setState(() {
          _searchResultData.clear();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = ProductsCubit.get(context);
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Spacer(),
            Text('بيع المنتجات',style: TextStyle(color: CupertinoColors.white),),
          ],
        ),
        backgroundColor: Colors.teal[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(11),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  'اعدادات',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  'الكمية فالمخزن',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  'السعر',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  'العدد',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  'النوع',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 320,
                        width: double.infinity,
                        child: ListView.separated(
                          itemCount: _cartProducts.length,
                          itemBuilder: (context, index) => Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: TextButton.icon(
                                        label: const Text(
                                          'إزالة',
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _cartProducts.remove(_cartProducts[index]);
                                            calcSum(_cartProducts);
                                          });
                                        },
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        _cartProducts[index].productquota!,
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        _cartProducts[index].productprice!,
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          IconButton(
                                            onPressed: (){},icon:
                                            Icon(CupertinoIcons.plus_circle_fill,color: Colors.teal[800],)
                                          ),
                                          const Text('1'),
                                          IconButton(
                                              onPressed: (){},icon:
                                          const Icon(CupertinoIcons.minus_circle_fill,color: Colors.teal,)
                                          ),
                                        ],
                                      )
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        _cartProducts[index].productname!,
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                                        textDirection: TextDirection.rtl,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (index + 1 == _cartProducts.length)
                                const SizedBox(height: 20),
                              if (index + 1 == _cartProducts.length)
                                Center(
                                  child: Text(
                                    'الاجمالي:  ${sum.toString()}',
                                    style: const TextStyle(color: Colors.black, fontSize: 30),
                                  ),
                                ),
                            ],
                          ),
                          separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 60,
                        width: 250,
                        child: TextField(
                          controller: _codeController,
                          onChanged: (value) {
                            setState(() {
                              getMatch(model: cubit.productsModel!.products);
                            });
                          },
                          textDirection: TextDirection.rtl,
                          decoration: const InputDecoration(
                            label: Row(
                              children: [
                                Spacer(),
                                Text('الكود'),
                              ],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: ListView.builder(
                          itemCount: _searchResultData.length,
                          itemBuilder: (context, index) => Row(
                            children: [
                              Expanded(
                                child: TextButton.icon(
                                  label: const Text('ضف للعربة'),
                                  onPressed: () {
                                    setState(() {
                                      _cartProducts.add(_searchResultData[index]);
                                      _codeController.clear();
                                      _searchResultData.clear();
                                      calcSum(_cartProducts);
                                    });
                                  },
                                  icon: const Icon(Icons.add_shopping_cart_outlined),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  _searchResultData[index].productname!,
                                  style: const TextStyle(color: Colors.black),
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: _discountController,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onSubmitted: (value) {
                          setState(() {
                            if (value.isNotEmpty) {
                              double discount = double.parse(value);
                              sum -= discount;
                              _cartProducts.add(Product(
                                dateadded: '',
                                id: '',
                                productcode: '',
                                productimage: '',
                                productname: 'خصم',
                                productprice: '$discount',
                                productquota: '',
                              ));
                              _discountController.clear();
                            }
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'الخصم',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: MaterialButton(
                            onPressed: () {},
                            color: Colors.teal,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(15),
                              child: Text('بيع بفاتورة'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: MaterialButton(
                            onPressed: () {
                              showDialog(context: context, builder: (context){
                                return  AlertDialog(
                                  title: const Center(
                                    child: Text(
                                      'مرتجع'
                                    ),
                                  ),
                                  content:  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      TextField(
                                        textDirection: TextDirection.rtl,
                                        onChanged: (value){
                                          setState(() {
                                            getMatch(model: cubit.productsModel!.products);
                                          });
                                        },
                                        decoration: const InputDecoration(
                                          label: Row(
                                            children: [
                                              Spacer(),
                                              Text(
                                                'الكود'
                                              )
                                            ],
                                          )
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      const Expanded(
                                        child: Text(
                                          'الاسم'
                                        ),
                                      ),
                                      const Expanded(
                                        child: Text(
                                            'السعر'
                                        ),
                                      ),
                                      const Expanded(
                                        child: Text(
                                            'الكود'
                                        ),
                                      ),
                                      const Expanded(
                                        child: Text(
                                            'الكمية بالمخزن'
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text('تم'),
                                      onPressed: () {
                                        // Add your delete logic here
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('الغاء'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                            },
                            color: Colors.teal,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(15),
                              child: Text('مرتجع'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: MaterialButton(
                            onPressed: () {},
                            color: Colors.teal,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(15),
                              child: Text('بيع بدون فاتورة'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void calcSum(List<Product> productList) {
    double ssum = 0;
    for (var i = 0; i < productList.length; i++) {
      double price = double.parse(productList[i].productprice!);
      ssum += price;
    }
    sum = ssum;
  }
}

double sum = 0;
