import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/conferences_provider.dart';

class EventDetails extends StatefulWidget {
  final int eventId;
  const EventDetails({Key? key, required this.eventId}) : super(key: key);

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  @override
  void initState() {
    Provider.of<EventProvider>(context, listen: false)
        .fetchSingleEvent(context, widget.eventId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Event Details'),
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              background: Consumer<EventProvider>(
                builder: (context, eventProvider, _) {
                  if (eventProvider.singleEvent != null &&
                      eventProvider.singleEvent!.bannerImage != null) {
                    return Image.network(
                      eventProvider.singleEvent!.bannerImage!,
                      fit: BoxFit.fill,
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            actions: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurple[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(1),
                child: IconButton(
                  icon: Icon(
                    Icons.favorite,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<EventProvider>(
                builder: (context, eventProvider, _) {
                  if (eventProvider.singleEvent != null) {
                    final singleEvent = eventProvider.singleEvent!;
                    final DateTime eventDateTime =
                        DateTime.parse(singleEvent.dateTime ?? '');
                    final String formattedDate =
                        '${_getFormattedDate(eventDateTime)}';
                    final String formattedDateTime =
                        '${_getFormattedDateTime(eventDateTime)}';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          singleEvent.title ?? '',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Image.network(
                              singleEvent.organiserIcon ?? '',
                              width: 30,
                              height: 30,
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  singleEvent.organiserName ?? '',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'Organizer',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.deepPurple[50],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.calendar_month_outlined,
                                color: Color.fromARGB(255, 26, 23, 187),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  formattedDate,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  formattedDateTime,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.deepPurple[50],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.location_on,
                                color: Color.fromARGB(255, 26, 23, 187),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${singleEvent.venueName ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${singleEvent.venueCity ?? ''}, ${singleEvent.venueCountry ?? ''}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'About Event',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(singleEvent.description ?? ''),
                        const Spacer(),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle book now action
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('BOOK NOW'),
                                SizedBox(
                                    width:
                                        100), // Adding space between text and icon
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(255, 36, 21,
                                        172), // Background color for the circular icon
                                  ),
                                  padding: EdgeInsets.all(
                                      6), // Adjust padding as needed
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color:
                                        Colors.white, // Color of the arrow icon
                                    size: 20, // Size of the arrow icon
                                  ),
                                ),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 94, 84,
                                  182), // Background color of the button
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox(); // Handle when event is not available
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getFormattedDate(DateTime dateTime) {
    return '${dateTime.day} ${_getMonthName(dateTime.month)} ${dateTime.year}';
  }

  String _getFormattedDateTime(DateTime dateTime) {
    int hour = dateTime.hour;
    String period = hour < 12 ? 'AM' : 'PM';

    // Convert to 12-hour format
    if (hour > 12) {
      hour -= 12;
    } else if (hour == 0) {
      hour = 12;
    }

    return '${_getDayOfWeek(dateTime.weekday)}, ${hour}:${dateTime.minute.toString().padLeft(2, '0')} $period';
  }

  String _getMonthName(int month) {
    return [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ][month];
  }

  String _getDayOfWeek(int day) {
    switch (day) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return '';
    }
  }
}
