import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Dashboard",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Row(
            children: const [
              Icon(Icons.notifications_outlined),
              SizedBox(width: 20),
              CircleAvatar(child: Icon(Icons.person)),
            ],
          )
        ],
      ),
    );
  }
}
