import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medsreminder/appdata/application_data.dart';
import 'package:medsreminder/forms/medications_form.dart';
import 'package:medsreminder/forms/appointments_form.dart';
import 'package:medsreminder/models/medication.dart';
import 'package:medsreminder/models/reminder.dart';
import 'package:medsreminder/services/notification_helper.dart';
import 'package:medsreminder/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:medsreminder/providers/medications_provider.dart';
import 'package:medsreminder/providers/appointments_provider.dart';
import 'package:medsreminder/providers/reminders_provider.dart';
import 'package:medsreminder/appdata/meds_reminder_icons.dart';

class Dialogs {
  // shows a 2 button alert to confirm pharma/appoint deletion
  static Future<void> deleteDialog(String title, String message, int actionType,
      int id, BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              // dismiss dialog
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              // confirm delete
              TextButton(
                  onPressed: () {
                    if (actionType == 0) {
                      Provider.of<RemindersProvider>(context, listen: false)
                          .deleteByRef(id);
                      Provider.of<MedicationsProvider>(context, listen: false)
                          .delete(id);
                    } else {
                      Provider.of<AppointmentsProvider>(context, listen: false)
                          .delete(id);
                    }
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text("Delete")),
            ]);
      },
    );
  }

  // shows a 2 button alert to confirm current route pop
  static Future<void> exitDialog(
      String title, String message, BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              // cancel action
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              // confirm delete
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text("Exit")),
            ]);
      },
    );
  }

  // 2 button dialog to insert appointments/notifications
  static Future<void> addDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MedicationsForm()),
                );
              },
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.medication,
                      size: 28.0,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: EdgeInsets.all(14.0),
                      child: Text(
                        'Add a Prescription',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              indent: 18,
              endIndent: 18,
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AppointmentsForm()),
                );
              },
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.calendar_today,
                      size: 28.0,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: EdgeInsets.all(14.0),
                      child: Text(
                        'Add an Appointment',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          elevation: 10,
        );
      },
    );
  }

  // reminders dialog - 3 buttons
  static Future<void> pillDialog(BuildContext context, int id) async {
    await showDialog(
      context: context,
      builder: (_) {
        // initialize data
        Reminder _reminder =
            Provider.of<RemindersProvider>(context, listen: false)
                .selectByNotificationId(id);
        Medication _medication =
            Provider.of<MedicationsProvider>(context, listen: false)
                .selectById(_reminder.referenceId);

        return SimpleDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          children: <Widget>[
            // icon, name and strength
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(0.0, 18.0, 0.0, 9.0),
                child: Image(
                  image:
                      AssetImage(ApplicationData.pillsIcons[_medication.icon]!),
                  width: 64.0,
                )),
            Container(
              padding: EdgeInsets.fromLTRB(30.0, 4.0, 30.0, 4.0),
              alignment: Alignment.center,
              child: Text(
                _medication.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(30.0, 4.0, 30.0, 18.0),
              child: Text(
                (_medication.strength != 0)
                    ? ("Strength: " +
                        _medication.strength.toString() +
                        " " +
                        _medication.sUnit!)
                    : "",
                style: (Theme.of(context).textTheme.subtitle2)!
                    .copyWith(fontWeight: FontWeight.w400, fontSize: 14.0),
                textAlign: TextAlign.center,
              ),
            ),
            // instructions
            Container(
              padding: EdgeInsets.all(18.0),
              child: Text(
                ('Instructions').toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .overline!
                    .copyWith(fontSize: 12.0, height: 1.6),
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              indent: 18,
              endIndent: 18,
            ),
            Container(
              padding: EdgeInsets.all(18.0),
              child: Text(
                  "Take ${_reminder.pills} at ${Utils.prettyTime(_reminder.time)}",
                  style: Theme.of(context).textTheme.bodyText2),
            ),

            Container(
              padding: EdgeInsets.fromLTRB(30.0, 18.0, 30.0, 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      // back
                      SimpleDialogOption(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Icon(MedsReminder.left_circle, size: 42.0),
                      ),
                      Text(
                        "BACK",
                        style: Theme.of(context)
                            .textTheme
                            .button!
                            .copyWith(fontSize: 10.0),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      // missed
                      SimpleDialogOption(
                        onPressed: () async {
                          if (_reminder.taken != 2) {
                            _reminder.taken = 2;
                            await Provider.of<RemindersProvider>(context,
                                    listen: false)
                                .add(_reminder);

                            // try reschedule
                            if (DateTime.now()
                                .isBefore(Utils.timeToDate(_reminder.time!))) {
                              DateTime newTime =
                                  Utils.timeToDate(_reminder.time!)
                                      .add(const Duration(days: 1));
                              NotificationHelper().scheduleNotificationsDaily(
                                  _reminder.notificationId!,
                                  "It's time for your medicine!",
                                  _medication.name +
                                      " • " +
                                      "Take ${_reminder.pills} at ${Utils.prettyTime(_reminder.time)}",
                                  newTime,
                                  jsonEncode({
                                    "id": _reminder.notificationId,
                                    "type": "medication"
                                  }));
                            }
                          }

                          Navigator.pop(context);
                        },
                        child: Icon(
                          MedsReminder.minus_circle,
                          size: 42.0,
                          color: Theme.of(context).errorColor,
                        ),
                      ),
                      Text(
                        "MISSED",
                        style: Theme.of(context)
                            .textTheme
                            .button!
                            .copyWith(fontSize: 10.0),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      // taken
                      SimpleDialogOption(
                        onPressed: () async {
                          if (_reminder.taken != 1) {
                            _reminder.taken = 1;
                            await Provider.of<RemindersProvider>(context,
                                    listen: false)
                                .add(_reminder);

                            // try reschedule
                            if (DateTime.now()
                                .isBefore(Utils.timeToDate(_reminder.time!))) {
                              DateTime newTime =
                                  Utils.timeToDate(_reminder.time!)
                                      .add(const Duration(days: 1));
                              NotificationHelper().scheduleNotificationsDaily(
                                  _reminder.notificationId!,
                                  "It's time for your medicine!",
                                  _medication.name +
                                      " • " +
                                      "Take ${_reminder.pills} at ${Utils.prettyTime(_reminder.time)}",
                                  newTime,
                                  jsonEncode({
                                    "id": _reminder.notificationId,
                                    "type": "medication"
                                  }));
                            }
                          }

                          Navigator.pop(context);
                        },
                        child: Icon(MedsReminder.ok_circle,
                            size: 42.0, color: Colors.teal),
                      ),
                      Text(
                        "TAKEN",
                        style: Theme.of(context)
                            .textTheme
                            .button!
                            .copyWith(fontSize: 10.0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

// reminders dialog - 3 buttons
  static Future<int?> showIconPicker(
      {required BuildContext context,
      required Map<int, String> iconPack,
      double? imageSize,
      double? spacing}) async {
    int? outValue = null;
    await showDialog(
      context: context,
      builder: (_) {
        // initialize data
        return SimpleDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(18.0),
              child: Text(
                ('Pick an Icon').toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .overline!
                    .copyWith(fontSize: 12.0, height: 1.6),
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              indent: 18,
              endIndent: 18,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              width: MediaQuery.of(context).size.width,
              child: Container(
                child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 0.0,
                      mainAxisSpacing: 0.0,
                      crossAxisCount: 3,
                    ),
                    itemCount: iconPack.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SimpleDialogOption(
                        onPressed: () {
                          outValue = index;
                          Navigator.pop(context, index);
                        },
                        child: Image(
                          image: AssetImage(iconPack[index]!),
                          width: (imageSize == null) ? 64.0 : imageSize,
                        ),
                      );
                    }),
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              indent: 18,
              endIndent: 18,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(18.0, 9, 18, 0),
              alignment: Alignment.centerRight,
              child: SimpleDialogOption(
                onPressed: () {
                  outValue = null;
                  Navigator.pop(context, null);
                },
                child: Text(
                  'Close',
                  style: Theme.of(context)
                      .textTheme
                      .button!
                      .copyWith(color: Colors.teal),
                ),
              ),
            ),
          ],
        );
      },
    );
    return outValue;
  }
}
