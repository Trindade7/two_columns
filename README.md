#Responsive dual pane layout in flutter

*Multiple column layout on large screens, that collapses to drawers or popups on small screens are extremely common on responsive apps. In this tutorial I will show you how to create exactly that.*

**Motivation**
While there loads of widgets to create drawers in flutter, I couldn't find any that allowed me to easily expand and collapse a dual pane screen, one for details and one for the main content. As such I decided o create one and share it with everyone.

**OBS:** this is a summarized version quickly set it up. For an in depth dive of the implementation and reasons behind each design choice go to the [In depth tutorial](https://dev.to/trindade7/responsive-dual-pane-layout-in-flutter-in-depth-4k6p)


## The code

To make it easly reusable we will create a widget that holds and is responsable for the panes behaviour:
```dart
class TwoColumns extends StatelessWidget {
  final double breakpoint = 800;
  final int paneProportion = 70;

  @override
  Widget build(BuildContext context) {
    if (breakpoint < MediaQuery.of(context).size.width) {
      return Flex(
        direction: Axis.horizontal,
        children: [
          Flexible(flex: paneProportion, child: Pane1()),
          Flexible(flex: 100 - paneProportion, child: Pane2()),
        ],
      );
    }
    return Flex(
      direction: Axis.horizontal,
      children: [
        Flexible(
          flex: 100, child: Pane1() ),
      ],
    );
  }
}

```
`Pane1` and `Pane2` are simple Containers with a text child and a background to make it easier to distinguish them.

```dart

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
```

Note that they are enclosed in a `Flexible` widget. Pane1 has a flex of `paneProportion` and pane2 the remaining space `100 - paneProportion` which, in this case are 70 and 30 respectively.

As it stands, the widget has a flexible widget That adusts the panels size acording to the device screen width. Once the width is smaller than the break point we return only the fist pane, However, this does not accomodate for small screens yet.

![flexible layout](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/kr3byh1qd9vt9sfuqbq2.gif)

## Small screens Popup page
Now that we have the flexible layout working, lets add the popup page for small screens. This is the longest part since there a few caveats to be mindful of so bear with me.

```dart

class TwoColumns extends StatefulWidget {
  final Widget pane1;
  final Widget pane2;
  final bool showPane2;
  final void Function() onClosePane2Popup;
  final double breakpoint;
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

  void _closePopup() {
    if (!_popupNotOpen) {
      SchedulerBinding.instance!
          .addPostFrameCallback((_) => Navigator.pop(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (canSplitPanes && widget.showPane2) {
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

```
The with the changes above, now whenever we resize the window or are on a small screen device, a pop up page will open for


To keep flutter as the only dependency, we will use a `StatefullWidget` to manage the state in this example.


###Pane 2
###Popup page

###Bringing it all together
First we have to build the page that will hold both screens, the main screen and the details screen.
```dart
class _HomePageState extends State<HomePage> {
  bool _showPane2Content = true;
  void _toggleSide() {
    setState(() {
      _showPane2Content = !_showPane2Content;
    });
  }

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
      body: TwoColumns(
        togglePane2: _toggleSide,
        context: context,
        showPane2: _showPane2Content,
        paneProportion: 70,
        //
        pane1: Pane1(
          toggleSide: _toggleSide,
        ),
        pane2: Pane2(toggleSide: _toggleSide),
      ),
    );
  }
}
```

We are using a statefull widget for simplicity and minimum dependency. Just use your favorite state management in your app.
**Ask in the comments for an example wih your state management package if you feel stuck.**



###Adding animations
While it works as desired, adding a simple animation will make it feel more fluid and increase the percieved perfomance.
