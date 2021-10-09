// Flutter imports:
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_project/controllers/task_controller.dart';
import 'package:getx_project/models/task.dart';
import 'package:getx_project/ui/widgets/button.dart';
import 'package:getx_project/ui/widgets/input_field.dart';
import 'package:intl/intl.dart';

import '../theme.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _startDate = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endDate = DateFormat('hh:mm a')
      .format(DateTime.now().add(Duration(minutes: 15)))
      .toString();

  int _selectedRemind = 5;
  List<int> _remindList = [5, 10, 15, 20];

  String _selectedRepeat = "None";
  List<String> _repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];

  int _selectedColor = 0;
  List colors = [Color(0xffC0392B), Color(0xffDC7633), Colors.deepPurpleAccent];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: buildAppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Add Task',
                style: headingStyle,
              ),
              InputField(
                hintText: 'Enter title',
                title: 'title',
                controller: _titleController,
              ), // title
              InputField(
                hintText: 'Enter note',
                title: 'Note',
                controller: _noteController,
              ), // note
              InputField(
                isReadOnly: true,
                hintText: DateFormat.yMd().format(_selectedDate).toString(),
                title: 'Date',
                widget: IconButton(
                  onPressed: () => _getDateFromUser(),
                  icon: Icon(Icons.calendar_today_outlined),
                  color: Colors.grey,
                ),
              ), // date
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      isReadOnly: true,
                      hintText: _startDate,
                      title: 'Start Time',
                      widget: IconButton(
                        onPressed: () => _getTimeFromUser(isStartTime: true),
                        icon: Icon(Icons.access_time_outlined),
                        color: Colors.grey,
                      ),
                    ),
                  ), // Start Time
                  SizedBox(width: 12),
                  Expanded(
                    child: InputField(
                      isReadOnly: true,
                      hintText: _endDate,
                      title: 'End Time',
                      widget: IconButton(
                        onPressed: () => _getTimeFromUser(isStartTime: false),
                        icon: Icon(Icons.access_time_outlined),
                        color: Colors.grey,
                      ),
                    ),
                  ), // End Time
                ],
              ), // Start And End Time
              InputField(
                  isReadOnly: true,
                  hintText: '$_selectedRemind minutes early',
                  title: 'Remind',
                  widget: Row(
                    children: [
                      DropdownButton(
                        borderRadius: BorderRadius.circular(18),
                        dropdownColor: Colors.grey[600],
                        onChanged: (String? value) {
                          setState(() {
                            _selectedRemind = int.parse(value!);
                          });
                        },
                        underline: Container(
                          height: 0,
                        ),
                        iconSize: 32,
                        elevation: 4,
                        icon: Icon(Icons.keyboard_arrow_down_outlined),
                        items: _remindList
                            .map<DropdownMenuItem<String>>((value) =>
                            DropdownMenuItem<String>(
                              child: Text('$value',
                                  style: TextStyle(color: Colors.white)),
                              value: value.toString(),
                            ))
                            .toList(),
                      ),
                      SizedBox(
                        width: 5,
                      )
                    ],
                  )), // first dropDownButton
              InputField(
                  isReadOnly: true,
                  hintText: _selectedRepeat,
                  title: 'Repeat',
                  widget: Row(
                    children: [
                      DropdownButton(
                          borderRadius: BorderRadius.circular(18),
                          dropdownColor: Colors.grey[600],
                          onChanged: (String? value) {
                            setState(() {
                              _selectedRepeat = value!;
                            });
                          },
                          underline: Container(
                            height: 0,
                          ),
                          iconSize: 32,
                          elevation: 4,
                          icon: Icon(Icons.keyboard_arrow_down_outlined),
                          items: _repeatList
                              .map<DropdownMenuItem<String>>((value) =>
                              DropdownMenuItem<String>(
                                child: Text('$value',
                                    style: TextStyle(color: Colors.white)),
                                value: value.toString(),
                              ))
                              .toList()),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  )), // second dropDownButton
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Colors"),
                      SizedBox(height: 4),
                      buildCircleColors(),
                    ],
                  ),
                  MyButton(
                    theFunction: () {
                      _validateDate();
                    },
                    label: "Add Task",
                  ),
                ],
              ) // the Colors and the Button
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() =>
      AppBar(
        backgroundColor: context.theme.backgroundColor,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Get.isDarkMode ? Colors.white : darkGreyClr,
          ),
        ),
      );

  buildCircleColors() {
    return Row(
        children: List.generate(
          3,
              (index) =>
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = index;
                    });
                  },
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: colors[index],
                    child: _selectedColor == index
                        ? Icon(
                      Icons.done_outlined,
                      color: Colors.white,
                      size: 20,
                    )
                        : null,
                  ),
                ),
              ),
        ));
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTskToDb();
      Get.back();
    } else {
      Get.snackbar("required", "all fields are required",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Get.isDarkMode ? Colors.white : Colors.black,
          icon: Icon(Icons.warning_amber_rounded));
    }
  }

  _addTskToDb() async {
    try {
      int value = await _taskController.addTask(
        task: Task(
          title: _titleController.text,
          note: _noteController.text,
          isCompleted: 0,
          date: DateFormat.yMd().format(_selectedDate),
          startTime: _startDate,
          endTime: _endDate,
          color: _selectedColor,
          remind: _selectedRemind,
          repeat: _selectedRepeat,
        ),
      );
      print(value);
    } on Exception catch (e) {
      print(e);
    }
  }

  _getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
    );
    setState(() {
      if (_pickedDate != null)
        _selectedDate = _pickedDate;
      else
        print("didnt picked the date");
    });
  }

  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? _pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(DateTime.now().add(Duration(minutes: 15))),
    );
    String _formattedTime = _pickedTime!.format(context);
    if (isStartTime) {
      setState(() => _startDate = _formattedTime);
    } else if (!isStartTime) {
      setState(() => _endDate = _formattedTime);
    } else {
      print("time canceled or something worng");
    }
  }
}
