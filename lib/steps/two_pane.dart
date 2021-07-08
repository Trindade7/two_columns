import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Used to determine witch pane is the main and wich is the sideload/popup
///
///Default:  `pane1 == main`
enum TwoColumnsPriority {
  pane1,
  pane2,
  both,
}

class Pane1 extends StatelessWidget {
  final void Function() toggleSide;

  const Pane1({Key? key, required this.toggleSide}) : super(key: key);

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
  final void Function() toggleSide;

  const Pane2({Key? key, required this.toggleSide}) : super(key: key);

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

class TwoColumnsFinished extends StatefulWidget {
  final Widget pane1;
  final Widget pane2;

  /// The proportion of pane1 from 0 to 100
  final int paneProportion;

  /// wether pane2 is open or not
  final bool showPane2;
  final BuildContext context;

  /// The size at witch the panes should break into a single view
  final double breakpoint;

  /// call back to toggle the deatails pane
  final void Function() togglePane2;
  const TwoColumnsFinished({
    Key? key,
    required this.context,
    required this.pane1,
    required this.pane2,
    required this.paneProportion,
    required this.showPane2,
    required this.togglePane2,
    this.breakpoint = 600,
  })  : assert(paneProportion >= 0 && paneProportion <= 100),
        super(key: key);

  @override
  _TwoColumnsFinishedState createState() => _TwoColumnsFinishedState();
}

class _TwoColumnsFinishedState extends State<TwoColumnsFinished>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  /// keeps track of the pane2 popup page
  var _dialogNotOpened = true;

  /// checks if current width is smaller then the breakpoint
  get _canSideLoadPane2 =>
      widget.breakpoint <
      MediaQuery.of(widget.context).size.width; //? context??

  /// Loads the popup page for pane2 on small screens
  void loadPane2Page() async {
    if (widget.showPane2 && !_canSideLoadPane2 && _dialogNotOpened) {
      SchedulerBinding.instance!.addPostFrameCallback((_) async {
        _dialogNotOpened = false; // true untill rout poped
        _dialogNotOpened = await Navigator.of(context).push<bool>(
              new MaterialPageRoute<bool>(
                builder: (BuildContext context) {
                  return new Scaffold(
                    appBar: AppBar(title: Text('hello')),
                    body: WillPopScope(
                      // returns the
                      onWillPop: () async {
                        widget.togglePane2();
                        Navigator.pop(context, true);
                        return new Future(() => false);
                      },
                      child: widget.pane2,
                    ),
                  );
                },
                fullscreenDialog: true,
              ),
            ) ??
            false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    loadPane2Page();
    if (widget.showPane2 && _canSideLoadPane2) {
      return Flex(
        direction: Axis.horizontal,
        children: [
          Flexible(
            flex: widget.paneProportion,
            child: widget.pane1,
          ),
          Flexible(
            flex: 100 - widget.paneProportion,
            child: widget.pane2,
          ),
        ],
      );
    }
    return Flex(
      direction: Axis.horizontal,
      children: [
        Flexible(
          flex: 100,
          child: widget.pane1,
        ),
      ],
    );
  }
}
