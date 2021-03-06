import 'package:ap_common/callback/general_callback.dart';
import 'package:ap_common/scaffold/course_scaffold.dart';
import 'package:ap_common/utils/ap_localizations.dart';
import 'package:ap_common_firebase/utils/firebase_analytics_utils.dart';
import 'package:flutter/material.dart';
import 'package:nkust_ap/api/helper.dart';
import 'package:nkust_ap/models/room_data.dart';
import 'package:nkust_ap/models/semester_data.dart';
import 'package:nkust_ap/widgets/semester_picker.dart';

class EmptyRoomPage extends StatefulWidget {
  final Room room;

  const EmptyRoomPage({
    Key key,
    @required this.room,
  }) : super(key: key);

  @override
  _EmptyRoomPageState createState() => _EmptyRoomPageState();
}

class _EmptyRoomPageState extends State<EmptyRoomPage> {
  final key = GlobalKey<SemesterPickerState>();

  ApLocalizations ap;

  CourseState state = CourseState.loading;

  Semester selectSemester;
  SemesterData semesterData;

  CourseData courseData;

  String customStateHint;

  @override
  void initState() {
    FirebaseAnalyticsUtils.instance.setCurrentScreen(
      "RoomCoursePage",
      "room_course_page.dart",
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ap = ApLocalizations.of(context);
    return CourseScaffold(
      title: '${ap.classroomCourseTableSearch} - ${widget.room.name}',
      state: state,
      courseData: courseData,
      customStateHint: customStateHint,
      enableNotifyControl: false,
      itemPicker: SemesterPicker(
        key: key,
        onSelect: (semester, index) {
          setState(() {
            selectSemester = semester;
            state = CourseState.loading;
          });
          semesterData = key.currentState.semesterData;
          _getRoomCourseTable();
        },
      ),
      onRefresh: () {
        _getRoomCourseTable();
      },
      onSearchButtonClick: () {
        key.currentState.pickSemester();
      },
    );
  }

  _getRoomCourseTable() async {
    Helper.instance.getRoomCourseTables(
      roomId: widget.room.id,
      semester: selectSemester,
      callback: GeneralCallback(
        onSuccess: (CourseData data) {
          courseData = data;
          setState(() {
            state = CourseState.finish;
          });
        },
        onFailure: (DioError e) async {
          if (e.type != DioErrorType.CANCEL)
            setState(() {
              state = CourseState.custom;
              customStateHint = ApLocalizations.dioError(context, e);
            });
          if (e.hasResponse)
            FirebaseAnalyticsUtils.instance.logApiEvent(
                'getRoomCourseTables', e.response.statusCode,
                message: e.message);
        },
        onError: (GeneralResponse generalResponse) async {
          setState(() {
            state = CourseState.custom;
            customStateHint = generalResponse.getGeneralMessage(context);
          });
        },
      ),
    );
  }
}
