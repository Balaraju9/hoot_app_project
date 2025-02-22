import 'package:flutter/material.dart';

class HootMainPage extends StatefulWidget {
  const HootMainPage({super.key});

  @override
  State<HootMainPage> createState() => _HootMainPageState();
}

class _HootMainPageState extends State<HootMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            mainAxisExtent: 150),
        children: const [
          // readout card
          // listen & repeat card
        ],
      ),
    );
  }
}
