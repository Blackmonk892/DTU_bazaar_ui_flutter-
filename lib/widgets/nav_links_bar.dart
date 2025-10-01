import 'package:flutter/material.dart';
import 'package:dtu_bazaar/utils/token_storage.dart';

class NavLinksBar extends StatelessWidget {
  const NavLinksBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'DTU Bazaar',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        SizedBox(width: 40),
        _navTextButton(
          label: 'Home',
          onTap: () {
            Navigator.pushNamed(context, '/');
          },
        ),
        _navTextButton(
          label: 'Login',
          onTap: () {
            Navigator.pushNamed(context, '/auth');
          },
        ),
        _navTextButton(
          label: 'My Account',
          onTap: () async {
            final token = await TokenStorage.getToken();
            if (token != null && token.isNotEmpty) {
              Navigator.pushNamed(context, '/account');
            } else {
              Navigator.pushNamed(context, '/auth');
            }
          },
        ),
        _navTextButton(
          label: 'Sell',
          onTap: () {
            Navigator.pushNamed(context, '/sell');
          },
        ),
        _navTextButton(
          label: 'Buy',
          onTap: () {
            Navigator.pushNamed(context, '/buy');
          },
        ),
      ],
    );
  }

  Widget _navTextButton({required String label, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: InkWell(
        onTap: onTap,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.blueGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
