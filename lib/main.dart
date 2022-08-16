import 'package:capstone_project_hcmut/controllers/counter_provider.dart';
import 'package:capstone_project_hcmut/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  final counterProvider = CounterProvider();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => counterProvider),
      ],
      child: const CapStoneProject(),
    ),
  );
}

class CapStoneProject extends StatefulWidget {
  const CapStoneProject({Key? key}) : super(key: key);

  @override
  State<CapStoneProject> createState() => _CapStoneProjectState();
}

class _CapStoneProjectState extends State<CapStoneProject> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'English Learning Application',
      home: HomeScreen(),
    );
  }
}
