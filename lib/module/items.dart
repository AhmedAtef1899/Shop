import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:desktop/blocs/products_bloc/products_cubit.dart';
import 'package:desktop/blocs/products_bloc/products_states.dart';
import 'package:desktop/module/layout/cubit/cubit.dart';
import 'package:desktop/module/layout/cubit/state.dart';

class ItemsScreen extends StatelessWidget {
  ItemsScreen({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsCubit, ProductsStates>(
      listener: (context, state) {
        if (state is ProductUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              'تم التعديل',
              textAlign: TextAlign.center,
            ),
          ));
        }
        if (state is ProductsFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              state.msg,
              textAlign: TextAlign.center,
            ),
          ));
        }
      },
      builder: (context, state) {
        var cubit = ProductsCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Center(
              child: Text(
                'قائمة المنتجات',
                style: TextStyle(color: CupertinoColors.white),
              ),
            ),
            backgroundColor: Colors.teal[800],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  textDirection: TextDirection.rtl,
                  controller: searchController,
                  onChanged: (value) {
                    cubit.searchProducts(value);
                  },
                  decoration: const InputDecoration(
                    label: Row(
                      children: [
                        Spacer(),
                        Text(
                          'بحث بالاسم او الكود'
                        )
                      ],
                    ),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 20),
                const ProductListHeader(),
                const SizedBox(height: 30),
                Expanded(
                  child: ListView.separated(
                    itemCount: cubit.filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = cubit.filteredProducts[index];
                      return ProductItem(
                        model: product!.toJson(),
                        context: context,
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 1),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProductListHeader extends StatelessWidget {
  const ProductListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Spacer(),
        HeaderItem(title: 'مسح'),
        HeaderItem(title: 'اعدادات'),
        HeaderItem(title: 'السعر'),
        HeaderItem(title: 'الكود'),
        HeaderItem(title: 'الكمية'),
        HeaderItem(title: 'الاسم'),
        HeaderItem(title: 'التسلسل'),
      ],
    );
  }
}

class HeaderItem extends StatelessWidget {
  final String title;
  const HeaderItem({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final Map model;
  final BuildContext context;

  ProductItem({required this.model, required this.context, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5),
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
      child: Row(
        children: [
          const Spacer(),
          ActionButton(
            icon: Icons.delete,
            color: Colors.red,
            onPressed: () => _showDeleteDialog(context),
          ),
          ActionButton(
            icon: Icons.edit,
            color: Colors.blue,
            onPressed: () => _showEditModal(context),
          ),
          ProductInfo(text: model['product_price']),
          ProductInfo(text: model['product_code'].toString()),
          ProductInfo(text: model['product_quota'].toString()),
          ProductInfo(text: model['product_name']),
          ProductInfo(text: model['id'].toString()),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تنبيه'),
          content: const Text('هل تريد ان تحذف هذا المنتج؟'),
          actions: <Widget>[
            TextButton(
              child: const Text('نعم'),
              onPressed: () {
                // Add your delete logic here
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('لا'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditModal(BuildContext context) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final codeController = TextEditingController();
    final amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (context) => AppCubit()..createDatabase(),
          child: BlocConsumer<AppCubit, AppStates>(
            builder: (context, state) => Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Builder(builder: (context) {
                  nameController.text = model['product_name'];
                  priceController.text = model['product_price'];
                  amountController.text = model['product_quota'].toString();
                  codeController.text = model['product_code'].toString();

                  return Column(
                    children: [
                      const Center(
                        child: Text(
                          'تعديل',
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(controller: nameController, label: 'الاسم'),
                      const SizedBox(height: 20),
                      CustomTextField(controller: amountController, label: 'الكمية'),
                      const SizedBox(height: 20),
                      CustomTextField(controller: codeController, label: 'كود', enabled: false),
                      const SizedBox(height: 20),
                      CustomTextField(controller: priceController, label: 'السعر'),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          BlocProvider.of<ProductsCubit>(context).updateProduct(
                            name: nameController.text,
                            quota: amountController.text,
                            code: codeController.text,
                            price: priceController.text,
                            id: model['id'],
                          );
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue[800],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              'تعديل',
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
            listener: (context, state) {},
          ),
        );
      },
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const ActionButton({required this.icon, required this.color, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: IconButton(
          icon: Icon(icon, color: color),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class ProductInfo extends StatelessWidget {
  final String text;

  const ProductInfo({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool enabled;

  const CustomTextField({
    required this.controller,
    required this.label,
    this.enabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        label: Row(
          children: [const Spacer(), Text(label)],
        ),
      ),
    );
  }
}
