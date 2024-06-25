import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../model/lift.dart';

import 'dart:math' as math;

GoogleMap googleMap(
    Lift lift,
    Set<Marker> markers,
    Set<Polyline> polylines,
    BoxConstraints constraints,
    GoogleMapController? mapController,
    String? mapStyle,
    ) {
  double normalizeLng(double lng) {
    lng = (lng + 180) % 360 - 180;
    return lng == -180 ? 180 : lng;
  }

  double departureLng = normalizeLng(lift.departureLng);
  double destinationLng = normalizeLng(lift.destinationLng);
  //IM ATTEMPTING TO MAKE THE MAP'S ZOOM ALWAYS FIT THE TOP PART OF THE SCREEN
  //ALLOWING THE USER TO SEE THE WAYPOINT BETWEEN THE 2 LOCATIONS
  double minLat = math.min(lift.departureLat, lift.destinationLat);
  double maxLat = math.max(lift.departureLat, lift.destinationLat);


  double lngDiff = (destinationLng - departureLng).abs();
  double minLng, maxLng;
  if (lngDiff > 180) {
    minLng = math.max(departureLng, destinationLng);
    maxLng = math.min(departureLng, destinationLng);
  } else {
    minLng = math.min(departureLng, destinationLng);
    maxLng = math.max(departureLng, destinationLng);
  }


  double latPadding = math.max((maxLat - minLat) * 0.1, 0.1);
  double lngPadding = math.max((maxLng - minLng) * 0.1, 0.1);

  LatLngBounds bounds = LatLngBounds(
    southwest: LatLng(
      math.max(minLat - latPadding, -90),
      normalizeLng(minLng - lngPadding),
    ),
    northeast: LatLng(
      math.min(maxLat + latPadding, 90),
      normalizeLng(maxLng + lngPadding),
    ),
  );

  if (mapController != null) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(
          bounds,
          50.0,
        ),
      );
    });
  }

  return GoogleMap(
    mapType: MapType.normal,
    initialCameraPosition: CameraPosition(
      target: LatLng(lift.departureLat, lift.departureLng),
      zoom: 10.0,
    ),
    onMapCreated: (GoogleMapController controller) {
      mapController = controller;
      controller.setMapStyle(mapStyle);
      controller.animateCamera(
        CameraUpdate.newLatLngBounds(
          bounds,
          50.0,
        ),
      );
    },
    markers: markers,
    polylines: polylines,
    zoomControlsEnabled: false,
    myLocationButtonEnabled: true,
  );
}
