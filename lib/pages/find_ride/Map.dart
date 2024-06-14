import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../model/lift.dart';

GoogleMap googleMap(



    Lift lift,
    Set<Marker> markers,
    Set<Polyline> polylines,
    BoxConstraints constraints,
    ) {
  LatLng minLatLng(double lat1, double lng1, double lat2, double lng2) {
    return LatLng(
      lat1 < lat2 ? lat1 : lat2,
      lng1 < lng2 ? lng1 : lng2,
    );
  }

  LatLng maxLatLng(double lat1, double lng1, double lat2, double lng2) {
    return LatLng(
      lat1 > lat2 ? lat1 : lat2,
      lng1 > lng2 ? lng1 : lng2,
    );
  }

  LatLngBounds bounds = LatLngBounds(
    southwest: minLatLng(
      lift.departureLat,
      lift.departureLng,
      lift.destinationLat,
      lift.destinationLng,
    ),
    northeast: maxLatLng(
      lift.departureLat,
      lift.departureLng,
      lift.destinationLat,
      lift.destinationLng,
    ),
  );

  LatLng center = LatLng(
    bounds.southwest.latitude + (bounds.northeast.latitude - bounds.southwest.latitude) / 2,
    bounds.southwest.longitude + (bounds.northeast.longitude - bounds.southwest.longitude) / 2,
  );

  double zoomLevel = 5.4;
  if (constraints.maxHeight > 500) {
    zoomLevel = 11.0;
  } else if (constraints.maxHeight > 300) {
    zoomLevel =5.0;
  }

  return GoogleMap(
    cloudMapId: dotenv.get("ANDROID_FIREBASE_API_KEY"),
    zoomControlsEnabled: false,
    myLocationButtonEnabled: false,
    initialCameraPosition: CameraPosition(
      target: center,
      zoom: zoomLevel,
    ),
    markers: markers,
    polylines: polylines,
  );
}
