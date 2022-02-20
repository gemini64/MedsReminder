import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medsreminder/components/appointment_widget.dart';
import 'package:medsreminder/components/placeholder_widgets.dart';
import 'package:medsreminder/models/appointment.dart';
import 'package:medsreminder/models/medication.dart';
import 'package:medsreminder/providers/appointments_provider.dart';
import 'package:medsreminder/appdata/application_data.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentsProvider>(
        builder: (context, appoProvider, child) {
      DateTime initialDate = appoProvider.initialDate;
      DateTime finalDate = appoProvider.finalDate;
      LinkedHashMap<DateTime, List<Appointment>> events = appoProvider.events;

      return Calendar(
          initialDate: initialDate, finalDate: finalDate, events: events);
    });
  }
}

class Calendar extends StatefulWidget {
  final DateTime initialDate;
  final DateTime finalDate;
  final LinkedHashMap<DateTime, List<Appointment>> events;

  const Calendar(
      {Key? key,
      required this.initialDate,
      required this.finalDate,
      required this.events})
      : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late List<Appointment> _selectedEvents;
  late LinkedHashMap<DateTime, List<Appointment>> _events;
  late DateTime _initialDate;
  late DateTime _finalDate;
  DateTime _focusedDay = DateTime.utc(
      (DateTime.now()).year, (DateTime.now()).month, (DateTime.now()).day);
  late DateTime _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  Map<CalendarFormat, String> _availableFormats = {
    CalendarFormat.week: "compact",
    CalendarFormat.month: "full",
  };

  List<Appointment> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _selectedEvents = _getEventsForDay(selectedDay);
    }
  }

  @override
  void initState() {
    super.initState();
    _events = widget.events;
    _selectedDay = _focusedDay;
    _initialDate = widget.initialDate;
    _finalDate = widget.finalDate;
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _selectedEvents = _getEventsForDay(_selectedDay);
    });
    return ListView(
      children: <Widget>[
        TableCalendar(
          firstDay: _initialDate,
          lastDay: _finalDate,
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: _onDaySelected,
          availableCalendarFormats: _availableFormats,
          calendarFormat: _calendarFormat,
          rangeSelectionMode: RangeSelectionMode.disabled,
          startingDayOfWeek: StartingDayOfWeek.monday,
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          eventLoader: (day) {
            return _getEventsForDay(day);
          },
        ),
        Container(
          padding: EdgeInsets.fromLTRB(18, 18, 0, 4),
          alignment: Alignment.topLeft,
          child: Text(
            ApplicationData.daysOfTheWeek[_selectedDay.weekday] ?? "",
            style: Theme.of(context).textTheme.overline,
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(18, 9, 0, 18),
          alignment: Alignment.topLeft,
          child: Text(
            _selectedDay.day.toString() +
                " " +
                (ApplicationData.months[_selectedDay.month] ?? ""),
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        const Divider(
          height: 1,
          thickness: 1,
          indent: 18,
        ),
        ListView.builder(
          itemCount: _selectedEvents.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return AppointmentWidget(appointment: _selectedEvents[index]);
          },
        ),
        (_selectedEvents.isEmpty)
            ? PlaceholderWidgets.appointmentPlaceholder(context)
            : SizedBox(),
      ],
    );
  }
}
