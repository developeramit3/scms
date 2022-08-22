import 'package:flutter/material.dart';
import 'package:scms/Utils/theme_color.dart';

bool haveOverlay = false;

class LockOverlay {
  static LockOverlay? _instance;
  final ValueNotifier<OverlayEntry?> _overlayEntry = ValueNotifier(null);

  LockOverlay._internal() {
    _instance = this;
  }

  factory LockOverlay() => _instance ?? LockOverlay._internal();

  void showClassicLoadingOverlay(context,{bool buildAfterRebuild: false}) {
    if (haveOverlay) return;
    //final String myKey = _uniqueKey;
    if (buildAfterRebuild) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        showClassicLoadingOverlay(context);
      });
      return;
    }
    OverlayState? overlayState =Overlay.of(context);
    if (overlayState == null) return;

    final _myoverlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Stack(
          children: [
            Container(
              color: Colors.grey.shade200.withOpacity(.5),
            ),
            Center(
              child:  Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade400,
                      spreadRadius: 5,
                      blurRadius: 5
                    ),
                  ]
                ),
                padding: EdgeInsets.all(5),
                child: Stack(
                  children: [
                    SizedBox(height: 40,width: 40,child: CircularProgressIndicator(color: ThemeColor.colorPrimary,strokeWidth: 2),),
                    // Center(child: SvgPicture.asset('assets/svg/icon_black.svg',width: 20,),)
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
    _overlayEntry.value = _myoverlayEntry;

    overlayState.insert(_overlayEntry.value!);
    haveOverlay = true;
  }

  closeOverlay() {
    if (_overlayEntry.value == null) return;
    haveOverlay = false;
    _overlayEntry.value!.remove();
    _overlayEntry.value = null;
  }
}
