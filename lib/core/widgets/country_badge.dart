import 'package:flutter/material.dart';

/// Small pill showing a country code, using the brand's gold (tertiary)
/// accent as a secondary highlight next to the pink-accented primary data.
/// Shared between [WeatherDataTable] and [CityDetailScreen] for visual
/// consistency.
class CountryBadge extends StatelessWidget {
  const CountryBadge({super.key, required this.countryCode});

  final String countryCode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiary.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        countryCode,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.tertiary,
        ),
      ),
    );
  }
}
