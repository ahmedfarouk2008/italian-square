import 'package:flutter/material.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/services_directory_screen/services_directory_screen.dart';
import '../presentation/dashboard_screen/dashboard_screen.dart';
import '../presentation/registration_screen/registration_screen.dart';
import '../presentation/complaint_submission_screen/complaint_submission_screen.dart';
import '../presentation/profile_management_screen/profile_management_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/login-screen';
  static const String loginScreen = '/login-screen';
  static const String servicesDirectoryScreen = '/services-directory-screen';
  static const String dashboardScreen = '/dashboard-screen';
  static const String registrationScreen = '/registration-screen';
  static const String complaintSubmissionScreen =
      '/complaint-submission-screen';
  static const String profileManagementScreen = '/profile-management-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => LoginScreen(),
    loginScreen: (context) => LoginScreen(),
    servicesDirectoryScreen: (context) => ServicesDirectoryScreen(),
    dashboardScreen: (context) => DashboardScreen(),
    registrationScreen: (context) => RegistrationScreen(),
    complaintSubmissionScreen: (context) => ComplaintSubmissionScreen(),
    profileManagementScreen: (context) => ProfileManagementScreen(),
    // TODO: Add your other routes here
  };
}
