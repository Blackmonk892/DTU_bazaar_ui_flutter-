import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dtu_bazaar/utils/token_storage.dart';

class SellPageWeb extends StatefulWidget {
  @override
  _SellPageWebState createState() => _SellPageWebState();
}

class _SellPageWebState extends State<SellPageWeb> {
  final _formKey = GlobalKey<FormState>();

  final _titlecontroller = TextEditingController();
  final _descriptioncontroller = TextEditingController();
  final _pricecontroller = TextEditingController();
  final _phoneController = TextEditingController();
  final _instagramController = TextEditingController();
  final _upiController = TextEditingController();

  List<PlatformFile> _pickedFiles = [];

  Future<void> _pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _pickedFiles = result.files;
      });
    }
  }

  Future<String?> getToken() async {
    return await TokenStorage.getToken();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_pickedFiles.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please upload at least one image.')),
        );
        return;
      }

      final token = await getToken();
      if (token == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('User not authenticated.')));
        return;
      }

      final productData = {
        'title': _titlecontroller.text.trim(),
        'description': _descriptioncontroller.text.trim(),
        'price': int.parse(_pricecontroller.text.trim()),
        'phone': _phoneController.text.trim(),
        'instagram': _instagramController.text.trim(),
        'upi': _upiController.text.trim(),
      };

      try {
        // 1. Create product
        final productResponse = await http.post(
          Uri.parse('http://localhost:8000/products/'), // Replace with your URL
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(productData),
        );

        if (productResponse.statusCode == 200 ||
            productResponse.statusCode == 201) {
          final productId = jsonDecode(productResponse.body)['id'];

          // 2. Upload images
          for (var file in _pickedFiles) {
            final base64Image = base64Encode(file.bytes!);
            final imageResponse = await http.post(
              Uri.parse(
                'http://localhost:8000/products/$productId/images',
              ), // Replace with your URL
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: jsonEncode({'image_data': base64Image}),
            );

            if (imageResponse.statusCode != 200 &&
                imageResponse.statusCode != 201) {
              throw Exception('Image upload failed');
            }
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Item submitted successfully!')),
          );

          _formKey.currentState!.reset();
          setState(() {
            _pickedFiles.clear();
          });
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Product creation failed')));
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sell an Item')),

      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 700),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upload Images',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 8),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _pickedFiles.map((file) {
                        return Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.memory(
                            file.bytes as Uint8List,
                            fit: BoxFit.cover,
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: _pickImages,
                      icon: Icon(Icons.image_outlined),
                      label: Text("Select Images"),
                    ),

                    TextFormField(
                      controller: _titlecontroller,
                      decoration: InputDecoration(labelText: 'Title'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter a Title' : null,
                    ),

                    TextFormField(
                      controller: _descriptioncontroller,
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 4,
                      validator: (value) =>
                          value!.isEmpty ? 'Enter a description' : null,
                    ),

                    TextFormField(
                      controller: _pricecontroller,
                      decoration: InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value!.isEmpty ? 'Enter a price' : null,
                    ),

                    Text(
                      'Contact Info (Optional)',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),

                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(labelText: 'Phone Number'),
                    ),
                    TextFormField(
                      controller: _instagramController,
                      decoration: InputDecoration(labelText: 'Instagram ID'),
                    ),
                    TextFormField(
                      controller: _upiController,
                      decoration: InputDecoration(labelText: 'UPI ID'),
                    ),

                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _submitForm,
                        icon: Icon(Icons.upload_rounded),
                        label: Text('Post Item'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          textStyle: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
