// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class Selector<T> extends StatefulWidget {
  final List<T> _data;
  final Widget Function(T, bool) _createWidget;
  final void Function(T) _select;
  final double _width;
  final double _height;
  final Color _color;

  const Selector({
    @required List<T> data,
    @required Widget Function(T, bool) createWidget,
    @required void Function(T) select,
    double width = double.infinity,
    double height = double.infinity,
    Color color = Colors.white,
  })  : _data = data,
        _select = select,
        _createWidget = createWidget,
        _width = width,
        _height = height,
        _color = color;

  @override
  _SelectorState<T> createState() => _SelectorState<T>();
}

class _SelectorState<T> extends State<Selector<T>> {
  T selected;

  @override
  Widget build(BuildContext context) {
    if (selected == null && widget._data != null && widget._data.isNotEmpty) {
      selected = widget._data[0];
    }

    final Container child = Container(
      padding: const EdgeInsets.all(20.0),
      width: widget._width,
      height: widget._height != double.infinity ? widget._height : null,
      decoration: BoxDecoration(
        color: widget._color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: widget._data.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selected = widget._data[index];
                widget._select(widget._data[index]);
              });
            },
            child: widget._createWidget(
                widget._data[index], widget._data[index] == selected),
          );
        },
      ),
    );

    return widget._height != double.infinity
        ? child
        : Expanded(
            child: child,
          );
  }
}
