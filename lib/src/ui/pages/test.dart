import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: DraggableScrollableSheet(
                  snapAnimationDuration: const Duration(seconds: 5),
                  initialChildSize: 0.80,
                  maxChildSize: 1,
                  minChildSize: 0.30,
                  builder: ( context, scrollController) {
                    return Container(
                      color: Colors.blue[100],
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: 25,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(title: Text('Item $index'));
                        },
                      ),
                    );
                  }
                ),
      ),
    );
  }
}