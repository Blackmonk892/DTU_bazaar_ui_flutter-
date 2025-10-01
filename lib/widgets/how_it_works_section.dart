import 'package:flutter/material.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "How DTU Bazaar Works",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 40),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Step 1
              Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.indigo.shade100,
                    child: Icon(
                      Icons.account_circle,
                      size: 30,
                      color: Colors.indigo,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Create Account",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  SizedBox(
                    width: 240,
                    child: Text(
                      "Sign up with your DTU email to verify your student status",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                ],
              ),

              // Step 2
              Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.indigo.shade100,
                    child: Icon(
                      Icons.camera_alt,
                      size: 30,
                      color: Colors.indigo,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "List Items",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  SizedBox(
                    width: 240,
                    child: Text(
                      "Upload photos and details of items you want to sell",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                ],
              ),

              // Step 3
              Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.indigo.shade100,
                    child: Icon(
                      Icons.handshake,
                      size: 30,
                      color: Colors.indigo,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Meet & Exchange",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  SizedBox(
                    width: 240,
                    child: Text(
                      "Arrange to meet on campus to complete the transaction",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
