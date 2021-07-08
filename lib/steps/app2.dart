import 'package:flutter/material.dart';
import 'package:two_columns/steps/two_columns2.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // demo content
  List<int> items = [for (var i = 1; i < 10; i++) i];
  ValueNotifier<int?> _selected = ValueNotifier(null);

  void _selectValue(int? val) => _selected.value = val;
  void _clearSelected() => _selected.value = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home page')),
      body: ValueListenableBuilder(
        builder: (context, _, child) {
          return TwoColumns(
            showPane2: (_selected.value != null) ? true : false,
            onClosePane2Popup: _clearSelected,
            pane1: Pane1(items: items, selectValue: _selectValue),
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
  final List<int> items;
  const Pane1({required this.selectValue, this.items = const []});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          ...items.map(
            (e) => Card(
              child: ListTile(
                title: Text('Item number $e'),
                onTap: () => selectValue(e),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Pane2 extends StatelessWidget {
  final int? value;

  const Pane2({Key? key, this.value}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 48.0),
        child: Padding(
            padding: const EdgeInsets.all(48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Item card',
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(color: Colors.blue[300]),
                ),
                SizedBox(height: 48),
                (value != null)
                    ? Text('Selected value is $value')
                    : Text(
                        'No Selected value .',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: Colors.red[300]),
                      ),
              ],
            )),
      ),
    );
  }
}
