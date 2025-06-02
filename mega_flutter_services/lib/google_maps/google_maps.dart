import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'marker.dart';

class MegaMaps extends StatefulWidget {
  final String? style;
  final bool compassEnabled;
  final bool myLocationEnabled;
  final bool myLocationButtonEnabled;
  final List<MegaMarker> markers;
  final String? icon;
  final String? polylines;
  final Stream<LatLng>? stream;

  const MegaMaps({
    this.style,
    this.compassEnabled = true,
    this.myLocationEnabled = true,
    this.myLocationButtonEnabled = true,
    this.markers = const [],
    this.icon,
    this.polylines,
    this.stream,
  });

  @override
  _MegaMapsState createState() => _MegaMapsState();
}

class _MegaMapsState extends State<MegaMaps> {
  GoogleMapController? mapController;
  BitmapDescriptor icon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationBitmapIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor driverBitmapIcon = BitmapDescriptor.defaultMarker;
  final Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  final Set<Marker> _markers = Set<Marker>();

  @override
  void initState() {
    super.initState();
    if (widget.polylines != null) {
      _setPolylines();
    }
    if (widget.stream != null) {
      widget.stream!.listen((data) async {
        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(data.latitude, data.longitude),
              zoom: 15,
            ),
          ),
        );
        BitmapDescriptor.fromAssetImage(
          createLocalImageConfiguration(context, size: const Size(12, 12)),
          'assets/driver_icon.png',
          package: 'mega_flutter_services',
        ).then((value) {
          setState(() {
            _markers.removeWhere(
              (marker) => marker.markerId.value == 'sourcePin',
            );
            _markers.add(Marker(
              zIndex: 3,
              markerId: const MarkerId('sourcePin'),
              position:
                  LatLng(data.latitude, data.longitude), // updated position
              icon: value,
            ));
          });
        });
      });
    }
  }

  Future<void> _setPolylines() async {
    final List<PointLatLng> pathLines =
        polylinePoints.decodePolyline(widget.polylines!);
    if (pathLines.length > 0) {
      await _getLastPolylineCoordinates(pathLines);
      _insertPolylineCoordinate(pathLines);
    }
    setState(() {
      final Polyline polyline = Polyline(
        polylineId: const PolylineId("poly"),
        color: Colors.red,
        points: polylineCoordinates,
        endCap: Cap.roundCap,
        startCap: Cap.roundCap,
        width: 4,
      );

      _polylines.add(polyline);
    });
  }

  Future<void> _getLastPolylineCoordinates(List<PointLatLng> pathLines) async {
    widget.markers.add(
      MegaMarker(
        id: 'destination',
        lat: pathLines.first.latitude,
        lng: pathLines.first.longitude,
      ),
    );
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: LatLng(
            pathLines.first.latitude,
            pathLines.first.longitude,
          ),
        ),
      );
    });
  }

  void _insertPolylineCoordinate(List<PointLatLng> pathLines) {
    for (PointLatLng point in pathLines) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    }
  }

  @override
  Widget build(BuildContext context) {
    final LatLng _center = LatLng(widget.markers[0].lat, widget.markers[0].lng);
    return GoogleMap(
      compassEnabled: widget.compassEnabled,
      onMapCreated: _onMapCreated,
      polylines: _polylines,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 11.0,
      ),
      myLocationEnabled: widget.myLocationEnabled,
      myLocationButtonEnabled: widget.myLocationButtonEnabled,
      markers: _markers,
      gestureRecognizers: Set()
        ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
        ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
        ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
        ..add(
          Factory<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer()),
        ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    if (widget.style != null && widget.style != null) {
      mapController?.setMapStyle(widget.style);
    }

    if (widget.icon != null && widget.icon != null) {
      final config =
          createLocalImageConfiguration(context, size: const Size(12, 12));

      BitmapDescriptor.fromAssetImage(
        config,
        'assets/ic_marker.png',
        package: 'mega_flutter_services',
      ).then(
        (value) {
          setState(() {
            for (var mark in widget.markers) {
              final index = widget.markers.indexOf(mark);
              setState(() {
                _markers.add(
                  Marker(
                    markerId: MarkerId(mark.id),
                    position: LatLng(
                      mark.lat,
                      mark.lng,
                    ),
                    icon: index != 0 ? value : destinationBitmapIcon,
                  ),
                );
              });
            }
          });
        },
      );
      BitmapDescriptor.fromAssetImage(
        config,
        'assets/ic_pin_check.png',
        package: 'mega_flutter_services',
      ).then(
        (value) {
          setState(() {
            setState(() {
              for (var mark in widget.markers) {
                final index = widget.markers.indexOf(mark);
                setState(() {
                  _markers.add(
                    Marker(
                      markerId: MarkerId(mark.id),
                      position: LatLng(
                        mark.lat,
                        mark.lng,
                      ),
                      icon: index != 0 ? icon : value,
                    ),
                  );
                });
              }
            });
          });
        },
      );
    }
  }
}
