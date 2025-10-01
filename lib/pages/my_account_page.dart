import 'package:flutter/material.dart';
import 'package:dtu_bazaar/services/auth_service.dart';
import 'package:dtu_bazaar/utils/token_storage.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  final _formKey = GlobalKey<FormState>();
  bool loading = true;
  String? _accessToken;

  Map<String, String> profile = {
    'name': '',
    'phone': '',
    'instagram': '',
    'email': '',
  };

  List<Map<String, dynamic>> sellingHistory = [];
  List<Map<String, dynamic>> buyingHistory = [];

  bool profileComplete = false;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final token = await TokenStorage.getToken();

    if (token == null || token.isEmpty) {
      Navigator.of(context).pushReplacementNamed('/auth');
      return;
    }

    try {
      final data = await AuthService.fetchProfile(token);
      final hasAllFields =
          data['name']?.isNotEmpty == true &&
          data['phone']?.isNotEmpty == true &&
          data['instagram']?.isNotEmpty == true;

      setState(() {
        _accessToken = token;
        profile = {
          'name': data['name'] ?? '',
          'phone': data['phone'] ?? '',
          'instagram': data['instagram'] ?? '',
          'email': data['email'] ?? '',
        };
        profileComplete = hasAllFields;
      });

      if (hasAllFields) {
        await loadHistory(token);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading profile: $e')));
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> loadHistory(String token) async {
    final data = await AuthService.fetchUserHistory(token);
    setState(() {
      sellingHistory = List<Map<String, dynamic>>.from(data['selling'] ?? []);
      buyingHistory = List<Map<String, dynamic>>.from(data['buying'] ?? []);
    });
  }

  Future<void> updateProfile() async {
    if (_formKey.currentState!.validate()) {
      if (_accessToken == null) return;

      try {
        await AuthService.updateProfile(_accessToken!, profile);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Profile updated')));

        setState(() {
          profileComplete = true;
        });

        await loadHistory(_accessToken!);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Update failed: $e')));
      }
    }
  }

  void _logout() async {
    await TokenStorage.clearToken();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Logged out')));
    Navigator.of(context).pushReplacementNamed('/auth');
  }

  void _toggleStatus(int index) {
    setState(() {
      final currentStatus = sellingHistory[index]['status'];
      final newStatus = currentStatus == 'Available' ? 'Sold' : 'Available';
      sellingHistory[index]['status'] = newStatus;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Item marked as $newStatus')));
    });
  }

  Widget _buildField(String label, String key) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: profile[key],
        decoration: InputDecoration(labelText: label),
        onChanged: (value) => profile[key] = value,
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Required' : null,
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      margin: EdgeInsets.only(bottom: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Wrap(
          runSpacing: 12,
          spacing: 32,
          children: [
            Text('Name: ${profile['name']}', style: TextStyle(fontSize: 16)),
            Text('Email: ${profile['email']}', style: TextStyle(fontSize: 16)),
            Text('Phone: ${profile['phone']}', style: TextStyle(fontSize: 16)),
            Text(
              'Instagram: ${profile['instagram']}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSellingItemCard(Map<String, dynamic> item, int index) {
    final isAvailable = item['status'] == 'Available';
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Image.network(
          item['imageUrl'] ?? '',
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
        title: Text(item['title']),
        subtitle: Text('Status: ${item['status']}'),
        trailing: ElevatedButton(
          onPressed: () => _toggleStatus(index),
          style: ElevatedButton.styleFrom(
            backgroundColor: isAvailable ? Colors.orange : Colors.green,
          ),
          child: Text(isAvailable ? 'Mark as Sold' : 'Mark as Available'),
        ),
      ),
    );
  }

  Widget _buildBuyingItemCard(Map<String, dynamic> item) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Image.network(
          item['imageUrl'] ?? '',
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
        title: Text(item['title']),
        subtitle: Text('Seller: ${item['seller']}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(
        title: Text('My Account'),
        actions: [
          TextButton.icon(
            onPressed: _logout,
            icon: Icon(Icons.logout, color: Colors.white),
            label: Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileCard(),
                const SizedBox(height: 24),
                if (!profileComplete)
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildField('Name', 'name'),
                        _buildField('Phone', 'phone'),
                        _buildField('Instagram', 'instagram'),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: updateProfile,
                          child: Text('Save Profile'),
                        ),
                      ],
                    ),
                  ),
                if (profileComplete) ...[
                  const SizedBox(height: 32),
                  Text(
                    'My Selling History',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  ...sellingHistory.asMap().entries.map(
                    (entry) => _buildSellingItemCard(entry.value, entry.key),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'My Buying History',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  ...buyingHistory.map(_buildBuyingItemCard),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
