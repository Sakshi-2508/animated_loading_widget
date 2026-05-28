import 'package:animated_loading_widget/animated_loading_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

enum DemoLoader { toast, noodle, coffee, plant, delivery }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DemoLoader selectedLoader = DemoLoader.toast;

  Widget get currentLoader {
    switch (selectedLoader) {
      case DemoLoader.toast:
        return const ToastLoader();
      case DemoLoader.noodle:
        return const NoodleLoader();
      case DemoLoader.coffee:
        return const CoffeeLoader();
      case DemoLoader.plant:
        return const PlantLoader();
      case DemoLoader.delivery:
        return const DeliveryLoader();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Animated Loading Widget',
      theme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          title: const Text('Animated Loading Widget'),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: Column(
          children: [
            Expanded(child: Center(child: currentLoader)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _LoaderTile(
                    title: '🍞 Toast Loader',
                    selected: selectedLoader == DemoLoader.toast,
                    onTap: () {
                      setState(() {
                        selectedLoader = DemoLoader.toast;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  _LoaderTile(
                    title: '🍜 Noodle Loader',
                    selected: selectedLoader == DemoLoader.noodle,
                    onTap: () {
                      setState(() {
                        selectedLoader = DemoLoader.noodle;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  _LoaderTile(
                    title: '☕ Coffee Loader',
                    selected: selectedLoader == DemoLoader.coffee,
                    onTap: () {
                      setState(() {
                        selectedLoader = DemoLoader.coffee;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  _LoaderTile(
                    title: '🌱 Plant Loader',
                    selected: selectedLoader == DemoLoader.plant,
                    onTap: () {
                      setState(() {
                        selectedLoader = DemoLoader.plant;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  _LoaderTile(
                    title: '📦 Delivery Loader',
                    selected: selectedLoader == DemoLoader.delivery,
                    onTap: () {
                      setState(() {
                        selectedLoader = DemoLoader.delivery;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoaderTile extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _LoaderTile({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? Colors.orange : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? Colors.orangeAccent : Colors.white12,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}
