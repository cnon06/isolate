import 'dart:isolate';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int computeHeavyTask1() {
    int sum = 0;
    print("Computation1 has been started");
    for (int i = 0; i < 1000000000; i++) {
      sum += i;
    }
    print("Computation1 has been finished");

    return sum;
  }

  static computeHeavyTask2(SendPort sendPort) {
    int sum = 0;
    print("Computation2 has been started");
    for (int i = 0; i < 1000000000; i++) {
      sum += i;
    }
    print("Computation2 has been finished");
    sendPort.send(sum);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircularProgressIndicator(),
            TextButton(
                onPressed: () {
                  final sum = computeHeavyTask1();
                  print("sum1: $sum");
                },
                child: const Text("ComputeHeavyTask1")),
            TextButton(
                onPressed: () async {
                  final recievePort = ReceivePort();
                  await Isolate.spawn(computeHeavyTask2, recievePort.sendPort);

                  recievePort.listen((sum) {
                    print("sum2: $sum");
                  });

                  //computeHeavyTask();
                },
                child: const Text("ComputeHeavyTask2")),
          ],
        ),
      ),
    );
  }
}
