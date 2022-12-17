import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Application/Theme/theme_bloc.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeBloc = BlocProvider.of<ThemeBloc>(context);
    return Container(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Dark Mode",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            GestureDetector(
              child: themeBloc.state.theme_mode == ThemeMode.dark
                  ? const Icon(Icons.toggle_on)
                  : const Icon(Icons.toggle_off),
              onTap: () {
                if (themeBloc.state.theme_mode == ThemeMode.dark) {
                  themeBloc.add(LightMode());
                } else {
                  themeBloc.add(DarkMode());
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
