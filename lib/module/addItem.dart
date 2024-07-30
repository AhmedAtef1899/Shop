
import 'package:desktop/module/layout/cubit/cubit.dart';
import 'package:desktop/module/layout/cubit/state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddItem extends StatelessWidget {
  const AddItem({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(builder: (context,state) => Scaffold(
      body: Builder(
        builder: (context) {
          var nameController = TextEditingController();
          var quantityController = TextEditingController();
          var codeController = TextEditingController();
          var priceController = TextEditingController();
          return Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                Icon(
                  Icons.shop,
                  color: Colors.blue[900],
                  size: 50,
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.type_specimen
                    ),
                    label:const Row(
                      children: [
                        Spacer(),
                        Text(
                            'الاسم'
                        )
                      ],
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: quantityController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      CupertinoIcons.number_circle_fill
                    ),
                    label:const Row(
                      children: [
                        Spacer(),
                        Text(
                            'الكمية'
                        )
                      ],
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: codeController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.code
                    ),
                    label:const Row(
                      children: [
                        Spacer(),
                        Text(
                            'الكود'
                        )
                      ],
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.price_change
                    ),
                    label:const Row(
                      children: [
                        Spacer(),
                        Text(
                            'السعر'
                        )
                      ],
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(onPressed: (){
                  AppCubit.get(context).insertDatabase(
                      name: nameController.text,
                      amount: quantityController.text,
                      code: codeController.text,
                      price: priceController.text,
                      discount: '0'
                  );
                },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue[800],
                      ),
                      child: const Center(
                        child: Text(
                          "اضافة",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25
                          ),
                        ),
                      ),
                    )
                )
              ],
            ),
          );
        }
      ),
    ), listener: (context,state){});
  }
}
