// Flutter imports:
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:getx_project/controllers/task_controller.dart';
import 'package:getx_project/models/task.dart';
import 'package:getx_project/services/notification_services.dart';
import 'package:getx_project/services/theme_services.dart';
import 'package:getx_project/ui/size_config.dart';

// Project imports:
import 'package:getx_project/ui/widgets/button.dart';
import 'package:getx_project/ui/widgets/input_field.dart';
import 'package:getx_project/ui/widgets/task_tile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../theme.dart';
import 'add_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskController _taskController = Get.put(TaskController());
  DateTime _selectedDate = DateTime.now();
  late NotifyHelper notifyHelper;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    _taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: buildAppBar(context),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          _showTask(),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: context.theme.backgroundColor,
      centerTitle: true,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () => Get.dialog(Container(

            child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
                title: Text('Are you sure you want to delete all the tasks ?!'),
                content: Container(
                  width: SizeConfig.screenWidth * 0.30,
                  height: SizeConfig.screenHeight * 0.10,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MyButton(
                            theFunction: () {
                              Get.back();
                            },
                            label: "No",
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          MyButton(
                            theFunction: () {
                              NotifyHelper().cancelAllNotification();
                              _taskController.deleteAllTasks();
                              Get.back();
                            },
                            label: "Yes",
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          )),
          icon: Icon(
            Icons.delete_forever_outlined,
            size: 25,
            color: Get.isDarkMode ? Colors.redAccent : Colors.red[300],
          ),
        ),
      ],
      leading: IconButton(
        onPressed: () => ThemeServices().switchTheme(),
        icon: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_outlined,
          color: Get.isDarkMode ? Colors.yellow.shade200 : darkGreyClr,
        ),
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()).toString(),
                style: headingStyle,
              ),
              Text(
                'Today',
                style: headingStyle,
              )
            ],
          ),
          MyButton(
            theFunction: () async {
              await Get.to(() => AddTaskPage());
              _taskController.getTasks();
            },
            label: "Add Task",
            icon: Icon(
              Icons.add_rounded,
              size: 15,
            ),
          ),
        ],
      ),
    );
  }

  _addDateBar() {
    dateStyleForDateBar(double fontSize) {
      return GoogleFonts.lato(
          color: Colors.grey,
          textStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ));
    }

    return Container(
      margin: EdgeInsets.only(top: 6, left: 20),
      child: DatePicker(
        DateTime.now(),
        width: 70,
        height: 90,
        daysCount: 50,
        initialSelectedDate: DateTime.now(),
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        dateTextStyle: dateStyleForDateBar(20.0),
        dayTextStyle: dateStyleForDateBar(13.0),
        monthTextStyle: dateStyleForDateBar(12.0),
        onDateChange: (newDate) => setState(() => _selectedDate = newDate),
      ),
    );
  }

  _showTask() {
    return Expanded(
      child: Obx(
        () {
          if (_taskController.taskList.isEmpty) {
            return _noTaskMsg();
          } else {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: _taskController.taskList.length,
                itemBuilder: (context, index) {
                  var task = _taskController.taskList[index];

                  print('task.date = ${task.date} ');
                  print(
                      'DateFormat.yMd().format(_selectedDate) = ${DateFormat.yMd().format(_selectedDate.add(Duration(days: 7)))} ');

                  // DateTime _dateNow=DateTime.parse(task.date!);
                  // print('_dateNow = $_dateNow');

                  if (task.repeat == 'Daily' ||
                      task.date == DateFormat.yMd().format(_selectedDate) ||
                      (task.repeat == 'Weekly' && _selectedDate.difference(DateFormat.yMd().parse(task.date!)).inDays % 7 == 0) ||
                      (task.repeat == 'Monthly' && _selectedDate.day == DateFormat.yMd().parse(task.date!).day))
                  {

                    DateTime date = DateFormat.jm().parse(task.startTime!);
                    String myTime = DateFormat('HH:mm').format(date);
                    print('myTime is = $myTime');
                    notifyHelper.scheduledNotification(
                      int.parse(myTime.toString().split(':')[0]),
                      int.parse(myTime.toString().split(':')[1]),
                      task,
                    );

                    return AnimationConfiguration.staggeredList(
                      position: index,
                      child: SlideAnimation(
                        duration: Duration(milliseconds: 700),
                        horizontalOffset: 300,
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () => showBottomSheet(context, task),
                            child: TaskTile(task),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                });
          }
        },
      ),
    );
  }

  showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 4),
          width: SizeConfig.screenWidth,
          height: SizeConfig.orientation == Orientation.landscape
              ? task.isCompleted == 1
                  ? SizeConfig.screenHeight * 0.6
                  : SizeConfig.screenHeight * 0.8
              : task.isCompleted == 1
                  ? SizeConfig.screenHeight * 0.30
                  : SizeConfig.screenHeight * 0.39,
          color: Get.isDarkMode ? darkHeaderClr : Colors.white,
          child: Column(
            children: [
              Flexible(
                child: Container(
                  height: 6,
                  width: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                          Get.isDarkMode ? Colors.grey[200] : Colors.grey[300]),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              task.isCompleted == 1
                  ? Container()
                  : ElevatedButtonForTheBottomSheet(
                      label: "task completed",
                      onPress: () {
                        NotifyHelper().cancelScheduledNotification(task);
                        _taskController.markTaskCompleted(task.id!);
                        Get.back();
                      },
                      color: primaryClr),
              ElevatedButtonForTheBottomSheet(
                  label: "delete task",
                  onPress: () {
                    NotifyHelper().cancelScheduledNotification(task);
                    _taskController.deleteTasks(task);
                    Get.back();
                  },
                  color: Colors.redAccent),
              Divider(
                height: 5.0,
              ),
              ElevatedButtonForTheBottomSheet(
                  label: "cancel",
                  onPress: () {
                    Get.back();
                  },
                  color: primaryClr),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButtonForTheBottomSheet(
      {required String label,
      required Function() onPress,
      required Color color,
      bool isClose = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4),
      height: 65,
      width: SizeConfig.screenWidth * 0.9,
      child: ElevatedButton(
        onPressed: onPress,
        child: Text(
          label,
          style: TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22), // <-- Radius
          ),
          primary: color,
        ),
      ),
    );
  }

  _noTaskMsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: Duration(seconds: 2),
          child: SingleChildScrollView(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              direction: SizeConfig.orientation == Orientation.landscape
                  ? Axis.horizontal
                  : Axis.vertical,
              children: [
                SizeConfig.orientation == Orientation.landscape
                    ? SizedBox(height: 6)
                    : SizedBox(height: 110),
                SvgPicture.asset('images/task.svg',
                    height: 90,
                    semanticsLabel: 'Task',
                    color: primaryClr.withOpacity(0.5)),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 10),
                  child: Text(
                      'You don\'t have any task yet !\n Add new tasks to make your daily routine',
                      style: subTitleStyle,
                      textAlign: TextAlign.center),
                ),
                // SizedBox(height: 500,)
              ],
            ),
          ),
        )
      ],
    );
  }
}
