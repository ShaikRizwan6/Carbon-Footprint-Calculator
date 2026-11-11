import 'package:flutter/material.dart';

void main() {
  runApp(const CarbonCalculatorApp());
}

class CarbonCalculatorApp extends StatelessWidget {
  const CarbonCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carbon Footprint Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E5631),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF2F5F3),
      ),
      home: const CarbonCalculatorScreen(),
    );
  }
}

class CarbonCalculatorScreen extends StatefulWidget {
  const CarbonCalculatorScreen({super.key});

  @override
  State<CarbonCalculatorScreen> createState() => _CarbonCalculatorScreenState();
}

class _CarbonCalculatorScreenState extends State<CarbonCalculatorScreen> {
  // Input State
  double _dailyDistance = 25.0;
  String _transportMode = 'Car';
  double _monthlyElectricity = 250.0;
  String _dietaryPattern = 'Balanced';
  bool _enableGoalTarget = false;
  final Set<String> _completedTips = <String>{};

  // Emission Factors
  static const Map<String, double> _transportFactors = <String, double>{
    'Car': 0.19,
    'Bus': 0.10,
    'Electric Vehicle': 0.05,
    'Bike / Walk': 0.00,
  };

  static const Map<String, IconData> _transportIcons = <String, IconData>{
    'Car': Icons.directions_car,
    'Bus': Icons.directions_bus,
    'Electric Vehicle': Icons.ev_station,
    'Bike / Walk': Icons.directions_bike,
  };

  static const Map<String, double> _dietFactors = <String, double>{
    'Meat Heavy': 3300.0,
    'Balanced': 2500.0,
    'Vegetarian': 1700.0,
    'Vegan': 1500.0,
  };

  static const Map<String, IconData> _dietIcons = <String, IconData>{
    'Meat Heavy': Icons.restaurant,
    'Balanced': Icons.set_meal,
    'Vegetarian': Icons.eco,
    'Vegan': Icons.local_florist,
  };

  static const double _gridFactor = 0.85;

  // Emissions Calculations
  double get _transportEmissionsTons {
    final double factor = _transportFactors[_transportMode] ?? 0.0;
    return (_dailyDistance * 365.0 * factor) / 1000.0;
  }

  double get _electricityEmissionsTons {
    return (_monthlyElectricity * 12.0 * _gridFactor) / 1000.0;
  }

  double get _dietEmissionsTons {
    return (_dietFactors[_dietaryPattern] ?? 2500.0) / 1000.0;
  }

  double get _totalEmissionsTons {
    final double total =
        _transportEmissionsTons +
        _electricityEmissionsTons +
        _dietEmissionsTons;
    return _enableGoalTarget ? total * 0.8 : total;
  }

