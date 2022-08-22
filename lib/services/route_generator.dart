import 'package:flutter/material.dart';
import 'package:scms/ui/Home/v/home_page.dart';
import 'package:scms/ui/Login/v/login_page.dart';
import 'package:scms/ui/PersonnelPerformance/m/performance_response.dart';
import '../ui/PersonnelPerformance/v/add_update_personnel_performance_page.dart';
import '../ui/PersonnelPerformance/v/performance_details_page.dart';
import '../ui/PersonnelPerformance/v/personnel_performance_page.dart';
import '../ui/ProjectList/v/project_list_page.dart';
import '../ui/Splash/v/splash_page.dart';
import '../ui/Stock/v/add_stock_page.dart';
import '../ui/Stock/v/stock_management_page.dart';
import '../ui/Task/v/task_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(builder: (_) => SplashPage());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());
    case '/project_list':
        return MaterialPageRoute(builder: (_) => ProjectListPage());
    case '/home':
        return MaterialPageRoute(builder: (_) => HomePage(args as Map));
    case '/task':
        return MaterialPageRoute(builder: (_) => TaskPage(args as String));
    case '/personnel_performance':
        return MaterialPageRoute(builder: (_) => PersonnelPerformancePage());
    case '/add_personnel_performance':
        return MaterialPageRoute(builder: (_) => AddUpdatePersonnelPerformancePage());
    case '/update_personnel_performance':
        return MaterialPageRoute(builder: (_) => AddUpdatePersonnelPerformancePage(response: args as PerformanceResponse,));
    case '/details_personnel_performance':
        return MaterialPageRoute(builder: (_) => PerformanceDetailsPage(args as PerformanceResponse,));
    case '/stock':
        return MaterialPageRoute(builder: (_) => StockManagementPage());
    case '/add_stock':
        return MaterialPageRoute(builder: (_) => AddStockPage());
    }
    return MaterialPageRoute(builder: (_) => SplashPage());
  }
}
