import 'package:medsreminder/appdata/application_data.dart';
import 'package:medsreminder/models/appointment.dart';
import 'package:medsreminder/screens/appointment_details.dart';
import 'package:flutter/material.dart';
import 'package:medsreminder/utils/utils.dart';

/*
  Appointment quick view, used to build ListViews in calender/home
  On tap seds the user to the 'details' page.

  + appointment: appointment record as SQLObject
*/

class AppointmentWidget extends StatelessWidget {
  final Appointment appointment;

  const AppointmentWidget({
    Key? key,
    required this.appointment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AppointmentDetails(appointment: appointment)),
        );
      },
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0.0, 12.0, 18.0, 0.0),
            alignment: Alignment.topRight,
            child: Text(
              Utils.prettyTime(appointment.time),
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
          Container(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(18),
                    child: Image(
                      image: AssetImage(
                          ApplicationData.appoIcons[appointment.icon]!),
                      width: 42.0,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(0.0, 12.0, 30.0, 8.0),
                          alignment: Alignment.topLeft,
                          child: Text(
                            appointment.name,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.fromLTRB(0.0, 4.0, 60.0, 4.0),
                            child: Text(
                              appointment.place!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(fontStyle: FontStyle.italic),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )),
                        Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.fromLTRB(0.0, 4.0, 60.0, 30.0),
                            child: Text(
                              appointment.note!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.caption,
                            )),
                      ],
                    ),
                  )
                ]),
          ),
          const Divider(
            thickness: 1,
            height: 1,
            indent: (18 + 42 + 18),
          ),
        ],
      ),
    );
  }
}
