import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_webservice/directions.dart' as DirectionsService;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart' as directions;
import 'package:flutter/services.dart' show rootBundle;
import 'package:lifts_app/utils/important_constants.dart';
import '../../main.dart';
import '../../model/lift.dart';
import '../../repository/lifts_repository.dart';
import '../../repository/wallet_repo.dart';
import 'Map.dart';

class ConfirmRidePage extends StatefulWidget {
  final LatLng departureLocation;
  final LatLng destinationLocation;
  final String offeredBy;
  final String offeredByName;
  final String offeredByPhotoUrl;
  final String destination;
  final String departure;
  final String image;
  final int seat;
  final String liftId;
  final double price;

  ConfirmRidePage({
    required this.departureLocation,
    required this.destinationLocation,
    required this.offeredBy,
    required this.offeredByName,
    required this.offeredByPhotoUrl,
    required this.destination,
    required this.departure,
    required this.price,
    required this.liftId,
    required this.image,
    required this.seat,
  });

  @override
  _ConfirmRidePageState createState() => _ConfirmRidePageState();
}

class _ConfirmRidePageState extends State<ConfirmRidePage> {
  late DirectionsService.GoogleMapsDirections _directions;
  List<LatLng> _routeCoordinates = [];
   GoogleMapController? mapController;

