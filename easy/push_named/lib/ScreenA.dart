import 'package:flutter/material.dart';

class ScreenA extends StatelessWidget {
  const ScreenA({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            )),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Screen A',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart, color: Colors.white)),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings, color: Colors.white)),
        ],
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.grey[800]),
              child: const Text(
                'Go to Screen B',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {}),
          const SizedBox(
            height: 15.0,
          ),
          ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.grey[800]),
              child: const Text(
                'Go to Screen C',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {}),
        ],
      )),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
