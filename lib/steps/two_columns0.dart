import 'package:flutter/material.dart';

class Pane1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[200],
      child: Center(
        child: Text('Pane 1'),
      ),
    );
  }
}

class Pane2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[200],
      child: Center(
        child: Text('Pane 2'),
      ),
    );
  }
}

class TwoColumns extends StatelessWidget {
  final double breakpoint = 800;
  final int paneProportion = 70;

  @override
  Widget build(BuildContext context) {
    if (breakpoint < MediaQuery.of(context).size.width) {
      return Flex(
        direction: Axis.horizontal,
        children: [
          Flexible(
            flex: paneProportion,
            child: Pane1(),
          ),
          Flexible(
            flex: 100 - paneProportion,
            child: Pane2(),
          ),
        ],
      );
    }
    return Flex(
      direction: Axis.horizontal,
      children: [
        Flexible(
          flex: 100,
          child: Pane1(),
        ),
      ],
    );
  }
}
