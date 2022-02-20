import 'package:medsreminder/models/medication.dart';
import 'package:medsreminder/screens/medication_details.dart';
import 'package:flutter/material.dart';

/*
  Medication quick view, used to build ListViews in 'medications' screen
  On tap sens the user to the 'details' page.

  + medication: medication record as SQLObject
*/

class MedicationWidget extends StatelessWidget {
  final Medication medication;

  const MedicationWidget({
    Key? key,
    required this.medication,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MedicationDetails(medication: medication)),
          );
        },
        child: Column(children: [
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(18.0),
                alignment: Alignment.center,
                child: Icon(
                  medication.icon,
                  size: 42.0,
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
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
                            child: Text(
                              (medication.strength != 0)
                                  ? (medication.strength.toString() +
                                      " " +
                                      medication.sUnit!)
                                  : "",
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(9.0),
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.arrow_forward_ios),
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
