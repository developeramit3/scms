import 'package:flutter/material.dart';
import 'package:scms/ui/Equipment/v/equipment_page.dart';
import 'package:scms/ui/Gallery/v/gallery_page.dart';
import 'package:scms/ui/Home/v/home_page.dart';
import 'package:scms/ui/PersonnelPerformance/v/personnel_performance_page.dart';
import 'package:scms/ui/Trials/v/trials_page.dart';

import '../../../generated/l10n.dart';
import '../../../services/session_repo.dart';
import '../../../widgets/confirm_dailog_widget.dart';
import '../../../widgets/sub_txt_widget.dart';
import '../../Stock/v/stock_management_page.dart';
import '../../Traning/v/traning_page.dart';
typedef callback=Function(
  Widget child,
String tilte,
);
class DrawerWidget extends StatelessWidget {
callback? onTap;

DrawerWidget({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      alignment: AlignmentDirectional.center,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(
                Icons.home_outlined,
                color: Colors.white,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
              title: SubTxtWidget(
                'Home',
                color: Colors.white,
                fontSize: 16,
              ),
              onTap: (){
                Navigator.pop(context);
                onTap!.call(HomePage(onTap!),"");
              },
            ),
            const Divider(
              height: 1,
              color: Colors.white,
            ),
            ListTile(
              leading: Image.asset(
                "assets/img/proj_ico.png",
                height: 25,
                width: 30,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
              title: SubTxtWidget(
                'Projects',
                color: Colors.white,
                fontSize: 18,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            const Divider(
              height: 1,
              color: Colors.white,
            ),
            ListTile(
              leading: Image.asset(
                "assets/img/person_ico.png",
                height: 25,
                width: 30,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
              title: SubTxtWidget(
                'Personnel Performance',
                color: Colors.white,
                fontSize: 18,
              ),
              onTap: () {
                Navigator.pop(context);
                onTap!.call(PersonnelPerformancePage(onTap!),"Personnel Performance");
              },
            ),
            Divider(height: 1,color: Colors.white,),
            ListTile(
              leading: Image.asset("assets/img/eq_ico2.png",height: 25,width: 30,),
              contentPadding: const EdgeInsets.symmetric(vertical: 1,horizontal: 10),
              title: SubTxtWidget('Equipment Performance',color: Colors.white,fontSize: 18,),
              onTap: () {
                Navigator.pop(context);
                onTap!.call(EquipmentPage(onTap!),"Equipment");
              },
            ),
            Divider(height: 1,color: Colors.white,),
            ListTile(
              leading: Image.asset(
                "assets/img/mat_ico.png",
                height: 25,
                width: 30,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
              title: SubTxtWidget(
                'Stock Management',
                color: Colors.white,
                fontSize: 18,
              ),
              onTap: () {
                Navigator.pop(context);
                onTap!.call(StockManagementPage(),"Stock Management");
              },
            ),
            Divider(height: 1,color: Colors.white,),
            ListTile(
              leading: const Icon(
                Icons.bug_report,
                color: Colors.white,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
              title: SubTxtWidget(
                'Testing',
                color: Colors.white,
                fontSize: 18,
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigator.pushNamed(context, '/training');
              },
            ),
            Divider(height: 1,color: Colors.white,),
            ListTile(
              leading: const Icon(
                Icons.school,
                color: Colors.white,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
              title: SubTxtWidget(
                'Training',
                color: Colors.white,
                fontSize: 18,
              ),
              onTap: () {
                Navigator.pop(context);
                onTap!.call(TraningPage(),"Training");
              },
            ),
            Divider(height: 1,color: Colors.white,),
            ListTile(
              leading: const Icon(
                Icons.checklist,
                color: Colors.white,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
              title: SubTxtWidget(
                'Trials',
                color: Colors.white,
                fontSize: 18,
              ),
              onTap: () {
                Navigator.pop(context);
                onTap!.call(TrialsPage(),"Trials");
              },
            ),
            Divider(height: 1,color: Colors.white,),
            ListTile(
              leading: const Icon(
                Icons.image_outlined,
                color: Colors.white,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
              title: SubTxtWidget(
                'Gallery',
                color: Colors.white,
                fontSize: 18,
              ),
              onTap: () {
                Navigator.pop(context);
                onTap!.call(GalleryPage(),"Gallery");
              },
            ),
            const Divider(
              height: 1,
              color: Colors.white,
            ),
            ListTile(
              leading: const Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
              title: SubTxtWidget(
                'Logout',
                color: Colors.white,
                fontSize: 18,
              ),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (ctxt) => ConfirmDailogWidget(
                      title: S.of(context).logout,
                      sub_title: S.of(context).areYouSureYou,
                      listener: () {
                        Logout();
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/login', (route) => false);
                      },
                    ));
              },
            ),
            const Divider(
              height: 1,
              color: Colors.white,
            ),

          ],
        ),
      ),
    );
  }
}