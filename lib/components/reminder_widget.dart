import 'package:medsreminder/appdata/application_data.dart';
import 'package:medsreminder/components/dialogs.dart';
import 'package:medsreminder/models/medication.dart';
import 'package:medsreminder/models/reminder.dart';
import 'package:flutter/material.dart';
import 'package:medsreminder/utils/utils.dart';
import 'package:path/path.dart';

/*
  + reminder: reminder record as SQLObject.
  + medication: medication record as SQLObject.
  
  Used to build lists in 'home' screen.
*/

class ReminderWidget extends StatelessWidget {
  final Reminder reminder;
  final Medication medication;

  ReminderWidget({
    Key? key,
    required this.reminder,
    required this.medication,
  }) : super(key: key);

  final List<bool?> _checkbox = [
    false,
    true,
    null,
  ];

  final List<String> checkboxLabels = [
    "",
    "Taken",
    "Missed",
  ];

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Dialogs.pillDialog(context, reminder.notificationId!);
        },
        child: Column(children: [
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(18),
                alignment: Alignment.center,
                child: Image(
                  image:
                      AssetImage(ApplicationData.pillsIcons[medication.icon]!),
                  width: 42.0,
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 8.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              medication.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: (Theme.of(context).textTheme.headline6),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
                            child: Text(
                              (Utils.prettyTime(reminder.time) +
                                  " - " +
                                  "Take ${reminder.pills}"),
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(9.0),
                      alignment: Alignment.centerRight,
                      child: Checkbox(
                        checkColor: Colors.white,
                        shape: CircleBorder(),
                        activeColor:
                            Utils.getCheckColor(reminder.taken!, context),
                        tristate: true,
                        value: _checkbox[reminder.taken!],
                        onChanged: (bool? value) {
                          //
                        },
                      ),
                    )
                  ],
                ),
              ),
              const Divider(
                height: 1,
                thickness: 1,
              ),
            ],
          ),
          const Divider(height: 1, thickness: 1, indent: 78.0),
        ]));
  }
}
