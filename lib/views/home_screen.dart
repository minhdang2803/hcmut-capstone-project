import 'package:capstone_project_hcmut/view_models/view_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer<CounterViewModel>(
                  builder: (context, counterProvider, child) {
                return Text(
                  counterProvider.instance.counter.toString(),
                  style: const TextStyle(fontSize: 20),
                );
              }),
              ElevatedButton(
                onPressed: () =>
                    Provider.of<CounterViewModel>(context, listen: false)
                        .increase(),
                child: const Text('Increase value'),
              ),
              ElevatedButton(
                onPressed: () =>
                    Provider.of<CounterViewModel>(context, listen: false)
                        .decrease(),
                child: const Text('Decrease value'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
