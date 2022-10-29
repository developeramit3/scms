import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:scms/services/route_generator.dart';
import 'package:scms/services/session_repo.dart';
import 'package:scms/themes/theme_notifier.dart';
import 'Utils/tools.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting();
  runApp(ChangeNotifierProvider<ThemeNotifier>(
    create: (_) => new ThemeNotifier(),
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(newLocale);
  }

  @override
  State<StatefulWidget> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() async {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) =>MaterialApp(
          title: "SCMS",
          debugShowCheckedModeBanner: false,
          initialRoute: '/splash',
          locale: _locale,
          navigatorKey: Tools.navigatorKey,
          onGenerateRoute: RouteGenerator.generateRoute,
          theme: theme.getTheme(),
          supportedLocales:S.delegate.supportedLocales,
          localizationsDelegates: [
            S.delegate,
            // GlobalMaterialLocalizations.delegate,
            // GlobalWidgetsLocalizations.delegate,
            //  GlobalWidgetsLocalizations.delegate,
          ],
        )
    );
  }
}

