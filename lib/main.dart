import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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



  Future<Position> _determinePosition() async {
  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    markers.add(Marker(markerId: MarkerId('$LatLng'),position: LatLng(position.latitude ,position.longitude),));
          setState(() {
            
          });
  mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude ,position.longitude),zoom: 10)));
  
  return position;
}



  GoogleMapController mapController;
  CameraPosition cameraPosition = CameraPosition(target: LatLng(31.5 ,34.46667),zoom: 2);
  setMapController(GoogleMapController googleMapController){
    mapController = googleMapController;
 
  }
  Set<Marker> markers={};
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: GoogleMap(
        onLongPress: (LatLng){
        markers.clear();
          setState(() {
            
          });
        },
        onTap: (LatLng){
          markers.add(Marker(markerId: MarkerId('$LatLng'),position: LatLng,));
          setState(() {
            
          });
        },
        markers: markers,
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