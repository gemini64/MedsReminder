import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medsreminder/components/dialogs.dart';
import 'package:medsreminder/models/appointment.dart';
import 'package:medsreminder/services/notification_helper.dart';
import 'package:medsreminder/appdata/application_data.dart';
import 'package:medsreminder/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:medsreminder/providers/appointments_provider.dart';

class AppointmentsForm extends StatefulWidget {
  int? id;

  AppointmentsForm({
    Key? key,
    this.id,
  }) : super(key: key);

  @override
  _AppointmentsFormState createState() => _AppointmentsFormState();
}

class _AppointmentsFormState extends State<AppointmentsForm> {
  // set defaults
  Appointment _appointment = Appointment(
    name: "",
    place: "",
    note: "",
    icon: ApplicationData.appoIcons["default"]!,
    reminder: 0,
    date: DateTime.now(),
    time: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
  );
  bool _addToCalendar = false;
  //FocusNode _form1Focus = FocusNode();

  late final _formsPageViewController = PageController();
  int _pageIndex = 0;
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  final List<IconData> _leadingIcon = [
    Icons.close,
    Icons.arrow_back_ios,
  ];

  final List<String> _actionText = ["Next", "Submit"];
  final List<String> _titles = [
    "1/2: Titile and time",
    "2/2: Notifications",
  ];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    // Dispose of focus node/s
    //_form1Focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            title: Column(
              children: [
                Text('Add appointment'),
                Text(_titles[_pageIndex]),
              ],
            ),
            leading: IconButton(
              icon: Icon(_leadingIcon[_pageIndex]),
              onPressed: () {
                if (_pageIndex == 0) {
                  dismiss();
                } else {
                  previuosFormStep();
                }
              },
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    if (_pageIndex == _formKeys.length - 1) {
                      sendData();
                    } else {
                      nextFormStep();
                    }
                  },
                  child: Text(_actionText[_pageIndex])),
            ],
          ),
          body: GestureDetector(
            // defocus on outer-tap
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: PageView(
              controller: _formsPageViewController,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                // - - Form Step 1
                Form(
                  key: _formKeys[0],
                  child: ListView(
                    children: [
                      Container(
                        padding: EdgeInsets.all(18.0),
                        child:
                            Text('Pick a title and time for your appointment'),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        indent: 18,
                      ),
                      buildTitleField(),
                      buildDateTime(),
                      Container(
                        padding: EdgeInsets.all(18.0),
                        child: Text(
                            '(Optional) Add any useful note and set a place for your apppointment'),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        indent: 18,
                      ),
                      buildPlaceField(),
                      buildNoteField(),
                    ],
                  ),
                ),

                // - - Form Step 2
                Form(
                  key: _formKeys[1],
                  child: ListView(
                    children: [
                      Container(
                        padding: EdgeInsets.all(18.0),
                        child: Text('(Optional) Set a notification'),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        indent: 18,
                      ),
                      buildNotificationToggle(),
                      //buildCalendarToggle(),
                    ],
                  ),
                ),
              ],
            ),
          )),
      onWillPop: () async {
        dismiss();
        return false;
      },
    );
  }

  void loadData() {
    if (widget.id != null) {
      _appointment = Provider.of<AppointmentsProvider>(context, listen: false)
          .selectById(widget.id!);
    }
  }

  void nextFormStep() {
    if (_formKeys[_pageIndex].currentState!.validate()) {
      _formKeys[_pageIndex].currentState!.save();

      _formsPageViewController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );

      setState(() {
        _pageIndex++;
      });

      // defocus
      FocusScope.of(context).unfocus();
    }
  }

  void previuosFormStep() {
    _formsPageViewController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );

    setState(() {
      _pageIndex--;
    });
  }

  void dismiss() {
    // dismiss focused field
    FocusScope.of(context).unfocus();
    // show exit confirm dialog
    Dialogs.exitDialog("Exit without saving?",
        "Are you sure you want to exit without saving?", context);
  }

  Future<void> sendData() async {
    if (_formKeys[_pageIndex].currentState!.validate()) {
      _formKeys[_pageIndex].currentState!.save();

      // set reminder
      setReminder();

      // send data to DB
      int newId =
          await Provider.of<AppointmentsProvider>(context, listen: false)
              .add(_appointment);

      // pop form
      Navigator.pop(context);
    }
  }

  void setReminder() {
    // edge case: the reminder has been set for a date before current time
    if (Utils.timeAndDate(_appointment.date!, _appointment.time!)
        .isBefore(DateTime.now().add(const Duration(seconds: 5)))) {
      _appointment.reminder = 0;
      if (_appointment.notificationId != null) {
        NotificationHelper().cancelNotifications(_appointment.notificationId!);
        _appointment.notificationId = null;
      }
      return;
    }

    // check if a reminder has been set
    if (_appointment.reminder == 1) {
      // set a new id
      if (_appointment.notificationId == null) {
        // set a new id
        _appointment.notificationId = _appointment.hashCode;
      }

      // schedule notification
      NotificationHelper().scheduleNotifications(
          _appointment.notificationId!,
          "You have a pending appointment!",
          _appointment.name + " • " + "Tap to see details...",
          Utils.timeAndDate(_appointment.date!, _appointment.time!),
          jsonEncode(
              {"id": _appointment.notificationId, "type": "appointment"}));
    } else {
      if (_appointment.notificationId != null) {
        NotificationHelper().cancelNotifications(_appointment.notificationId!);
        _appointment.notificationId = null;
      }
    }
  }

  // - - Form 1 - Fields

  // appointment's name
  Widget buildTitleField() {
    return Container(
        padding: EdgeInsets.all(18.0),
        child: TextFormField(
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          //focusNode: _form1Focus,
          maxLength: 40,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "A name for this appointment...",
            labelText: "Title*",
            helperText: "",
          ),
          initialValue: (_appointment.name == "") ? null : _appointment.name,
          onSaved: (String? value) {
            setState(() {
              _appointment.name = value!;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "A title is required";
            }
            return null;
          },
        ));
  }

  // appointment's notes
  Widget buildNoteField() {
    return Container(
      padding: EdgeInsets.fromLTRB(18.0, 9.0, 18.0, 18.0),
      child: TextFormField(
        textAlignVertical: TextAlignVertical.top,
        maxLines: 3,
        maxLength: 255,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          icon: Icon(
            Icons.edit,
          ),
          border: OutlineInputBorder(),
          hintText: "Anything you wish to remember...",
          labelText: "Notes (Optional)",
          alignLabelWithHint: true,
          helperText: "",
        ),
        initialValue: (_appointment.note == "") ? null : _appointment.note,
        onSaved: (String? value) {
          setState(() {
            if (value == null || value.isEmpty) {
              _appointment.note = "";
            } else {
              _appointment.note = value;
            }
          });
        },
        validator: (value) {
          return null;
        },
      ),
    );
  }

  Widget buildPlaceField() {
    return Container(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 9.0),
      child: TextFormField(
        maxLength: 40,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          icon: Icon(Icons.place),
          border: OutlineInputBorder(),
          hintText: "Takes place in...",
          labelText: "Place (Optional)",
          helperText: "",
        ),
        initialValue: (_appointment.place == "") ? null : _appointment.place,
        onSaved: (String? value) {
          setState(() {
            if (value == null || value.isEmpty) {
              _appointment.place = "";
            } else {
              _appointment.place = value;
            }
          });
        },
        validator: (value) {
          return null;
        },
      ),
    );
  }

  // date and time pickers
  Widget buildDateTime() {
    return Row(
      children: [
        Expanded(
          child: Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 18, 18),
              child: TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                    hintText: Utils.prettyDate(_appointment.date),
                    helperText: "",
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _appointment.date!,
                        firstDate: _appointment.date!,
                        lastDate: DateTime(_appointment.date!.year + 10));

                    if (pickedDate != null && pickedDate != _appointment.date) {
                      setState(() {
                        _appointment.date = pickedDate;
                      });
                    }
                  })),
          flex: 3,
        ),
        // Unit DropDown
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 18, 18),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: Utils.prettyTime(_appointment.time),
                helperText: "",
              ),
              readOnly: true,
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: _appointment.time!,
                  builder: (BuildContext context, Widget? child) {
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(alwaysUse24HourFormat: true),
                      child: child!,
                    );
                  },
                );

                if (pickedTime != null) {
                  setState(() {
                    _appointment.time = pickedTime;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  // - - Form 2 - Fields
  Widget buildNotificationToggle() {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 9.0, 9.0, 9.0),
      child: Row(
        children: [
          Expanded(
              flex: 4,
              child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text("Set a notification"))),
          Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.centerRight,
                child: Switch(
                  value: (_appointment.reminder == 0) ? false : true,
                  onChanged: (value) {
                    setState(() {
                      _appointment.reminder = value ? 1 : 0;
                    });
                  },
                ),
              )),
        ],
      ),
    );
  }

  Widget buildCalendarToggle() {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 9.0, 9.0, 9.0),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text("Add to system calendar"),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerRight,
              child: Switch(
                value: _addToCalendar,
                onChanged: (value) {
                  setState(() {
                    _addToCalendar = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
