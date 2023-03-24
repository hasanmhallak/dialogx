import 'package:dialogx/dialogx.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyWidget());
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.showModalDialog(
                        builder: (context) => AlertDialog(
                          title: const Text('Alert!'),
                          content: const Text('Something happened!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                context.dismiss();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text('Show Alert'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.showToast('Hello World!');
                    },
                    child: const Text('Show Toast'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
