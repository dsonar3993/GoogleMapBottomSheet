import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scooter_app/widgets/widget_text_button.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter/services.dart';
import 'widgets/widget_listview.dart';
import 'widgets/widget_text_button2.dart';

void main() => runApp(SlidingUpPanelExample());
const double CAMERA_ZOOM = 13;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(42.7477863, -71.1699932);
const LatLng DEST_LOCATION = LatLng(42.6871386, -71.2143403);

class SlidingUpPanelExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.grey[200],
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.black,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final double _initFabHeight = 120.0;
  double _fabHeight = 0;
  double _panelHeightOpen = 0;
  double _panelHeightClosed = 100.0;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];

  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPIKey = "AIzaSyAMrDddrMBoAdngziAc2blcxxsri2EPLhM";
  LatLng src, dst;

  @override
  void initState() {
    super.initState();

    _fabHeight = _initFabHeight;
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .60;
    CameraPosition initialLocation = CameraPosition(
        zoom: CAMERA_ZOOM,
        bearing: CAMERA_BEARING,
        tilt: CAMERA_TILT,
        target: SOURCE_LOCATION);
    return Scaffold(
      //body: Container(),
      // GoogleMap(
      //     myLocationEnabled: true,
      //     compassEnabled: true,
      //     tiltGesturesEnabled: false,
      //     markers: _markers,
      //     polylines: _polylines,
      //     mapType: MapType.normal,
      //     onTap: (latlang) {
      //       if (_markers.length >= 2) {
      //         _markers.clear();
      //         setState(() {
      //           _polylines.add(Polyline(
      //               polylineId: PolylineId('route'),
      //               visible: true,
      //               points: polylineCoordinates,
      //               color: Colors.blue,
      //               width: 3));
      //           polylineCoordinates.clear();
      //         });
      //       }
      //       _onAddMarkerButtonPressed(latlang);
      //       if (polylineCoordinates.length == 2) {
      //         showPopup();
      //         //polylineCoordinates.clear();
      //       }
      //     },
      //     initialCameraPosition: initialLocation,
      //     onMapCreated: onMapCreated),
      body: Stack(
        children:[
        SlidingUpPanel(
          maxHeight: _panelHeightOpen,
          minHeight: _panelHeightClosed,
          parallaxEnabled: true,
          parallaxOffset: .5,
          body:GoogleMap(
          myLocationEnabled: false,
          compassEnabled: false,
          tiltGesturesEnabled: false,
          
          markers: _markers,
          polylines: _polylines,
          mapType: MapType.normal,
          onTap: (latlang) {
            if (_markers.length >= 2) {
              _markers.clear();
              setState(() {
                _polylines.add(Polyline(
                    polylineId: PolylineId('route'),
                    visible: true,
                    points: polylineCoordinates,
                    color: Colors.blue,
                    width: 3));
                polylineCoordinates.clear();
              });
            }
            _onAddMarkerButtonPressed(latlang);
            if (polylineCoordinates.length == 2) {
              showPopup();
              //polylineCoordinates.clear();
            }
          },
          initialCameraPosition: initialLocation,
          onMapCreated: onMapCreated),
          //body: _body(),
          panelBuilder: (sc) => _panel(sc),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
          onPanelSlide: (double pos) => setState(() {
            _fabHeight =
                pos * (_panelHeightOpen - _panelHeightClosed) + _initFabHeight;
          }),
        ),
      ]),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: _fabHeight),
        child: FloatingActionButton(
          child: Icon(
            Icons.gps_fixed,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            print('fab pressed');
          },
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _panel(ScrollController sc) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          controller: sc,
          children: <Widget>[
            SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 30,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                ),
              ],
            ),
            SizedBox(
              height: 18.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(8.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          prefixIcon: Icon(Icons.search),
                          hintText: "Search by Address"),
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Scooters Nearby',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: Text(
                'Broklyn Bridge Park',
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
            ),
            WidgetListView(),
          ],
        ));
  }

  void _onAddMarkerButtonPressed(LatLng latlang) {
    setState(() {
      polylineCoordinates.add(latlang);
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(latlang.toString()),
        position: latlang,
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void showPopup() {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              content: Row(
                children: [
                  Image.asset(
                    'assets/images/scooter.png',
                    width: 80,
                    height: 80,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.blue, style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '400m',
                              style:
                                  TextStyle(color: Colors.cyan, fontSize: 12),
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.battery_charging_full_outlined),
                              Text(
                                '40%',
                                style: TextStyle(
                                  color: Colors.cyan,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        width: 120,
                        child: Text(
                          'Jefson E-Kick Air Electric Scooter',
                          maxLines: 3,
                          overflow: TextOverflow.visible,
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            WidgetTextButton(),
                            WidgetTextButtonActivate()
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ));
  }

  void onMapCreated(GoogleMapController controller) {
    //controller.setMapStyle(MapType.normal.toString());
    _controller.complete(controller);
    //setMapPins();
    setPolylines();
  }

  void setMapPins() {
    setState(() {
      // source pin
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: SOURCE_LOCATION,
          icon: BitmapDescriptor.defaultMarker));
      // destination pin
      _markers.add(Marker(
          markerId: MarkerId('destPin'),
          position: DEST_LOCATION,
          icon: BitmapDescriptor.defaultMarker));
    });
  }

  setPolylines() {
    if (polylineCoordinates.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      polylineCoordinates.forEach((LatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    setState(() {
      Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          color: Colors.black,
          width: 3,
          points: polylineCoordinates);
      _polylines.add(polyline);
    });
  }
}
