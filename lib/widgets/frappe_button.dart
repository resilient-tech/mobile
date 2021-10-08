import 'package:flutter/material.dart';

import '../config/palette.dart';
import '../utils/enums.dart';
import '../utils/frappe_icon.dart';

class FrappeFlatButton extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  final ButtonType buttonType;
  final String? icon;
  final double height;
  final double minWidth;
  final bool fullWidth;

  FrappeFlatButton({
    required this.onPressed,
    required this.buttonType,
    required this.title,
    this.icon,
    this.height = 36.0,
    this.minWidth = 88,
    this.fullWidth = false,
  });

  FrappeFlatButton.small({
    required this.onPressed,
    required this.buttonType,
    required this.title,
    this.icon,
    this.height = 32.0,
    this.minWidth = 88,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    late Color _buttonColor;
    late TextStyle _textStyle;

    if (onPressed == null) {
      _buttonColor = Palette.disabledButonColor;
      _textStyle =
          TextStyle(color: Colors.white, fontSize: fullWidth ? 18 : null);
    } else if (buttonType == ButtonType.primary) {
      _buttonColor = Palette.primaryButtonColor;
      _textStyle =
          TextStyle(color: Colors.white, fontSize: fullWidth ? 18 : null);
    } else {
      _buttonColor = Palette.secondaryButtonColor;
      _textStyle =
          TextStyle(color: Colors.black, fontSize: fullWidth ? 18 : null);
    }

    if (icon != null) {
      return ButtonTheme(
        height: height,
        minWidth: fullWidth ? double.infinity : minWidth,
        child: TextButton.icon(
          label: Text(
            title,
            style: _textStyle,
          ),
          icon: FrappeIcon(icon!),
          onPressed: onPressed,
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.transparent,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(6),
                ),
              ),
            ),
            backgroundColor: MaterialStateProperty.all(_buttonColor),
          ),
        ),
      );
    } else {
      return ButtonTheme(
        height: height,
        minWidth: fullWidth ? double.infinity : minWidth,
        child: TextButton(
            onPressed: onPressed,
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(6),
                  ),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(_buttonColor),
            ),
            child: Text(
              title,
              style: _textStyle,
            )),
      );
    }
  }
}

class FrappeRaisedButton extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  final String? icon;
  final double height;
  final double minWidth;
  final Color color;
  final double? iconSize;
  final bool fullWidth;

  FrappeRaisedButton({
    required this.onPressed,
    required this.title,
    this.icon,
    this.iconSize,
    this.height = 36.0,
    this.color = Colors.white,
    this.minWidth = 88,
    this.fullWidth = false,
  });

  FrappeRaisedButton.small({
    required this.onPressed,
    required this.title,
    this.icon,
    this.iconSize,
    this.height = 32.0,
    this.color = Colors.white,
    this.minWidth = 88,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return ButtonTheme(
        height: height,
        minWidth: fullWidth ? double.infinity : minWidth,
        child: ElevatedButton.icon(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(color),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
            ),
          ),
          label: Text(title),
          icon: FrappeIcon(icon!, size: iconSize),
          onPressed: onPressed,
        ),
      );
    } else {
      return ButtonTheme(
        height: height,
        minWidth: fullWidth ? double.infinity : minWidth,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(color),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            title,
          ),
        ),
      );
    }
  }
}

class FrappeIconButton extends StatelessWidget {
  final void Function()? onPressed;
  final ButtonType buttonType;
  final String icon;
  final double height;
  final double minWidth;
  final bool fullWidth;

  FrappeIconButton({
    required this.onPressed,
    required this.buttonType,
    required this.icon,
    this.height = 36.0,
    this.minWidth = 88,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    Color _buttonColor;

    if (onPressed == null) {
      _buttonColor = Palette.disabledButonColor;
    } else if (buttonType == ButtonType.primary) {
      _buttonColor = Palette.primaryButtonColor;
    } else {
      _buttonColor = Palette.secondaryButtonColor;
    }

    return Container(
      decoration: BoxDecoration(
        color: _buttonColor,
        borderRadius: BorderRadius.all(
          Radius.circular(6),
        ),
      ),
      child: ButtonTheme(
        height: height,
        minWidth: fullWidth ? double.infinity : minWidth,
        child: IconButton(
          icon: FrappeIcon(icon),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
