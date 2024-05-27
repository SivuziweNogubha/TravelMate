import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:lifts_app/model/destination.dart';// Import your PlacePrediction model
import 'package:lifts_app/model/auto_predict.dart'; // Import your PlaceAutocompleteResponse model

class LocationSearchField extends StatefulWidget {
  @override
  _LocationSearchFieldState createState() => _LocationSearchFieldState();
}

class _LocationSearchFieldState extends State<LocationSearchField> {
  final TextEditingController _controller = TextEditingController();
  List<PlacePrediction> _predictions = [];
  bool _isLoading = false;

  void _onSearchChanged() {
    if (_controller.text.isNotEmpty) {
      _fetchPredictions(_controller.text);
    } else {
      setState(() {
        _predictions = [];
      });
    }
  }

  Future<void> _fetchPredictions(String input) async {
    final String apiKey = 'YOUR_GOOGLE_PLACES_API_KEY';
    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey';

    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final PlaceAutocompleteResponse autocompleteResponse =
      PlaceAutocompleteResponse.parseAutocompleteResult(response.body);

      setState(() {
        _predictions = autocompleteResponse.predictions ?? [];
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          onChanged: (value) => _onSearchChanged(),
          decoration: InputDecoration(
            hintText: 'Search for a location',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        _isLoading
            ? CircularProgressIndicator()
            : Expanded(
          child: ListView.builder(
            itemCount: _predictions.length,
            itemBuilder: (context, index) {
              final prediction = _predictions[index];
              return ListTile(
                title: Text(prediction.description),
                onTap: () {
                  // Handle the selection
                  print('Selected: ${prediction.description}');
                  _controller.text = prediction.description;
                  setState(() {
                    _predictions = [];
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
