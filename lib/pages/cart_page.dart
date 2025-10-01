import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dtu_bazaar/utils/token_storage.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cartItems = [];

  /// ✅ Updated fetchCart function with proper backend integration
  Future<void> _fetchCart() async {
    final token = await TokenStorage.getToken();
    if (token == null) return;

    try {
      final response = await http.get(
        Uri.parse(
          'http://localhost:8000/mycart/',
        ), // ⬅️ Replace with actual production URL
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List;
        setState(() {
          cartItems = list.map((e) {
            final product = e['product'];
            return {
              'title': product['title'],
              'description': product['description'],
              'price': product['price'].toString(),
              'phone': product['phone'] ?? '',
              'instagram': product['instagram'] ?? '',
              'upi': product['upi'] ?? '',
            };
          }).toList();
        });
      } else {
        print('Error fetching cart: ${response.body}');
      }
    } catch (e) {
      print('Exception during fetchCart: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Cart'), centerTitle: true),
      body: cartItems.isEmpty
          ? Center(child: Text('Your cart is empty'))
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
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
                          child: Text(
                            'Request sent',
                            style: TextStyle(color: Colors.green),
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
