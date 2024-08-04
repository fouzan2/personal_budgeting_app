import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditBudgetScreen extends StatefulWidget {
  final Map<String, dynamic> budgetItem;
  final String docId;

  EditBudgetScreen({required this.budgetItem, required this.docId});

  @override
  _EditBudgetScreenState createState() => _EditBudgetScreenState();
}

class _EditBudgetScreenState extends State<EditBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _categoryNameController;
  late TextEditingController _budgetedAmountController;

  @override
  void initState() {
    super.initState();
    _categoryNameController = TextEditingController(text: widget.budgetItem['Category Name']);
    _budgetedAmountController = TextEditingController(text: widget.budgetItem['Total Budgeted Amount'].toString());
  }

  @override
  void dispose() {
    _categoryNameController.dispose();
    _budgetedAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Budget Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _categoryNameController,
                decoration: const InputDecoration(labelText: 'Category Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _budgetedAmountController,
                decoration: const InputDecoration(labelText: 'Total Budgeted Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a budgeted amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await FirebaseFirestore.instance.collection('Categories').doc(widget.docId).update({
                          'Category Name': _categoryNameController.text,
                          'Total Budgeted Amount': double.parse(_budgetedAmountController.text),
                        });
                        Navigator.pop(context, true);
                      }
                    },
                    child: const Text('Update'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Background color
                    ),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}