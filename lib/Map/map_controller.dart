import 'package:delivery_app/Map/Map_screen/map_screen.dart';
import 'package:delivery_app/Map/map_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class mapcontroller extends Cubit<mapstates> {
  mapcontroller() : super(initaialmapstates()) {
    currantposition();
  }

  LatLng _latLng = LatLng(30.033333, 31.233334);
  LatLng get latLng => _latLng;
  Placemark _placemark = Placemark();
  Placemark get placemark => _placemark;
  Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;
  List<LatLng> _polylineCoordinates = [];
  List<LatLng> get polylineCoordinates => _polylineCoordinates;
  Map<PolylineId, Polyline> _polylines = {};
  Map<PolylineId, Polyline> get polylines => _polylines;

  Future<void> currantposition() async {
    emit(getmaploadingstates());
    try {
      bool isDone = await _Mapstatus();

      if (isDone) {
        Position currant = await Geolocator.getCurrentPosition();
        _latLng = LatLng(currant.latitude, currant.longitude);
        emit(getmapsuccesstates());
      } else {
        emit(getmapErrorstates());
      }
    } catch (e) {
      emit(getmapErrorstates());
    }
  }

  Future<bool> _Mapstatus() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) return false;

    bool service = await Geolocator.isLocationServiceEnabled();
    if (!service) return false;

    return true;
  }

  Future<void> diractions(double latitude, double longitude) async {
    emit(getdiractionloadingstates());
    try {
      bool isDone = await _Mapstatus();
      if (isDone) {
        PolylineResult result =
            await PolylinePoints().getRouteBetweenCoordinates(
          googleApiKey: 'AIzaSyBJ5IEEFFpMGJXVD0Fc_jNxeqkJQTCxmSE',
          request: PolylineRequest(
              origin: PointLatLng(_latLng.latitude, _latLng.longitude),
              destination: PointLatLng(latitude, longitude),
              mode: TravelMode.driving),
        );
        if (result.points.isNotEmpty) {
          result.points.forEach((PointLatLng point) {
            _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          });
        } else {
          print(result.errorMessage);
        }
        PolylineId id = PolylineId('poly');
        Polyline polyline = Polyline(
          polylineId: id,
          color: Colors.red,
          points: _polylineCoordinates,
          width: 3,
        );
        _polylines[id] = polyline;
        emit(getdiractionsuccesstates());
      } else {
        emit(getdiractionErrorstates());
      }
    } catch (e) {
      emit(getdiractionErrorstates());
    }
  }

  Future<void> marker(double latitude, double longitude, String address,
      GoogleMapController _controller) async {
    _markers.clear();
    try {
      if (!customlocation) {
        _latLng = LatLng(latitude, longitude);
        _markers.add(Marker(
            infoWindow: InfoWindow(title: 'Client'),
            markerId: MarkerId(_latLng.hashCode.toString()),
            position: LatLng(latitude, longitude)));
      } else {
        List<Location> addreess = await locationFromAddress(address);
        _latLng = LatLng(addreess[0].latitude, addreess[0].longitude);
        _markers.add(Marker(
            infoWindow: InfoWindow(title: 'Client'),
            markerId: MarkerId(addreess[0].timestamp.toString()),
            position: LatLng(addreess[0].latitude, addreess[0].longitude)));
      }
      await _controller.animateCamera(CameraUpdate.newLatLngZoom(_latLng, 12));
      emit(getdiractionsuccesstates());
    } catch (e) {
      emit(getdiractionErrorstates());
    }
  }
}
