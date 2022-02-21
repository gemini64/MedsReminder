import 'package:flutter/material.dart';
import 'package:medsreminder/components/placeholder_widgets.dart';
import 'package:medsreminder/components/reminder_widget.dart';
import 'package:medsreminder/models/reminder.dart';
import 'package:medsreminder/providers/reminders_provider.dart';
import 'package:medsreminder/appdata/application_data.dart';
import 'package:provider/provider.dart';
import 'package:medsreminder/providers/appointments_provider.dart';
import 'package:medsreminder/providers/medications_provider.dart';
import 'package:medsreminder/components/appointment_widget.dart';
import 'package:medsreminder/models/appointment.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _currentDate = DateTime.utc(
      (DateTime.now()).year, (DateTime.now()).month, (DateTime.now()).day);

  @override
  Widget build(BuildContext context) {
    return Consumer3<AppointmentsProvider, RemindersProvider,
            MedicationsProvider>(
        builder: (context, appoProvider, remsProvider, medsProvider, child) {
      List<Appointment> appointments = appoProvider.events[_currentDate] ?? [];
      List<Reminder> reminders = remsProvider.reminders;

      // this is a hack to avoid state corruption after meds deletion
      reminders.removeWhere(
          (e) => medsProvider.selectById(e.referenceId).id == null);

      return ListView(
        children: <Widget>[
          // - - Today's scheduled appointments
          Container(
            padding: EdgeInsets.fromLTRB(18, 18, 0, 4),
            alignment: Alignment.topLeft,
            child: Text(
              (ApplicationData.daysOfTheWeek[_currentDate.weekday] ?? "")
                  .toUpperCase(),
              style: Theme.of(context).textTheme.overline,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(18, 9, 0, 18),
            alignment: Alignment.topLeft,
            child: Text(
              _currentDate.day.toString() +
                  " " +
                  (ApplicationData.months[_currentDate.month] ?? ""),
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          const Divider(
            height: 1,
            thickness: 1,
            indent: 18,
          ),
          // - - - - - -
          ListView.builder(
            itemCount: appointments.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, i) {
              return AppointmentWidget(appointment: appointments[i]);
            },
          ),
          (appointments.isEmpty)
              ? PlaceholderWidgets.appointmentPlaceholder(context)
              : SizedBox(),
          SizedBox(
            height: 25.0,
          ),

          // - - Daily assumptions
          Container(
            padding: EdgeInsets.fromLTRB(18, 18, 0, 4),
            alignment: Alignment.topLeft,
            child: Text(
              'MY MEDICATIONS',
              style: Theme.of(context).textTheme.overline,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(18, 9, 0, 18),
            alignment: Alignment.topLeft,
            child: Text(
              'Assume Daily',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          const Divider(
            height: 1,
            thickness: 1,
            indent: 18,
          ),
          // - - - - - -
          ListView.builder(
            itemCount: reminders.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, i) {
              return ReminderWidget(
                  reminder: reminders[i],
                  medication:
                      medsProvider.selectById(reminders[i].referenceId));
            },
          ),
          (reminders.isEmpty)
              ? PlaceholderWidgets.medicationsPlaceholder(context)
              : SizedBox(),
        ],
      );
    });
  }
}
