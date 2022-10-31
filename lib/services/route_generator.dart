import 'package:flutter/material.dart';
import 'package:scms/ui/Home/v/dashboard_page.dart';
import 'package:scms/ui/Home/v/home_page.dart';
import 'package:scms/ui/Login/v/login_page.dart';
import 'package:scms/ui/Login/v/register_page.dart';
import 'package:scms/ui/PersonnelPerformance/m/performance_response.dart';
import '../ui/Equipment/m/equipment_response.dart';
import '../ui/Equipment/v/add_schedule_page.dart';
import '../ui/Equipment/v/equipment_details.dart';
import '../ui/Equipment/v/equipment_list_page.dart';
import '../ui/Equipment/v/equipment_page.dart';
import '../ui/Equipment/v/equipment_single_details.dart';
import '../ui/Gallery/v/gallery_page.dart';
import '../ui/Gallery/v/video_app.dart';
import '../ui/PersonnelPerformance/v/add_update_personnel_performance_page.dart';
import '../ui/PersonnelPerformance/v/performance_details_page.dart';
import '../ui/PersonnelPerformance/v/personnel_performance_page.dart';
import '../ui/ProjectList/v/project_list_page.dart';
import '../ui/Splash/v/splash_page.dart';
import '../ui/Stock/c/stock_controller.dart';
import '../ui/Stock/v/add_stock_page.dart';
import '../ui/Stock/v/stock_management_page.dart';
import '../ui/Task/m/task_response.dart';
import '../ui/Task/v/task_page.dart';
import '../ui/Task/v/update_task_details_page.dart';
import '../ui/Traning/v/traning_page.dart';
import '../ui/Trials/v/add_trials_page.dart';
import '../ui/Trials/v/trials_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(builder: (_) => SplashPage());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());
     case '/register':
        return MaterialPageRoute(builder: (_) => RegisterPage());
    case '/project_list':
        return MaterialPageRoute(builder: (_) => ProjectListPage());
    case '/home':
        return MaterialPageRoute(builder: (_) => DashboardPage());
    case '/task':
        return MaterialPageRoute(builder: (_) => TaskPage());
    case '/task_details':
        return MaterialPageRoute(builder: (_) => UpdateTaskDetailsPage(args as TaskList));
   /* case '/personnel_performance':
        return MaterialPageRoute(builder: (_) => PersonnelPerformancePage());
   */ case '/add_personnel_performance':
        return MaterialPageRoute(builder: (_) => AddUpdatePersonnelPerformancePage());
    case '/update_personnel_performance':
        return MaterialPageRoute(builder: (_) => AddUpdatePersonnelPerformancePage(response: args as Performance,));
    case '/details_personnel_performance':
        return MaterialPageRoute(builder: (_) => PerformanceDetailsPage(args as Performance,));
    case '/stock':
        return MaterialPageRoute(builder: (_) => StockManagementPage());
    case '/add_stock':
        return MaterialPageRoute(builder: (_) => AddStockPage(args as StockController));
     case '/training':
        return MaterialPageRoute(builder: (_) => TraningPage());
    case '/trials':
        return MaterialPageRoute(builder: (_) => TrialsPage());
    case '/add_trials':
        return MaterialPageRoute(builder: (_) => AddTrialsPage());
    case '/gallery':
        return MaterialPageRoute(builder: (_) => GalleryPage());
    case '/video':
        return MaterialPageRoute(builder: (_) => VideoApp(args as String));
   /* case '/equipment':
        return MaterialPageRoute(builder: (_) => EquipmentPage());
   */ case '/equipment_list':
        return MaterialPageRoute(builder: (_) => EquipmentListPage());
    case '/equipment_details':
        return MaterialPageRoute(builder: (_) => EquipmentDetails());
    case '/equipment_single_details':
        return MaterialPageRoute(builder: (_) => EquipmentSingleDetails(args as Equipment));
    case '/add_shedule_maintance':
        return MaterialPageRoute(builder: (_) => AddSchedulePage());
    }
    return MaterialPageRoute(builder: (_) => SplashPage());
  }
}
