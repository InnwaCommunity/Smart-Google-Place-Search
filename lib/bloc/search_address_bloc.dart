import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:customize_google_place_api/entity/suggestion.dart';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';

class SearchPlaceListsBloc {
  final _suggestionsController = StreamController<List<Suggestion>>.broadcast();
  final client = Client();
  List<Suggestion> suggestionList = [];

  static const String androidKey = 'AIzaSyAlYB_wKYN_9Q2ccagNdjEXTV3cwpLw7PY';
  static const String iosKey = 'YOUR_API_KEY_HERE';
  final latitude = 16.884475338128066;
  final longitude = 96.1212358214915;
  final radius = 500;
  final apiKey = Platform.isAndroid ? androidKey : iosKey;

  Stream<List<Suggestion>> get suggestionsStream =>
      _suggestionsController.stream;

  void updateSuggestions(String query) async {
    List<Suggestion> suggestions = await _fetchSuggestionsFromAPI(query);

    _suggestionsController.add(suggestions);
  }

  void resetSuggestions() async {
    List<Suggestion> suggestions = [];
    _suggestionsController.add(suggestions);
  }

  Future<List<Suggestion>> _fetchSuggestionsFromAPI(String query) async {
    List<Suggestion> response = await fetchSuggestions(input: query);
    // List<Suggestion> response =
    //     await API().getDriverListByTaxigroupAdmin(req: query);
    // return response;
    return response;
  }

  Future<List<Suggestion>> fetchSuggestions({required String input}) async {
    final sessionToken = const Uuid().v4();
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input'
        '&types=establishment'
        '&language=en'
        '&components=country:mm'
        '&location=$latitude,$longitude'
        '&radius=$radius'
        '&components=locality:yangon'
        '&key=$apiKey'
        '&sessiontoken=$sessionToken';
    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        try {
          suggestionList = result['predictions']
              .map<Suggestion>(
                  (p) => Suggestion(p['place_id'], p['description']))
              .toList();
          return suggestionList;
        } catch (e) {
          print(e.toString());
        }
      } else {
        return [];
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
    } else {
      return [];
    }
    return [];
  }

  Future<void> getPlaceDetailFromId(String placeId) async {
    final sessionToken = const Uuid().v4();
    final request =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey&sessiontoken=$sessionToken';
    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        final components =
            result['result']['geometry']['location'] as Map<String, dynamic>;
        // build result
        print("components >> $components");
        // final place = Place();
        // components.forEach((c) {
        //   final List type = c['types'];
        //   if (type.contains('street_number')) {
        //     place.streetNumber = c['long_name'];
        //   }
        //   if (type.contains('route')) {
        //     place.street = c['long_name'];
        //   }
        //   if (type.contains('locality')) {
        //     place.city = c['long_name'];
        //   }
        //   if (type.contains('postal_code')) {
        //     place.zipCode = c['long_name'];
        //   }
        // });
        // return place;
      }
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  void dispose() {
    _suggestionsController.close();
  }
}
