import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'addScreen.dart';
import 'editScreen.dart';

class mainScreen extends StatefulWidget {
  const mainScreen({super.key});

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  final CollectionReference categoriesCollection = FirebaseFirestore.instance.collection('Categories');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.menu),
        title: const Center(child: Text("Budgeting App")),
        actions: [
          StreamBuilder<QuerySnapshot>(
            stream: categoriesCollection.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text('Error'),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                );
              }

              int itemCount = snapshot.data?.docs.length ?? 0;

              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: 30,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: Text('$itemCount')),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: categoriesCollection.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(
                color: Colors.black,
              ));
            }

            return ListView(
              padding: const EdgeInsets.all(20.0),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> item = document.data()! as Map<String, dynamic>;
                return GestureDetector(
                  onTap: () async {
                    final updatedItem = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditBudgetScreen(budgetItem: item, docId: document.id),
                      ),
                    );

                    if (updatedItem != null) {
                      setState(() {});
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 250,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white54,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Category Name : ${item['Category Name']}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Total Budgeted Amount : ${item['Total Budgeted Amount']}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Total Spent Amount : ${item['Total Spent Amount']}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newItem = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBudgetScreen()),
          );

          if (newItem != null) {
            setState(() {});
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}