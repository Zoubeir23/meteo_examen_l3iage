import 'package:flutter/material.dart';

/// Circular progress gauge shown while the 5 cities' weather is loading.
///
/// This widget is purely presentational: [progress] (0.0-1.0) and
/// [loadingMessage] are driven from the outside. The animation
/// (AnimationController) and the rotating loading messages are owned by the
/// navigation/gauge module — this widget only needs a value to render.
///
/// Once [progress] reaches 1.0, pass [onRestart] to turn the gauge into the
/// "Recommencer" button required by the spec.
class WeatherProgressGauge extends StatelessWidget {
  const WeatherProgressGauge({
    super.key,
    required this.progress,
    required this.loadingMessage,
    this.onRestart,
  });

  final double progress;
  final String loadingMessage;
  final VoidCallback? onRestart;

  bool get _isComplete => progress >= 1.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 180,
          height: 180,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 180,
                height: 180,
                child: CircularProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  strokeWidth: 10,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
                ),
              ),
              if (_isComplete)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onRestart,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.refresh_rounded, size: 36, color: theme.colorScheme.primary),
                          const SizedBox(height: 8),
                          Text(
                            'Recommencer',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                Text(
                  '${(progress.clamp(0.0, 1.0) * 100).round()}%',
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _isComplete ? 'Données prêtes !' : loadingMessage,
            key: ValueKey(_isComplete ? 'done' : loadingMessage),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
