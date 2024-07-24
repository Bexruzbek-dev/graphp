import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScren extends StatefulWidget {
  const HomeScren({super.key});

  @override
  _HomeScrenState createState() => _HomeScrenState();
}

class _HomeScrenState extends State<HomeScren> {
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productsString = prefs.getStringList('products') ?? [];
    setState(() {
      _products = productsString
          .map((e) => Map<String, dynamic>.from(jsonDecode(e)))
          .toList();
    });
  }

  Future<void> _saveProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productsString = _products.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList('products', productsString);
  }

  void _showProductDialog({Map<String, dynamic>? product, int? index}) {
    final titleController = TextEditingController(text: product?['title']);
    final descriptionController =
        TextEditingController(text: product?['description']);
    final priceController =
        TextEditingController(text: product?['price']?.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
              product == null ? 'Mahsulot qo\'shish' : 'Mahsulotni tahrirlash'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });

                final title = titleController.text;
                final description = descriptionController.text;
                final price = double.tryParse(priceController.text) ?? 0.0;

                await Future.delayed(
                    Duration(seconds: product == null ? 2 : 1));

                if (product == null) {
                  setState(() {
                    _products.add({
                      'title': title,
                      'description': description,
                      'price': price,
                    });
                  });
                } else {
                  setState(() {
                    _products[index!] = {
                      'title': title,
                      'description': description,
                      'price': price,
                    };
                  });
                }

                await _saveProducts();
                setState(() {
                  _isLoading = false;
                });
                Navigator.of(context).pop();
              },
              child: Text(product == null ? 'Create' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  void _deleteProduct(int index) async {
    setState(() {
      _products.removeAt(index);
    });
    await _saveProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "GRAPHQL",
          style: TextStyle(fontSize: 28),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _products.isEmpty
              ? const Center(child: Text('No products available'))
              : ListView.builder(
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final product = _products[index];

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(product['title']),
                        subtitle: Text(product['description']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                _showProductDialog(
                                    product: product, index: index);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _deleteProduct(index);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          _showProductDialog();
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
