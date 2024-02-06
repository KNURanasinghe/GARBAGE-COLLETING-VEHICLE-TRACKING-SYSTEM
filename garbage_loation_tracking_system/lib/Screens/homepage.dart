import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final token;
  const HomeScreen({Key? key, required this.token}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vehicle Location Sender"),
      ),
      body: Column(
        children: [
          Center(
              child:
                  ElevatedButton(onPressed: () {}, child: const Text("Start")))
        ],
      ),
    );
  }
}
