import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class TwoColumns extends StatefulWidget {
  final Widget pane1;
  final Widget pane2;

  /// keeps track of the pane2 open state
  final bool showPane2;

  /// Called called when pane2Popup
  final void Function() onClosePane2Popup;

  /// the breakpoint for small devices
  final double breakpoint;

  /// pane1 has a flex of `paneProportion`. Default = 70
  ///
  /// pane2 `100 - paneProportion`. Default = 30.
  final int paneProportion;

  const TwoColumns({
    Key? key,
    this.showPane2 = false,
    required this.pane1,
    required this.pane2,
    required this.onClosePane2Popup,
    this.breakpoint = 800,
    this.paneProportion = 70,
  }) : super(key: key);

  @override
  _TwoColumnsState createState() => _TwoColumnsState();
}

class _TwoColumnsState extends State<TwoColumns> {
  bool _popupNotOpen = true;

  bool get canSplitPanes =>
      widget.breakpoint < MediaQuery.of(context).size.width;

  /// Loads and removes the popup page for pane2 on small screens
  void loadPane2Page(BuildContext context) async {
    if (widget.showPane2 && _popupNotOpen) {
      _popupNotOpen = false;
      SchedulerBinding.instance!.addPostFrameCallback((_) async {
        // sets _popupNotOpen to true after popup is closed
        Navigator.of(context)
            .push<Null>(
          new MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return new Scaffold(
                appBar: AppBar(title: Text('hello')),
                body: widget.pane2,
              );
            },
            fullscreenDialog: true,
          ),
        )
            .then((_) {
          // less code than wapping in a WillPopScope
          _popupNotOpen = true;
          // preserves value if screen canSplitPanes
          if (!canSplitPanes) widget.onClosePane2Popup();
        });
      });
    }
  }

  /// closes popup wind
  void _closePopup() {
    if (!_popupNotOpen) {
      SchedulerBinding.instance!
          .addPostFrameCallback((_) => Navigator.pop(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (canSplitPanes) {
      _closePopup();
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
    } else {
      loadPane2Page(context);
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
}
