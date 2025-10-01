import 'package:flutter/material.dart';
import 'featured_card.dart';

class FeaturedItemsList extends StatelessWidget {
  final List<Map<String, String>> featuredItems = [
    {
      "title": "Engineering Mathematics Textbook",
      "subtitle": "Used textbook - Excellent condition",
      "price": "₹450",
      "image":
          "https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=400&h=400",
    },
    {
      "title": "MacBook Air 2020",
      "subtitle": "M1 Chip - 8GB RAM - 256GB SSD",
      "price": "₹55,000",
      "image":
          "https://images.unsplash.com/photo-1541807084-5c52b6b3adef?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=400&h=400",
    },
    {
      "title": "Mountain Bike",
      "subtitle": "21 gears - Good condition",
      "price": "₹8,500",
      "image":
          "https://images.unsplash.com/photo-1571068316344-75bc76f77890?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=400&h=400",
    },
    {
      "title": "Study Desk with Chair",
      "subtitle": "Wooden desk + ergonomic chair combo",
      "price": "₹3,200",
      "image":
          "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=400&h=400",
    },
    {
      "title": "HP Printer Scanner",
      "subtitle": "HP DeskJet 2320 - All-in-one printer",
      "price": "₹2,800",
      "image":
          "https://images.unsplash.com/photo-1612198188060-c7c2a3b66eae?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=400&h=400",
    },
    {
      "title": "Mini Refrigerator",
      "subtitle": "Single door - Perfect for dorm room",
      "price": "₹6,500",
      "image":
          "https://images.unsplash.com/photo-1571175443880-49e1d25b2bc5?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=400&h=400",
    },
    {
      "title": "Scientific Calculator",
      "subtitle": "Casio FX-991EX - Advanced scientific calculator",
      "price": "₹1,200",
      "image":
          "https://images.unsplash.com/photo-1611224923853-80b023f02d71?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=400&h=400",
    },
    {
      "title": "Backpack - 30L",
      "subtitle": "American Tourister - Perfect for college",
      "price": "₹1,800",
      "image":
          "https://images.unsplash.com/photo-1487058792275-0ad4aaf24ca7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=400&h=400",
    },
    {
      "title": "LED Study Lamp",
      "subtitle": "Adjustable brightness - USB powered",
      "price": "₹950",
      "image":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=400&h=400",
    },
    {
      "title": "Electric Kettle",
      "subtitle": "1.5L capacity - Steel body",
      "price": "₹750",
      "image":
          "https://images.unsplash.com/photo-1544787219-7f47ccb76574?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=400&h=400",
    },
    {
      "title": "Gaming Keyboard",
      "subtitle": "Mechanical keyboard - RGB backlit",
      "price": "₹2,400",
      "image":
          "https://images.unsplash.com/photo-1587829741301-dc798b83add3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=400&h=400",
    },
    {
      "title": "Wireless Mouse",
      "subtitle": "Logitech M705 - Excellent battery life",
      "price": "₹1,500",
      "image":
          "https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=400&h=400",
    },
    {
      "title": "Floor Mattress",
      "subtitle": "Single bed mattress - 4 inch thick",
      "price": "₹2,200",
      "image":
          "https://images.unsplash.com/photo-1560185007-cde436f6a4d0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=400&h=400",
    },
    {
      "title": "Wooden Bookshelf",
      "subtitle": "5-tier bookshelf - Compact design",
      "price": "₹1,600",
      "image":
          "https://images.unsplash.com/photo-1594736797933-d0c4ec80d9ab?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=400&h=400",
    },
    {
      "title": "Bluetooth Speaker",
      "subtitle": "JBL Go 3 - Portable wireless speaker",
      "price": "₹1,900",
      "image":
          "https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=400&h=400",
    },
    {
      "title": "Steam Iron",
      "subtitle": "Non-stick sole plate - Auto shut-off",
      "price": "₹1,100",
      "image":
          "https://images.unsplash.com/photo-1586511925558-a4c6376fe65f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=400&h=400",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Featured Items",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            height: 300,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: featuredItems.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = featuredItems[index];
                return FeaturedCard(
                  title: item['title']!,
                  subtitle: item['subtitle']!,
                  price: item['price']!,
                  imageUrl: item['image']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
