import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
get_button(
        {required BuildContext context,
        required void Function() action,
        double radi = 10,
        required Widget child,
        double height = 45,
        double width = 300}) =>
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        minimumSize: Size(width, height),
        maximumSize: Size(width + 10, height + 5),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(radi)),
        alignment: Alignment.center,
      ),
      onPressed: action,
      child: child,
    );
