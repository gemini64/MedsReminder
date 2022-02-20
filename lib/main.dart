import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:medsreminder/components/dialogs.dart';
import 'package:medsreminder/forms/medications_form.dart';
import 'package:medsreminder/services/notification_helper.dart';
import 'package:provider/provider.dart';

import 'package:medsreminder/providers/medications_provider.dart';
import 'package:medsreminder/providers/appointments_provider.dart';
import 'package:medsreminder/providers/reminders_provider.dart';

import 'package:medsreminder/screens/home_screen.dart';
import 'package:medsreminder/screens/calendar_screen.dart';
import 'package:medsreminder/screens/medications_screen.dart';
import 'package:medsreminder/screens/more_screen.dart';

import 'forms/appointments_form.dart';

Future<void> main() async {
  // init notification service
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper().init();

  // schedule reminders reset
  final cron = Cron();
  cron.schedule(Schedule.parse('0 0 * * *'), () async {
    await Provider.of<RemindersProvider>(navigatorKey.currentContext!,
            listen: false)
        .resetReminders();
  });

  runApp(const MyApp());
}

// this is used to access navigator without a context handle
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// main content wrapper
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MedicationsProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentsProvider()),
        ChangeNotifierProvider(create: (_) => RemindersProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'MedsReminder',
        theme: ThemeData(
            brightness: Brightness.light, primaryColor: Colors.blueGrey),
        home: HomeWidget(),
        debugShowCheckedModeBanner: true,
      ),
    );
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int _pageIndex = 0;

  static List<Widget> _pages = <Widget>[
    HomeScreen(),
    CalendarScreen(),
    MedicationScreen(),
    MoreScreen(),
  ];

  static const List<String> _titles = [
    'MedsReminder',
    'Appointments',
    'Medications',
    'More'
  ];

  void _onItemTapped(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  void _buttonHandler(BuildContext context, int index) {
    switch (index) {
      case 0:
        Dialogs.addDialog(context);
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AppointmentsForm()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MedicationsForm()),
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_pageIndex]),
        centerTitle: true,

        // this at the moment contains only a placeholder add button
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add an appointment or prescription',
            onPressed: () {
              _buttonHandler(context, _pageIndex);
            },
          ),
        ],
      ),
      body: _pages.elementAt(_pageIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication),
            label: 'Meds',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
        currentIndex: _pageIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
