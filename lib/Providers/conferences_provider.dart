import 'package:flutter/material.dart';
import 'package:internet_folks/Controllers/conferences_controller.dart';
import 'package:internet_folks/Models/conferences_model.dart';

class EventProvider with ChangeNotifier {
  List<Data> event = [];
  List<Data> searchedEvents = [];
  Data? singleEvent;

  Future<void> fetchEvents(BuildContext context) async {
    try {
      List<Data> events = await ConferenceController.fetchAllEvents(context);

      event = events;
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> fetchSingleEvent(BuildContext context, int id) async {
    try {
      Data events = await ConferenceController.fetchSingleEvent(context, id);

      singleEvent = events;
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> searchEvents(BuildContext context, String request) async {
    try {
      List<Data> events =
          await ConferenceController.searchEvents(context, request);

      searchedEvents = events;
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
