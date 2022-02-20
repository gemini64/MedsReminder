import 'package:flutter/material.dart';
import 'package:medsreminder/forms/medications_form.dart';
import 'package:medsreminder/models/medication.dart';
import 'package:medsreminder/models/reminder.dart';
import 'package:medsreminder/providers/reminders_provider.dart';
import 'package:medsreminder/utils/utils.dart';
import '../components/dialogs.dart';
import 'package:provider/provider.dart';

/*
  Detailed View - Medication.
  Includes buttons to access the edit/delete submenu.

  + medication: medication record as SQLObject
*/

class MedicationDetails extends StatelessWidget {
  final Medication medication;

  const MedicationDetails({
    Key? key,
    required this.medication,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Medication info",
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
                handleClick(value, medication.id, context);
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
        // pharma's detailed view
        body: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(0.0, 18.0, 0.0, 9.0),
              child: Icon(
                medication.icon,
                size: 64.0,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(60.0, 4.0, 60.0, 4.0),
              alignment: Alignment.center,
              child: Text(
                medication.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(60.0, 4.0, 60.0, 4.0),
              child: Text(
                (medication.strength != 0)
                    ? ("Strength: " +
                        medication.strength.toString() +
                        " " +
                        medication.sUnit!)
                    : "",
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(18, 18, 0, 18),
              alignment: Alignment.topLeft,
              child: Text(
                "Reminders",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              indent: 18,
            ),
            Consumer<RemindersProvider>(
              builder: (context, remsProvider, child) {
                List<Reminder> myReminders =
                    remsProvider.selectByRef(medication.id!);

                if (myReminders.isEmpty) {
                  return SizedBox();
                }

                return ListView.builder(
                  itemCount: myReminders.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, i) {
                    return reminderWidget(myReminders[i], i, context);
                  },
                );
              },
            ),
          ],
        ));
  }

  Widget reminderWidget(Reminder reminder, int index, BuildContext context) {
    int remNumber = index + 1;
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(18.0, 12.0, 0, 4.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Reminder ${remNumber}",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(18.0, 4.0, 0, 6.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Take ${reminder.pills}",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(18.0),
          alignment: Alignment.centerRight,
          child: Text(
            Utils.prettyTime(reminder.time),
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
      ],
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
              builder: (context) => MedicationsForm(id: medication.id)),
        );
        break;
      case 'Delete':
        Dialogs.deleteDialog(
            "Delete Medication?",
            "Are you sure you want to delete this medication?\nThe action is not reversible.",
            0,
            id!,
            context);
    }
  }
}
