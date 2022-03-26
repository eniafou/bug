import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';


void main() {
  runApp(const MyApp());
}




class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'bug',
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    asyncMethod();
    super.initState();
  }
  asyncMethod() async {
    if (await Permission.activityRecognition.request().isGranted) {
      Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
      Workmanager().registerPeriodicTask(
        "1",
        "Task",
        frequency: const Duration(minutes: 15),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    print(
        "#####################################################################################################################################################################################################################");
    print("I am in the callbackDispatcher Bug");
    return BackGroundWork().loadCounterValueJob();
  });
}



class BackGroundWork with ChangeNotifier {
  Future<bool> loadCounterValueJob() async {
    try {
    print(await Permission.activityRecognition.isGranted);
    Stream<StepCount> stepCountStream = Pedometer.stepCountStream;
    StepCount rawStep = await stepCountStream.first;
    DateTime timeStamp = rawStep.timeStamp;
    int rawValue = rawStep.steps;
    print(timeStamp);
    print(rawValue);
    }catch (err) {
      print((err.toString()));
      throw Exception(err);
    }

    return true;
  }
}