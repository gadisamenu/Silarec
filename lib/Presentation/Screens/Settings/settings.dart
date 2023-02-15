import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Application/Theme/theme_bloc.dart';

_dark_mode_on_tap(ThemeBloc themeBloc) {
  if (themeBloc.state.theme_mode != ThemeMode.dark) {
    themeBloc.add(DarkMode());
  } else {
    themeBloc.add(LightMode());
  }
}

_system_mode_on_tap(ThemeBloc themeBloc) {
  if (themeBloc.state.theme_mode == ThemeMode.system) {
    themeBloc.add(SystemMode());
  } else {
    themeBloc.add(LightMode());
  }
}

get_list_tile_decor(BuildContext context) => BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: Theme.of(context).colorScheme.onPrimary,
    );

Icon get_toggle_icon(BuildContext context, ThemeBloc themeBloc,
    {required ThemeMode true_case}) {
  return themeBloc.state.theme_mode == true_case
      ? Icon(
          Icons.toggle_on,
          color: Colors.blue[700],
        )
      : const Icon(Icons.toggle_off);
}

const tile_margin = EdgeInsets.symmetric(vertical: 5, horizontal: 10);
const content_padding = EdgeInsets.symmetric(horizontal: 30);

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeBloc = BlocProvider.of<ThemeBloc>(context);
    return Container(
      child: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 15),
          children: [
            Container(
              margin: tile_margin,
              decoration: get_list_tile_decor(context),
              child: ListTile(
                contentPadding: content_padding,
                title: const Text("Use device Theme"),
                trailing: GestureDetector(
                  onTap: () => _system_mode_on_tap(themeBloc),
                  child: get_toggle_icon(context, themeBloc,
                      true_case: ThemeMode.system),
                ),
              ),
            ),
            Container(
              margin: tile_margin,
              decoration: get_list_tile_decor(context),
              child: ListTile(
                title: const Text("Dark Mode"),
                contentPadding: content_padding,
                trailing: GestureDetector(
                  onTap: themeBloc.state.theme_mode == ThemeMode.system
                      ? null
                      : () => _dark_mode_on_tap(themeBloc),
                  child: get_toggle_icon(context, themeBloc,
                      true_case: ThemeMode.dark),
                ),
              ),
            ),
            Container(
              margin: tile_margin,
              decoration: get_list_tile_decor(context),
              child: ListTile(
                title: const Text("Auto rescan"),
                subtitle: Text(
                  "Automatically scan for new videos at startup",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                contentPadding: content_padding,
                trailing: GestureDetector(
                  onTap: () => {},
                  child: get_toggle_icon(context, themeBloc,
                      true_case: ThemeMode.light),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get_title() => "Settings";
}
