import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internet_folks/Models/conferences_model.dart';
import 'package:internet_folks/Services/base_url.dart';

class ConferenceController {
  static Future<List<Data>> fetchAllEvents(BuildContext context) async {
    try {
      Dio dio = Dio();
      final response = await dio.get('${BaseUrl.url}/v1/event');
      if (response.statusCode == 200) {
        List<Data> events = List<Data>.from(
          response.data['content']['data'].map((x) => Data.fromJson(x)),
        );

        return events;
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to fetch event')));
        throw Exception('Failed to fetch events');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Please check your internet connection and try again')));
      throw Exception(e.toString());
    }
  }

  static Future<Data> fetchSingleEvent(BuildContext context, int id) async {
    try {
      Dio dio = Dio();
      final response = await dio.get('${BaseUrl.url}/v1/event/$id');
      if (response.statusCode == 200) {
        final responseData = response.data['content']['data'];
        Data event = Data.fromJson(
            responseData); // Parse single event from response data
        return event;
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to fetch event')));
        throw Exception('Failed to fetch events');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Please check your internet connection and try again')));
      throw Exception(e.toString());
    }
  }

  static Future<List<Data>> searchEvents(
      BuildContext context, String request) async {
    try {
      Dio dio = Dio();
      final response = await dio.get('${BaseUrl.url}/v1/event?search=$request');
      if (response.statusCode == 200) {
        List<Data> events = List<Data>.from(
          response.data['content']['data'].map((x) => Data.fromJson(x)),
        );

        return events;
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to fetch event')));
        throw Exception('Failed to fetch events');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Please check your internet connection and try again')));
      throw Exception(e.toString());
    }
  }
}
