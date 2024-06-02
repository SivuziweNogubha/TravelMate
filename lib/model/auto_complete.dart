import 'dart:convert';

import 'package:http/http.dart' as http;


class PlacePrediction {
  final String? description;
  final String? placeId;

  PlacePrediction({this.description, this.placeId});

  factory PlacePrediction.fromJson(Map<String, dynamic> json) =>
      PlacePrediction(
        description: json["description"] as String?,
        placeId: json["place_id"] as String?,
      );
}

class PlaceAutocompleteResponse {
  final String? status;
  final List<PlacePrediction>? predictions;

  PlaceAutocompleteResponse({this.status, this.predictions});

  factory PlaceAutocompleteResponse.fromJson(Map<String, dynamic> json) =>
      PlaceAutocompleteResponse(
        status: json["status"] as String?,
        predictions: json["predictions"] != null
            ? List<PlacePrediction>.from(
          json["predictions"].map((json) => PlacePrediction.fromJson(json)),
        )
            : null,
      );

  static PlaceAutocompleteResponse parseAutocompleteResult(String responseBody) {
    final parsed = json.decode(responseBody).cast<String, dynamic>();
    return PlaceAutocompleteResponse.fromJson(parsed);
  }


  Future<List<PlacePrediction>> fetchPlacePredictions(String input) async {
    final apiKey = 'YOUR_GOOGLE_PLACES_API_KEY';
    final requestUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey';

    final response = await http.get(Uri.parse(requestUrl));

    if (response.statusCode == 200) {
      final result = PlaceAutocompleteResponse.parseAutocompleteResult(response.body);
      return result.predictions ?? [];
    } else {
      throw Exception('Failed to load predictions');
    }
  }

}
