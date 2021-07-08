import 'package:flutter/material.dart';
import 'package:two_columns/steps/two_pane1.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueNotifier<bool> _showPane2Content = ValueNotifier(false);
  void _toggleSide() => _showPane2Content.value = !_showPane2Content.value;
  ValueNotifier<int?> _selected = ValueNotifier(null);
  void _selectValue(int? val) => _selected.value = val;
  void _clearSelected() => _selected.value = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: IconButton(
              onPressed: _toggleSide,
              icon: Icon(Icons.menu),
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        builder: (context, _, child) {
          return TwoColumns(
            showPane2: (_selected.value != null) ? true : false,
            onClosePane2Popup: _clearSelected,
            pane1: Pane1(selectValue: _selectValue),
            pane2: Pane2(value: _selected.value),
          );
        },
        valueListenable: _selected,
      ),
    );
  }
}

class Pane1 extends StatelessWidget {
  final void Function(int?) selectValue;
  const Pane1({required this.selectValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[200],
      child: Center(
        child: ElevatedButton(
          child: Text('set value'),
          onPressed: () => selectValue(3),
        ),
      ),
    );
  }
}

class Pane2 extends StatelessWidget {
  final int? value;

  const Pane2({Key? key, this.value}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[200],
      child: Center(
        child: Text('Pane2 value is $value'),
      ),
    );
  }
}
