import 'package:flutter/material.dart';
import 'package:io_crossword/welcome/welcome.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const WelcomeView();
  }
}

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: ConstrainedBox(
            constraints: const BoxConstraints.tightFor(width: 294),
            child: const ChallengeProgress(
              solvedWords: 25,
              totalWords: 100,
            ),
          ),
        ),
      ),
    );
  }
}
