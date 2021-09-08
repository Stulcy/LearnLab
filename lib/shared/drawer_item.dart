// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// 🌎 Project imports:
import 'package:learnlab/shared/constants.dart';

class DrawerItem extends StatelessWidget {
  final String _name;
  final IconData _icon;
  final void Function() _onTap;
  final bool _drawIcon;
  final bool _selected;

  const DrawerItem({
    @required String name,
    IconData icon = Icons.ac_unit,
    @required void Function() onTap,
    bool drawIcon = true,
    bool selected = false,
  })  : _name = name,
        _icon = icon,
        _onTap = onTap,
        _drawIcon = drawIcon,
        _selected = selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
      ),
      child: InkWell(
        onTap: _onTap,
        child: Container(
          margin: const EdgeInsets.only(left: 6.0),
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              SizedBox(
                width: 24.0,
                height: 24.0,
                child: FittedBox(
                  child: FaIcon(
                    _icon,
                    color: _drawIcon
                        ? (_selected
                            ? ColorTheme.dark
                            : ColorTheme.textLightGray)
                        : Colors.transparent,
                  ),
                ),
              ),
              const SizedBox(width: 20.0),
              Text(
                _name,
                style: burgerTextStyle.copyWith(
                  color: _selected ? ColorTheme.dark : ColorTheme.textLightGray,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
