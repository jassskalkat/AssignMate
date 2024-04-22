import 'package:assign_mate/assignments/assignments_page.dart';
import 'package:assign_mate/assignments/edit_assignemnt/edit_assignment_page.dart';
import 'package:assign_mate/assignments/reminder/reminder_page.dart';
import 'package:assign_mate/group_chat/chat/group_chat_page.dart';
import 'package:assign_mate/group_chat/chat/group_info.dart';
import 'package:assign_mate/group_chat/chat/profiles_list/profiles_list_page.dart';
import 'package:assign_mate/group_chat/group_page.dart';
import 'package:assign_mate/profile/profile_page.dart';
import 'package:assign_mate/routes/unknown_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../assignments/assignment_view/assignment_page.dart';
import '../assignments/assignment_view/view_outline.dart';
import '../assignments/new_entry/new_entry_page.dart';
import '../auth/authentication_page.dart';
import '../auth/login/login_page.dart';
import '../auth/reset_password/reset_password_page.dart';
import '../auth/sign_up/signup_page.dart';
import '../dm/chat/chat_page.dart';
import '../dm/dm_page.dart';
import '../dm/info.dart';
import '../home/home_page.dart';
import '../profile/editing_profile_view.dart';

class RouteGenerator {
  static const String homePage = '/';
  static const String assignmentPage = '/assignmentPage';
  static const String dmPage = '/DMPage';
  static const String groupsPage = '/groupsPage';
  static const String profilePage = '/profilePage';
  static const String loginPage = '/loginPage';
  static const String authPage = '/AuthenticationPage';
  static const String signUpPage = '/signUpPage';
  static const String passwordPage = '/resetPasswordPage';
  static const String dmChatPage = '/dmChatPage';
  static const String editProfilePage = '/profileEditingPage';
  static const String groupChatPage = '/groupChatPage';
  static const String profileListPage = '/profileListPage';
  static const String entryPage = '/entryPage';
  static const String newEntryPage = '/newEntryPage';
  static const String pdfViewer = '/pdfViewer';
  static const String reminderPage = '/reminderPage';
  static const String editAssignmentPage = '/editAssignmentPage';



  //private constructor
  RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePage:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
        );
      case assignmentPage:
        return MaterialPageRoute(
          builder: (_) => const AssignmentsPage(),
        );
      case loginPage:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );
      case authPage:
        return MaterialPageRoute(
          builder: (_) => AuthenticationPage(),
        );
      case signUpPage:
        return MaterialPageRoute(
          builder: (_) => const SignUpPage(),
        );
      case passwordPage:
        return MaterialPageRoute(
          builder: (_) => const ResetPasswordPage(),
        );
      case dmPage:
        return MaterialPageRoute(
          builder: (_) => const DMPage(),
        );
      case dmChatPage:
        Info info = settings.arguments as Info;
        return MaterialPageRoute(
          builder: (_) => ChatPage(info: info),
        );
      case profilePage:
        String username = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ProfilePage(username: username),
        );
      case editProfilePage:
        final data = settings.arguments as  Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => EditingProfileView(data: data),
        );
      case groupsPage:
        return MaterialPageRoute(
          builder: (_) => GroupPage(),
        );
      case groupChatPage:
        GroupInfo info = settings.arguments as GroupInfo;
        return MaterialPageRoute(
          builder: (_) => GroupChatPage(info: info),
        );
      case profileListPage:
        String groupID = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ProfilesListPage(groupID: groupID),
        );
      case entryPage:
        String assignmentID = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => AssignmentPage(assignmentID: assignmentID),
        );
      case newEntryPage:
        return MaterialPageRoute(
        builder: (_) => NewEntryPage(),
        );
      case pdfViewer:
        String url = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ViewOutline(url: url,),
        );
      case reminderPage:
        List<String> assignments = settings.arguments as List<String>;
        return MaterialPageRoute(
          builder: (_) => ReminderPage(assignments: assignments),
        );
      case editAssignmentPage:
        String assignmentID = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => EditAssignmentPage(assignmentID: assignmentID),
        );

    }
    if (kDebugMode) {
      return MaterialPageRoute(builder: (context) => UnknownScreen());
    } else {
      return MaterialPageRoute(builder: (context) => const HomePage());
    }
  }
}