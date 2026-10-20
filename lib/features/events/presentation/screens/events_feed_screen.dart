
import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';

class EventsFeedScreen extends StatefulWidget {
  const EventsFeedScreen({super.key});

  @override
  State<EventsFeedScreen> createState() => _EventsFeedScreenState();
}

class _EventsFeedScreenState extends State<EventsFeedScreen> {
  String selectedFilter = 'All';

  // Temporary sample data for UI development only.
  final List<Map<String, String>> sampleEvents = [
    {
      'type': 'FLOOD',
      'severity': 'HIGH',
      'location': 'Sample area, Dhaka',
      'description':
      'Flood report example. Check the location before taking action.',
      'time': 'Sample report',
    },
    {
      'type': 'FIRE',
      'severity': 'MEDIUM',
      'location': 'Sample area, Mirpur',
      'description':
      'Fire report example. Open the details to review the report.',
      'time': 'Sample report',
    },
    {
      'type': 'EARTHQUAKE',
      'severity': 'CRITICAL',
      'location': 'Sample area, Bangladesh',
      'description':
      'Earthquake report example. Follow verified safety guidance.',
      'time': 'Sample report',
    },
  ];

  List<Map<String, String>> get filteredEvents {
    if (selectedFilter == 'All') {
      return sampleEvents;
    }

    return sampleEvents
        .where((event) => event['type'] == selectedFilter)
        .toList();
  }

  Color severityColor(String severity) {
    switch (severity) {
      case 'CRITICAL':
        return const Color(0xFF8E1B25);
      case 'HIGH':
        return AppTheme.primaryRed;
      case 'MEDIUM':
        return const Color(0xFFE58A19);
      default:
        return const Color(0xFF16856B);
    }
  }

  @override
  Widget build(BuildContext context) {
    final events = filteredEvents;

    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.lightBackground,
        elevation: 0,
        title: Row(
          children: [
            const Icon(
              Icons.shield_rounded,
              color: AppTheme.primaryRed,
              size: 30,
            ),
            const SizedBox(width: 8),
            const Text(
              'ResQNet',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications are not connected yet.'),
                ),
              );
            },
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          const Text(
            'Disaster Updates',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Stay informed. Help your community stay safe.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.blueGrey.shade600,
            ),
          ),

          const SizedBox(height: 22),

          // Report action placeholder
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryRed,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notice a disaster?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Help others by reporting an incident.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Report screen is coming next.'),
                      ),
                    );
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.primaryRed,
                  ),
                  icon: const Icon(Icons.add_rounded),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Recent Reports',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // Event type filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                'All',
                'FLOOD',
                'FIRE',
                'EARTHQUAKE',
                'LANDSLIDE',
                'ACCIDENT',
                'STORM',
                'HEATWAVE',
                'OTHER',
              ].map((filter) {
                final isSelected = selectedFilter == filter;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                    selectedColor: AppTheme.primaryRed.withValues(
                      alpha: 0.15,
                    ),
                    checkmarkColor: AppTheme.primaryRed,
                    side: BorderSide(
                      color: isSelected
                          ? AppTheme.primaryRed
                          : Colors.grey.shade300,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          if (events.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text('No sample reports for this filter.'),
              ),
            )
          else
            ...events.map((event) {
              final severity = event['severity']!;

              return Card(
                color: Colors.white,
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: Colors.grey.shade200,
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Event details screen is coming next.',
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryRed.withValues(
                                  alpha: 0.10,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                event['type'] == 'FLOOD'
                                    ? Icons.water_rounded
                                    : event['type'] == 'FIRE'
                                    ? Icons.local_fire_department_rounded
                                    : Icons.warning_amber_rounded,
                                color: AppTheme.primaryRed,
                                size: 25,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event['type']!,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    event['time']!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blueGrey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: severityColor(severity)
                                    .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                severity,
                                style: TextStyle(
                                  color: severityColor(severity),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Text(
                          event['description']!,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 14),

                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 18,
                              color: Colors.blueGrey.shade600,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                event['location']!,
                                style: TextStyle(
                                  color: Colors.blueGrey.shade700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const Text(
                              'Details',
                              style: TextStyle(
                                color: AppTheme.primaryRed,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: AppTheme.primaryRed,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
