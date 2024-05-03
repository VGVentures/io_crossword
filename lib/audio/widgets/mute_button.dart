import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/settings/settings.dart';

class MuteButton extends StatelessWidget {
  const MuteButton({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.read<SettingsController>();
    return ValueListenableBuilder<bool>(
      valueListenable: settings.muted,
      builder: (_, muted, __) {
        return IconButton(
          onPressed: settings.toggleMuted,
          icon: Icon(muted ? Icons.volume_off : Icons.volume_up),
        );
      },
    );
  }
}
