import 'package:flutter/material.dart';
import 'package:internet_folks/Models/conferences_model.dart';
import 'package:internet_folks/Providers/conferences_provider.dart';
import 'package:provider/provider.dart';

import 'events_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Search',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(
                  Icons.search_sharp,
                  size: 30,
                  color: Color.fromARGB(255, 72, 33, 243),
                ),
                const SizedBox(width: 4),
                const Text(
                  '|',
                  style: TextStyle(
                      color: Color.fromARGB(
                        255,
                        72,
                        33,
                        243,
                      ),
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      Provider.of<EventProvider>(context, listen: false)
                          .searchEvents(context, value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Type Event Name',
                      border: InputBorder.none, // Remove the outline border
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildEventList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildEventList(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, eventProvider, _) {
        List<Data> eventsToShow = eventProvider.searchedEvents.isNotEmpty
            ? eventProvider.searchedEvents
            : eventProvider.event;

        if (eventsToShow.isEmpty && _searchController.text.isNotEmpty) {
          return const Center(
            child: Text('No matching events found'),
          );
        } else if (eventsToShow.isEmpty && _searchController.text.isEmpty) {
          return const Center(
            child: Text('No events available'),
          );
        } else {
          return ListView.builder(
            itemCount: eventsToShow.length,
            itemBuilder: (context, index) {
              Data event = eventsToShow[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EventDetails(eventId: event.id!.toInt()))),
                child: ListTile(
                  leading: Image.network(
                    event.bannerImage!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.fill,
                  ),
                  title: Text(
                    '${_getFormattedDateTime(event.dateTime!)}',
                    style: const TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 2),
                      Text(
                        event.title!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 17,
                          ),
                          const SizedBox(
                              width: 1), // Adjust spacing between icon and text
                          Expanded(
                            child: Text(
                              '${event.venueName}, ${event.venueCity}, ${event.venueCountry}',
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  String _getFormattedDateTime(String dateTime) {
    DateTime parsedDateTime = DateTime.parse(dateTime);
    String dayOfWeek = _getDayOfWeek(parsedDateTime.weekday);
    String month = _getMonthName(parsedDateTime.month);
    int day = parsedDateTime.day;
    int hour = parsedDateTime.hour;
    String period = hour < 12 ? 'AM' : 'PM';

    // Convert to 12-hour format
    if (hour > 12) {
      hour -= 12;
    } else if (hour == 0) {
      hour = 12;
    }

    return '$dayOfWeek, ${month} $day · ${hour}:${parsedDateTime.minute.toString().padLeft(2, '0')} $period';
  }

  String _getDayOfWeek(int day) {
    switch (day) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }

  String _getMonthName(int month) {
    return [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ][month];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
