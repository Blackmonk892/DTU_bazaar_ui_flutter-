import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dtu_bazaar/utils/token_storage.dart';

class BuyPage extends StatefulWidget {
  @override
  _BuyPageState createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  List<Map<String, dynamic>> items = [];

  Future<void> _fetchProducts() async {
    final resp = await http.get(Uri.parse('http://localhost:8000/search/'));
    if (resp.statusCode == 200) {
      final list = jsonDecode(resp.body) as List;
      setState(() {
        items = list
            .map(
              (e) => {
                'id': e['id'],
                'title': e['title'],
                'description': e['description'],
                'price': e['price'].toString(),
                'images': e['images'], // list of {"image_data": "..."}
                'phone': e['phone'] ?? '',
                'instagram': e['instagram'] ?? '',
                'upi': e['upi'] ?? '',
              },
            )
            .toList();
      });
    }
  }

  Future<void> _buyItem(int productId) async {
    final token = await TokenStorage.getToken();
    if (token == null) return;
    final resp = await http.post(
      Uri.parse('http://localhost:8000/buy/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'product_id': productId, 'buyer_id': null}),
    );
    if (resp.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Request sent to seller!')));
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buy Items'), centerTitle: true),
      body: items.isEmpty
          ? Center(child: Text('No items available'))
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'],
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: 8),
                        Text(item['description']),
                        SizedBox(height: 8),
                        Text(
                          'Price: ₹${item['price']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (item['phone'] != '')
                          Text('Phone: ${item['phone']}'),
                        if (item['instagram'] != '')
                          Text('Instagram: ${item['instagram']}'),
                        if (item['upi'] != '') Text('UPI: ${item['upi']}'),
                        SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: () => _buyItem(item['id']),
                            icon: Icon(Icons.shopping_cart_outlined),
                            label: Text('Buy'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              textStyle: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