  String mapTheme = '';

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
    _directions = DirectionsService.GoogleMapsDirections(apiKey: dotenv.get("GOOGLE_CLOUD_MAP_ID"));
    _getRoute();


  }


  Future<void> _loadMapStyle() async {
    String style = await rootBundle.loadString('assets/mapTheme/dark.json');
    setState(() {
      mapTheme = style;
    });
  }

  Future<void> _getRoute() async {
    try {
      directions.DirectionsResponse? response = await _directions.directionsWithLocation(
        directions.Location(
          lat: widget.departureLocation.latitude,
          lng: widget.departureLocation.longitude,
        ),
        directions.Location(
          lat: widget.destinationLocation.latitude,
          lng: widget.destinationLocation.longitude,
        ),
        travelMode: directions.TravelMode.driving,
      );

      if (response?.isOkay ?? false) {
        List<LatLng> points = [];
        for (var route in response!.routes) {
          for (var leg in route.legs) {
            for (var step in leg.steps) {
              String encodedPoints = step.polyline.points;
              List<LatLng> decodedPoints = decodeEncodedPolyline(encodedPoints);
              points.addAll(decodedPoints);
            }
          }
        }

        print('Decoded Points: $points');

        if (points.isNotEmpty) {
          setState(() {
            _routeCoordinates = points;
          });
        } else {
          print('No route found');
        }
      } else {
        print('DirectionsResponse is not OK');
      }
    } catch (e) {
      print('Error fetching route: $e');
    }
  }

  List<LatLng> decodeEncodedPolyline(String encoded) {
    List<LatLng> decoded = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      double latDouble = lat / 1E5;
      double lngDouble = lng / 1E5;
      LatLng point = LatLng(latDouble, lngDouble);
      decoded.add(point);
    }

    return decoded;
  }

  Material confirmride(String liftId, BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blue, // Adjust color as needed
      child: MaterialButton(
        onPressed: () async {
          // Join lift logic
        },
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        child: Text(
          "Join Ride",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        textColor: Colors.white,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    double midLatitude = (widget.departureLocation.latitude + widget.destinationLocation.latitude) / 2;
    double midLongitude = (widget.departureLocation.longitude + widget.destinationLocation.longitude) / 2;
    double adjustedMidLatitude = midLatitude + 0.0050;

    LatLngBounds boundsFromCoordinates = LatLngBounds(
      southwest: LatLng(
        widget.departureLocation.latitude,
        widget.departureLocation.longitude,
      ),
      northeast: LatLng(
        widget.destinationLocation.latitude,
        widget.destinationLocation.longitude,
      ),
    );


    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(
      boundsFromCoordinates,
      100.0,
    );

    final WalletRepository _walletRepository = WalletRepository();
    final LiftsRepository _liftsRepository = LiftsRepository();
    late DirectionsService.GoogleMapsDirections _directions;



    // @override
    // void initState() {
    //   super.initState();
    //   _directions = DirectionsService.GoogleMapsDirections(apiKey: dotenv.get("ANDROID_FIREBASE_API_KEY"));
    // }


    Future<BitmapDescriptor> customMarkerIcon(String label) async {
      final PictureRecorder pictureRecorder = PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);

      // Define the paint for the rectangular box
      final Paint boxPaint = Paint()..color = Colors.black;

      // Define the text painter to measure and draw the label text
      TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
      );
      textPainter.text = TextSpan(
        text: label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 35.0,
        ),
      );
      textPainter.layout();

      // Calculate the width and height based on the text
      final double textWidth = textPainter.width;
      final double textHeight = textPainter.height;
      final double padding = 20.0;
      final double width = textWidth + padding * 2;
      final double height = textHeight + padding;

      // Draw the rectangular box with dynamic size
      final Rect boxRect = Rect.fromLTRB(0, 0, width, height);
      canvas.drawRect(boxRect, boxPaint);

      // Draw the label text in the center of the box
      final double textOffsetX = padding;
      final double textOffsetY = (height - textHeight) / 2;
      textPainter.paint(canvas, Offset(textOffsetX, textOffsetY));

      final img = await pictureRecorder.endRecording().toImage(width.toInt(), height.toInt());
      final data = await img.toByteData(format: ImageByteFormat.png);

      return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
    }



    Future<List<BitmapDescriptor>> getCustomMarkerIcons() async {
      final departureIcon = customMarkerIcon(widget.departure);
      final destinationIcon = customMarkerIcon(widget.destination);

      return Future.wait([departureIcon, destinationIcon]);
    }



    Material confirmride(String liftId,BuildContext context){
      return Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(30),
        color: primary,
        child: MaterialButton(
          onPressed: () async {
            String mylift = liftId;
            String userId = FirebaseAuth.instance.currentUser!.uid;
            await _liftsRepository.joinLift(context, mylift, userId,_walletRepository);
          },
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/passenger.png', // Replace with your icon path
                width: 24,
                height: 24,
                color: Colors.white, // Optional: apply color to the icon
              ),
              SizedBox(width: 8), // Space between the icon and text
              Text(
                "Join Ride",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          textColor: Colors.white,
        ),
      );
    }



    Lift lift = Lift(
      liftId: widget.liftId,
      offeredBy: widget.offeredBy,
      departureLocation: widget.departure,
      departureLat: widget.departureLocation.latitude,
      departureLng: widget.departureLocation.longitude,
      destinationLocation: widget.destination,
      destinationLat: widget.destinationLocation.latitude,
      destinationLng: widget.destinationLocation.longitude,
      departureDateTime: DateTime.now(),
      availableSeats: widget.seat,
      destinationImage: widget.image,
      status: 'confirmed',
      price: widget.price,
    );


    Set<Polyline> polylines = {};

    Polyline polyline = Polyline(
      polylineId: PolylineId('route'),
      points: _routeCoordinates,
      color: Colors.blue,
      width: 4,
    );

    polylines.add(polyline);



    return Scaffold(
      body: LayoutBuilder(
        builder: (context,constraints) {
          return FutureBuilder<List<BitmapDescriptor>>(
        future: getCustomMarkerIcons(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("this is the current theme selected:"+""+mapTheme);
            return Stack(
              children: [
                googleMap(
                  lift,
                  {
                    Marker(
                      markerId: MarkerId('departure'),
                      position: widget.departureLocation,
                      icon: snapshot.data![0],
                    ),
                    Marker(
                      markerId: MarkerId('destination'),
                      position: widget.destinationLocation,
                      icon: snapshot.data![1],
                    ),
                  },
                  polylines,
                  constraints,
                  mapController,
                  mapTheme,
                ),
                Positioned(
                  top: 25.0,
                  left: 16.0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        // Greyish background color with opacity
                        shape: BoxShape
                            .rectangle, // Shape of the container (circular in this case)
                      ),
                      padding: EdgeInsets.all(8.0),
                      child: ImageIcon(
                        AssetImage('assets/back.png'),
                        color: Colors.white, // Color of the icon (white)
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.25,
                    minChildSize: 0.25,
                    maxChildSize: 0.5,
                    builder: (context, scrollController) {
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0),
                          ),
                        ),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      // Adjust the radius as needed for the desired size
                                      backgroundColor: Colors.grey[300],
                                      // Optional background color for the avatar
                                      backgroundImage: NetworkImage(
                                        widget.offeredByPhotoUrl,
                                      ),
                                      child: ClipOval(
                                        child: Image.network(
                                          widget.offeredByPhotoUrl,
                                          fit: BoxFit
                                              .contain, // Ensure the image fits perfectly within the CircleAvatar
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Text(
                                          widget.offeredByName,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.none,
                                            fontFamily: 'Aeonik',
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 1),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4)),
                                            color: Colors.green,
                                          ),
                                          child: const Text(
                                            "Available",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              decoration: TextDecoration.none,
                                              fontFamily: 'Aeonik',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "Trip Route",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none,
                                    fontFamily: 'Aeonik',
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(
                                        Icons.location_on, color: Colors.blue),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        widget.departure,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.none,
                                          fontFamily: 'Aeonik',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                        Icons.location_on, color: Colors.red),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        widget.destination,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.none,
                                          fontFamily: 'Aeonik',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Price: \R${widget.price.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none,
                                    fontFamily: 'Aeonik',
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Available Seats: $widget.seat",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none,
                                    fontFamily: 'Aeonik',
                                  ),
                                ),
                                const SizedBox(height: 16),
                                confirmride(widget.liftId, context),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }       else {
            return Center(child: CircularProgressIndicator());
          }
        }

    );
        }

      ),
    );
  }
}
