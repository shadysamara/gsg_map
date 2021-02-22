import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gsg_maps/constants.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(home: MapPage(),);
  }
}
class MapPage extends StatefulWidget{
  @override
  _MapPageState createState() => _MapPageState();
}



class _MapPageState extends State<MapPage> {
 
  PolylinePoints polylinePoints = PolylinePoints();
  LatLng myLocation;
  LatLng otherLocation;
    Set<Marker> markers={};
    Set<Polyline> polyLines = {};
    List<LatLng> polyLinesCordinates = [];
    



  Future<Position> _determinePosition() async {
  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  myLocation = LatLng(position.latitude,position.longitude);
 
  setMarkers(myLocation,'myLocation');        
        
  mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude ,position.longitude),zoom: 10)));
  
  return position;
}



  GoogleMapController mapController;
  CameraPosition cameraPosition = CameraPosition(target: LatLng(6.5212402 ,3.3679965),zoom: 10);
  setMapController(GoogleMapController googleMapController){
    mapController = googleMapController;
    _determinePosition();
 
  }
  setMarkers(LatLng position,String id){
    markers.add(Marker(markerId: MarkerId(id),position: LatLng(position.latitude, position.longitude)),);
  
    setState(() {
      
    });
  }
  setPolyLines(LatLng destination) async{
    ///step 2 : find all points between origin and destination
PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(apiKey,
PointLatLng(myLocation.latitude, myLocation.longitude),PointLatLng(destination.latitude, destination.longitude));
List<PointLatLng> points = result.points;
List<LatLng> pointsList =  points.map((e) => LatLng(e.latitude,e.longitude)).toList();
////////////////////////////////////////
///step 3: draw route between points
Polyline polyline = Polyline(polylineId: PolylineId('poly'),points: pointsList);
polyLines.add(polyline);
setState(() {
  
});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: GoogleMap(
        onTap: (destination){
          setMarkers(destination, 'destination');
          setPolyLines(destination);
        },
        markers: markers,
        polylines: polyLines,
     
    
        mapType: MapType.normal,
        initialCameraPosition: cameraPosition,
        onMapCreated: setMapController,
      ),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.zoom_in),
      onPressed: (){
       _determinePosition();
      },
      ),
    );
  }
}