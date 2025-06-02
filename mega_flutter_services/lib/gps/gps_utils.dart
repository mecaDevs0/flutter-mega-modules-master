import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as Geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:megaleios_flutter_localization/megaleios_flutter_localization.dart';

import 'failures/gps_exception.dart';
import 'models/gps_placemark.dart';

abstract class MegaGPSLocationUtils {
  static Future<void> requestPermission() async {
    await Geolocator.requestPermission();
  }

  static Future<bool> isGPSEnabled() async {
    final permission = await Geolocator.requestPermission();

    return permission != LocationPermission.denied &&
        permission != LocationPermission.deniedForever &&
        await Geolocator.isLocationServiceEnabled();
  }

  ///[0] - Latitude
  ///[1] - Longitude
  static Future<List<double>> getCurrentLocation(BuildContext context) async {
    final completer = new Completer<List<double>>();

    try {
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true,
      );
      completer.complete([position.latitude, position.longitude]);
    } on TimeoutException catch (_) {
      throw GPSException(
          MegaleiosLocalizations.of(context)!.translate('gps_timeout'));
    } on PermissionDeniedException catch (_) {
      throw GPSException(
          MegaleiosLocalizations.of(context)!.translate('gps_denied'));
    } on LocationServiceDisabledException catch (_) {
      throw GPSException(
          MegaleiosLocalizations.of(context)!.translate('gps_disabled'));
    }
    return completer.future;
  }

  ///[0] - Latitude
  ///[1] - Longitude
  static Future<List<double>> getLastKnownPosition(BuildContext context) async {
    try {
      final Position? position = await Geolocator.getLastKnownPosition();

      return [position!.latitude, position.longitude];
    } on TimeoutException catch (_) {
      throw GPSException(
          MegaleiosLocalizations.of(context)!.translate('gps_timeout'));
    } on PermissionDeniedException catch (_) {
      throw GPSException(
          MegaleiosLocalizations.of(context)!.translate('gps_denied'));
    } on LocationServiceDisabledException catch (_) {
      throw GPSException(
          MegaleiosLocalizations.of(context)!.translate('gps_disabled'));
    }
  }

  ///[0] - Latitude
  ///[1] - Longitude
  static Future<List<double>> getAnyLocation(BuildContext context) async {
    try {
      final Position? position = await Geolocator.getLastKnownPosition();

      if (position == null) {
        return await getCurrentLocation(context);
      }

      return [position.latitude, position.longitude];
    } on TimeoutException catch (_) {
      throw GPSException(
          MegaleiosLocalizations.of(context)!.translate('gps_timeout'));
    } on PermissionDeniedException catch (_) {
      throw GPSException(
          MegaleiosLocalizations.of(context)!.translate('gps_denied'));
    } on LocationServiceDisabledException catch (_) {
      throw GPSException(
          MegaleiosLocalizations.of(context)!.translate('gps_disabled'));
    } on GPSException catch (e) {
      throw e;
    }
  }

  static Future<List<GPSPlacemark>> getLocationAddress(
    BuildContext context, {
    required double latitude,
    required double longitude,
  }) async {
    final listCoded = await Geocoding.placemarkFromCoordinates(
      latitude,
      longitude,
      localeIdentifier:
          MegaleiosLocalizations.of(context)!.locale.toLanguageTag(),
    );

    return listCoded.map((geocoded) {
      return GPSPlacemark(
        name: geocoded.name,
        street: geocoded.street,
        isoCountryCode: geocoded.isoCountryCode,
        country: geocoded.country,
        postalCode: geocoded.postalCode,
        administrativeArea: geocoded.administrativeArea,
        subAdministrativeArea: geocoded.subAdministrativeArea,
        locality: geocoded.locality,
        subLocality: geocoded.subLocality,
        thoroughfare: geocoded.thoroughfare,
        subThoroughfare: geocoded.subThoroughfare,
      );
    }).toList();
  }

  static Future<List<GPSPlacemark>> getCurrentLocationAddress(
      BuildContext context) async {
    final position = await getCurrentLocation(context);

    return await getLocationAddress(
      context,
      latitude: position.first,
      longitude: position.last,
    );
  }
}
