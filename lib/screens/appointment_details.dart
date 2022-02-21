import 'package:flutter/material.dart';
import 'package:medsreminder/appdata/application_data.dart';
import 'package:medsreminder/forms/appointments_form.dart';
import 'package:medsreminder/models/appointment.dart';
import '../components/dialogs.dart';
import 'package:medsreminder/utils/utils.dart';

/*
  Detailed View - Appointment.
  Includes buttons to access the edit/delete submenu.

  + appointment: appointment as SQLObject
*/

class AppointmentDetails extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetails({
    Key? key,
    required this.appointment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Appointment info",
          textAlign: TextAlign.center,
        ),
        // return to previus screen
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
        // open dropdown menu
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) {
              handleClick(value, appointment.id, context);
            },
            itemBuilder: (BuildContext context) {
              return {'Edit', 'Delete'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      // appointment's detailed view
      body: ListView(
        children: <Widget>[
          Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(0.0, 18.0, 0.0, 9.0),
              child: Image(
                image: AssetImage(ApplicationData.appoIcons[appointment.icon]!),
                width: 64.0,
              )),
          Container(
            padding: EdgeInsets.fromLTRB(60.0, 4.0, 60.0, 4.0),
            alignment: Alignment.center,
            child: Text(
              appointment.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          SizedBox(
            height: 42.0,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(18, 18, 0, 18),
            alignment: Alignment.topLeft,
            child: Text(
              "General Info",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          const Divider(
            height: 1,
            thickness: 1,
            indent: 18,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.fromLTRB(18.0, 12.0, 0, 6.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Date",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(18.0),
                alignment: Alignment.centerRight,
                child: Text(
                  Utils.prettyDate(appointment.date),
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.fromLTRB(18.0, 12.0, 0, 6.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Time",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(18.0),
                alignment: Alignment.centerRight,
                child: Text(
                  Utils.prettyTime(appointment.time),
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
            ],
          ),
          (appointment.place != "")
              ? Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(18.0, 12.0, 18, 4.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Takes place in",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(18.0, 4.0, 18, 0.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        appointment.place!,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  ],
                )
              : SizedBox(),
          SizedBox(
            height: 25,
          ),
          (appointment.note != "")
              ? Container(
                  padding: EdgeInsets.fromLTRB(18, 18, 18, 18),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Notes",
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.justify,
                  ),
                )
              : SizedBox(),
          (appointment.note != "")
              ? const Divider(
                  height: 1,
                  thickness: 1,
                  indent: 18,
                )
              : SizedBox(),
          (appointment.note != "")
              ? Container(
                  padding: EdgeInsets.fromLTRB(18, 18, 0, 0),
                  alignment: Alignment.topLeft,
                  child: Text(
                    appointment.note!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(height: 1.6),
                  ),
                )
              : SizedBox(),
          (appointment.note != "")
              ? SizedBox(
                  height: 25,
                )
              : SizedBox(),
          Container(
            padding: EdgeInsets.fromLTRB(18, 18, 0, 18),
            alignment: Alignment.topLeft,
            child: Text(
              "Notifications",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          const Divider(
            height: 1,
            thickness: 1,
            indent: 18,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.fromLTRB(18.0, 12.0, 0, 6.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Active",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(18.0),
                alignment: Alignment.centerRight,
                child: Text(
                  appointment.reminder == 0 ? "NO" : "YES",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // handle dropdown actions
  void handleClick(String value, int? id, BuildContext context) {
    switch (value) {
      case 'Edit':
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AppointmentsForm(id: appointment.id)),
        );
        break;
      case 'Delete':
        Dialogs.deleteDialog(
            "Delete Appointment?",
            "Are you sure you want to delete this appointment?\nThe action is not reversible.",
            1,
            id!,
            context);
    }
  }
}
