// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:google_fonts/google_fonts.dart';

// 🌎 Project imports:
import 'package:learnlab/shared/selector.dart';

class SearchSelector<T> extends StatefulWidget {
  final List<T> _data;
  final Widget Function(T, bool) _createWidget;
  final void Function(T) _select;
  final double _width;
  final double _height;
  final Color _color;

  const SearchSelector({
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
  _SearchSelectorState<T> createState() => _SearchSelectorState<T>();
}

class _SearchSelectorState<T> extends State<SearchSelector<T>> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    List<T> searchResult = widget._data;
    // Only find search results if input was provided
    if (search.isNotEmpty) {
      searchResult = searchResult
          .where((element) =>
              element.toString().toLowerCase().contains(search.toLowerCase()))
          .toList();
    }

    return Column(
      children: [
        CupertinoSearchTextField(
          placeholder: 'search',
          backgroundColor: widget._color,
          borderRadius: BorderRadius.circular(8),
          onChanged: (input) {
            setState(() {
              search = input.trim();
            });
          },
          style: GoogleFonts.quicksand(
            fontSize: 18.0,
          ),
        ),
        const SizedBox(height: 20),
        Selector<T>(
          data: searchResult,
          createWidget: widget._createWidget,
          select: widget._select,
          width: widget._width,
          height: widget._height,
          color: widget._color,
        ),
      ],
    );
  }
}
