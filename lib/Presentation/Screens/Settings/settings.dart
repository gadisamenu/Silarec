import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Application/Theme/theme_bloc.dart';
import '../../_shared/Widgets/buttom_navigator_bar.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeBloc = BlocProvider.of<ThemeBloc>(context);
    final bool dark = themeBloc.state.theme_mode == ThemeMode.dark;
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primary,
          body: GestureDetector(
            child: dark
                ? const Icon(Icons.toggle_on)
                : const Icon(Icons.toggle_off),
            onTap: () {
              if (dark) {
                themeBloc.add(LightMode());
              } else {
                themeBloc.add(DarkMode());
              }
            },
          ),
          bottomNavigationBar: navBar,
        );
      },
    );
  }
}
