
import 'package:desktop/module/layout/cubit/cubit.dart';
import 'package:desktop/module/layout/cubit/state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ItemsScreen extends StatelessWidget {
  const ItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(builder: (context,state)=>Scaffold(
      body: Builder(
          builder: (context) {
            return  Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Spacer(),
                      Expanded(
                        child: Center(
                          child: Text(
                            'اعدادات',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'السعر',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                              'الكود',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                              'الكمية',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                              'الاسم',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                              'التسلسل',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Expanded(
                      child: ListView.separated(itemBuilder: (context,index)=>items(AppCubit.get(context).data[index], context),
                          separatorBuilder: (context,index)=>const SizedBox(height: 1,),
                          itemCount: AppCubit.get(context).data.length
                      )
                  )
                ],
              ),
            );
          }
      ),
    ), listener:  (context,state){});
  }
}

Widget items(Map model,context) => Dismissible(
  key: Key(model['id'].toString()),
  onDismissed: (id){
    AppCubit.get(context).deleteDatabase(id: model['id']);
  },
  child: Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      border: Border.all(style: BorderStyle.solid,color: CupertinoColors.black)
    ),
    child: Builder(
      builder: (context) {
        var nameController = TextEditingController();
        var priceController = TextEditingController();
        var codeController = TextEditingController();
        var amountController = TextEditingController();

        return Row(
          children: [
            const Spacer(),
            Expanded(
              child: Center(
                child: TextButton.icon(onPressed: (){
                  showModalBottomSheet(context: context, builder: (context)

                  {
                    return BlocProvider(create: (context)=>AppCubit()..createDatabase(),
                    child: BlocConsumer<AppCubit,AppStates>(builder: (context,state)=> Padding(
                      padding: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Builder(
                          builder: (context) {
                            nameController.text = model['name'];
                            priceController.text = model['price'];
                            amountController.text = model['amount'].toString();
                            codeController.text = model['code'].toString();
                            return Column(
                                children: [
                                  const Center(
                                    child: Text(
                                        'تعديل',
                                      style: TextStyle(
                                        fontSize: 25
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  TextField(
                                    controller: nameController,
                                    textAlign: TextAlign.right,
                                    decoration: const InputDecoration(
                                      label: Row(
                                        children: [
                                          Spacer(),
                                          Text(
                                            'إلاسم'
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextField(
                                    controller: amountController,
                                    textAlign: TextAlign.right,
                                    decoration: const InputDecoration(
                                      label: Row(
                                        children: [
                                          Spacer(),
                                          Text(
                                              'الكمية'
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextField(
                                    controller: codeController,
                                    textAlign: TextAlign.right,
                                    decoration: const InputDecoration(
                                      label: Row(
                                        children: [
                                          Spacer(),
                                          Text(
                                              'كود'
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextField(
                                    controller: priceController,
                                    textAlign: TextAlign.right,
                                    decoration: const InputDecoration(
                                      label: Row(
                                        children: [
                                          Spacer(),
                                          Text(
                                              'السعر'
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextButton(onPressed: () {
                                    AppCubit.get(context).updateDatabase(
                                        name: nameController.text,
                                        amount: amountController.text,
                                        code: codeController.text,
                                        price: priceController.text,
                                        id: model['id']);
                                    Navigator.pop(context);
                                  }, child: Container(
                                    width: double.infinity,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.blue[800],
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'تعديل',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white
                                        ),
                                      ),
                                    ),
                                  ))
                                ],
                              );
                          }
                        ),
                      ),
                    ),
                        listener: (context,state){}),) ;
                  });
                },
                    icon:const Icon(
                      Icons.edit
                    ),
                    label: const Text(
                      'تعديل'
                    )
                )
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                    model['price'],
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                    model['code'].toString(),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                    model['amount'].toString(),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                    model['name'],
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                    model['id'].toString(),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ),
          ],
        );
      }
    ),
  ),
);