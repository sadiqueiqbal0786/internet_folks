import 'package:flutter/material.dart';
import 'package:internet_folks/Models/conferences_model.dart';
import 'package:internet_folks/Providers/conferences_provider.dart';
import 'package:internet_folks/Screens/events_screen.dart';
import 'package:internet_folks/Screens/search_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<EventProvider>(context, listen: false).fetchEvents(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Events',
          style: TextStyle(color: Colors.black, letterSpacing: 2),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SearchScreen()));
            },
          ),
          PopupMenuButton(
            color: Colors.black,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text('Menu Item 1'),
                  value: 'item1',
                ),
                PopupMenuItem(
                  child: Text('Menu Item 2'),
                  value: 'item2',
                ),
              ];
            },
            onSelected: (value) {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Consumer<EventProvider>(
          builder: (context, eventProvider, _) {
            if (eventProvider.event.isEmpty) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return LayoutBuilder(
                builder: (context, constraints) {
                  final screenWidth = constraints.maxWidth;

                  return ListView.builder(
                    itemCount: eventProvider.event.length,
                    itemBuilder: (context, index) {
                      Data event = eventProvider.event[index];
                      return GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EventDetails(
                                      eventId: event.id!.toInt()))),
                          //if i want i can pass event directly to fetch events details , but i
                          //just passing the id through constructor to use of your api's.
                          child: _buildListItem(event, screenWidth));
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildListItem(Data event, double screenWidth) {
    return ListTile(
      key: Key(event.id.toString()),
      leading: Image.network(
        event.bannerImage!,
        width: 50,
        height: 50,
        fit: BoxFit.fill,
      ),
      title: Text(
        '${_getFormattedDateTime(event.dateTime!)}',
        style: const TextStyle(
            color: Colors.deepPurple, fontWeight: FontWeight.normal),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 2,
          ),
          Text(
            event.title!,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on,
                size: 17,
              ),
              const SizedBox(width: 1), // Adjust spacing between icon and text
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
}