  List<String> get _recommendations {
    final double transport = _transportEmissionsTons;
    final double electricity = _electricityEmissionsTons;
    final double diet = _dietEmissionsTons;

    if (transport >= electricity && transport >= diet) {
      return const <String>[
        'Car pool or take public transit 2–3 times a week.',
        'Switch to an Electric Vehicle or hybrid for your next car.',
        'Walk or bike for short trips under 3 km.',
      ];
    } else if (electricity >= transport && electricity >= diet) {
      return const <String>[
        'Switch to LED lighting and turn off unused electronics.',
        'Adjust your thermostat by 1–2 degrees to save energy.',
        'Consider installing solar panels or switching to a green energy provider.',
      ];
    } else {
      return const <String>[
        'Try "Meatless Mondays" to gradually reduce meat consumption.',
        'Incorporate more plant-based protein sources like beans and lentils.',
        'Reduce food waste by planning meals and storing produce properly.',
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Carbon Footprint Studio',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildInteractiveDashboard(colorScheme),
                  const SizedBox(height: 16),
                  _buildInteractiveTransportCard(colorScheme),
                  const SizedBox(height: 16),
                  _buildInteractiveElectricityCard(colorScheme),
                  const SizedBox(height: 16),
                  _buildInteractiveDietCard(colorScheme),
                  const SizedBox(height: 16),
                  _buildInteractiveChecklistCard(colorScheme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInteractiveDashboard(ColorScheme colorScheme) {
    final double totalTons = _totalEmissionsTons;
    final double transport = _transportEmissionsTons;
    final double electricity = _electricityEmissionsTons;
    final double diet = _dietEmissionsTons;
    final double rawTotal = transport + electricity + diet;

    final String impactLabel;
    final Color badgeColor;
    final Color textColor;

    if (totalTons < 3.0) {
      impactLabel = 'Low Footprint';
      badgeColor = Colors.green.shade100;
      textColor = Colors.green.shade900;
    } else if (totalTons <= 5.5) {
      impactLabel = 'Moderate Footprint';
      badgeColor = Colors.orange.shade100;
      textColor = Colors.orange.shade900;
    } else {
      impactLabel = 'High Footprint';
      badgeColor = Colors.red.shade100;
      textColor = Colors.red.shade900;
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'ANNUAL ESTIMATE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: colorScheme.onPrimaryContainer.withValues(
                      alpha: 0.7,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    impactLabel,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    totalTons.toStringAsFixed(2),
                    key: ValueKey<String>(totalTons.toStringAsFixed(2)),
                    style: TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Metric Tons CO₂e',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onPrimaryContainer.withValues(
                      alpha: 0.8,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            _buildBreakdownBar(
              label: 'Transport',
              valueTons: transport,
              totalTons: rawTotal,
              color: Colors.blue.shade600,
            ),
            const SizedBox(height: 8),
            _buildBreakdownBar(
              label: 'Electricity',
              valueTons: electricity,
              totalTons: rawTotal,
              color: Colors.amber.shade700,
            ),
            const SizedBox(height: 8),
            _buildBreakdownBar(
              label: 'Diet Pattern',
              valueTons: diet,
              totalTons: rawTotal,
              color: Colors.teal.shade600,
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Simulate 20% Reduction Goal',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              subtitle: const Text(
                'See your potential impact with targeted eco-actions',
                style: TextStyle(fontSize: 11),
              ),
              value: _enableGoalTarget,
              onChanged: (bool value) {
                setState(() {
                  _enableGoalTarget = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownBar({
    required String label,
    required double valueTons,
    required double totalTons,
    required Color color,
  }) {
    final double fraction = totalTons > 0 ? (valueTons / totalTons) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            Text(
              '${valueTons.toStringAsFixed(2)} T (${(fraction * 100).round()}%)',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 6,
            backgroundColor: Colors.grey.shade300,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildInteractiveTransportCard(ColorScheme colorScheme) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(Icons.directions_car, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Daily Transport',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Distance per day:'),
                Text(
                  '${_dailyDistance.round()} km',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            Slider(
              value: _dailyDistance,
              min: 0,
              max: 100,
              divisions: 100,
              label: '${_dailyDistance.round()} km',
              onChanged: (double value) {
                setState(() {
                  _dailyDistance = value;
                });
              },
            ),
            const SizedBox(height: 8),
            const Text(
              'Primary Mode of Travel:',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _transportFactors.keys.map((String mode) {
                final bool isSelected = _transportMode == mode;
                return ChoiceChip(
                  avatar: Icon(
                    _transportIcons[mode],
                    size: 18,
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurfaceVariant,
                  ),
                  label: Text(mode),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    if (selected) {
                      setState(() {
                        _transportMode = mode;
                      });
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractiveElectricityCard(ColorScheme colorScheme) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(Icons.bolt, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Home Electricity',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Monthly Usage:'),
                Text(
                  '${_monthlyElectricity.round()} kWh',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            Slider(
              value: _monthlyElectricity,
              min: 0,
              max: 600,
              divisions: 120,
              label: '${_monthlyElectricity.round()} kWh',
              onChanged: (double value) {
                setState(() {
                  _monthlyElectricity = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractiveDietCard(ColorScheme colorScheme) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(Icons.restaurant, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Dietary Pattern',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _dietFactors.keys.map((String pattern) {
                final bool isSelected = _dietaryPattern == pattern;
                return ChoiceChip(
                  avatar: Icon(
                    _dietIcons[pattern],
                    size: 18,
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurfaceVariant,
                  ),
                  label: Text(pattern),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    if (selected) {
                      setState(() {
                        _dietaryPattern = pattern;
                      });
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractiveChecklistCard(ColorScheme colorScheme) {
    final List<String> tips = _recommendations;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(Icons.task_alt, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Interactive Eco Action Plan',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Tap actions to mark them as completed:',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            ...tips.map((String tip) {
              final bool isDone = _completedTips.contains(tip);
              return Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    setState(() {
                      if (isDone) {
                        _completedTips.remove(tip);
                      } else {
                        _completedTips.add(tip);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: isDone
                          ? colorScheme.primaryContainer.withValues(alpha: 0.5)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDone
                            ? colorScheme.primary
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          isDone
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: isDone
                              ? colorScheme.primary
                              : Colors.grey.shade600,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            tip,
                            style: TextStyle(
                              fontSize: 13,
                              decoration: isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: isDone
                                  ? colorScheme.onSurfaceVariant
                                  : colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
