import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:getcoo/model.dart';
import 'package:wifi_flutter/wifi_flutter.dart';
import 'package:flutter/material.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // String latitudeData='';
  List<Widget> _platformVersion = [];

  // String longitudeData='';
  int SSID;
  List <Map> rssi=[];
  List level=[];
  List ssid=[];
  int seconds=5;
  Timer timer;

  @override
  void initState() {
    super.initState();
  }


  // getCurrentLocation()async
  // {
  //
  //  Timer.periodic(Duration(seconds: 10), (timer) async{
  //
  //     final geoPosition=await Geolocator
  //         .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //
  //     setState(() {
  //       latitudeData='${geoPosition.latitude}';
  //       longitudeData='${geoPosition.longitude}';
  //     });
  //     print('${geoPosition.latitude}');
  //     print('${geoPosition.longitude}');
  //     //code to run on every 5 seconds
  //   });
  //
  // }

  // WiFiHunterResult wiFiHunterResult = WiFiHunterResult();
  // Color huntButtonColor = Colors.lightBlue;

  // Future<void> huntWiFis() async {
  //
  //
  //   // Timer.periodic(Duration(seconds: 20), (timer) async{
  //
  //     setState(() => huntButtonColor = Colors.red);
  //     try {
  //       // if (WiFiHunter.huntWiFiNetworks!= null)
  //       wiFiHunterResult = ((await WiFiHunter.huntWiFiNetworks));
  //     } on PlatformException catch (exception) {
  //       print(exception.toString());
  //     }
  //
  //     if (!mounted) return;
  //
  //     setState(() {
  //       wiFiHunterResult.results
  //           .forEach((element)
  //       {
  //         // ssid.add(element.SSID);
  //         // level.add(element.level);
  //         rssi.add({'${element.SSID}':element.level});
  //
  //       });
  //     });
  //
  //     sendToDataSet(rssi: rssi);
  //   // });
  //     setState(() => huntButtonColor = Colors.lightBlue);
  //
  //
  //
  //
  // }




  getRssi() async {
    final noPermissions = await WifiFlutter.promptPermissions();
    if (noPermissions) {
      return;
    }
    await WifiFlutter.scanNetworks().then((value)
    {
      setState(() {
        rssi.clear();
        value.forEach((element) {rssi.add({'${element.ssid}':element.rssi});});
      });
    });

  }

  void sendToDataSet({
    // required latitude,longitude,
    @required rssi
  }){


    DataModel model = DataModel(
        rssi:rssi ,
        // latitude:latitude ,
        // longitude:longitude ,
    );
    FirebaseFirestore.instance
        .collection('DataSet')
        .add(model.toMap())
        .then((value) {

    })
        .catchError((error) {
          print(error);
    });

  }

  void play()
  {
    Timer.periodic(Duration(seconds: 10), (timer) async{

            getRssi();
            sendToDataSet(rssi: rssi);
            print(rssi);
        });

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RSSI'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(100.0),
              child: Container(
                height:200 ,
                width: 200,
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                  color: Colors.blue
                ),
                child: MaterialButton(
                  onPressed:(){
                    play();
                    },
                  child: Text('Play',style:TextStyle(color: Colors.white,fontSize: 35) ,),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, i) => _platformVersion[i],
              itemCount: _platformVersion.length,
            ),
          ],
        ),
      ),
    );
  }
}
