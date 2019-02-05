import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'src/logic/background_polling.dart';
import 'src/logic/cruise.dart';
import 'src/logic/disk_store.dart';
import 'src/logic/notifications.dart';
import 'src/network/rest.dart';
import 'src/views/calendar.dart';
import 'src/views/comms.dart';
import 'src/views/create_account.dart';
import 'src/views/deck_plans.dart';
import 'src/views/karaoke.dart';
import 'src/views/profile.dart';
import 'src/views/settings.dart';
import 'src/views/stream.dart';
import 'src/views/user.dart';
import 'src/widgets.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

void main() {
  print('CruiseMonkey has started');
  RestTwitarrConfiguration.register();
  final CruiseModel model = CruiseModel(
    initialTwitarrConfiguration: kDefaultTwitarr,
    store: DiskDataStore(),
    onError: _handleError,
    onCheckForMessages: checkForMessages,
  );
  runApp(CruiseMonkeyApp(cruiseModel: model, scaffoldKey: scaffoldKey));
  if (Platform.isAndroid)
    runBackground();
  Notifications.instance.then((Notifications notifications) {
    notifications.onTap = (String threadId) async {
      print('Received tap to view: $threadId');
      await model.loggedIn;
      Navigator.popUntil(scaffoldKey.currentContext, ModalRoute.withName('/'));
      CommsView.showSeamailThread(scaffoldKey.currentContext, model.seamail.threadById(threadId));
    };
  });
}

void _handleError(String message) {
  final AnimationController controller = AnimationController(
    duration: const Duration(seconds: 4),
    vsync: const PermanentTickerProvider(),
  );
  final Animation<double> opacity = controller.drive(TweenSequence<double>(
    <TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.ease)),
        weight: 500,
      ),
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(1.0),
        weight: 2500,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.ease)),
        weight: 2000,
      ),
    ],
  ));
  final Animation<double> position = controller.drive(
    Tween<double>(begin: 228.0, end: 136.0).chain(CurveTween(curve: Curves.easeOutBack)),
  );
  final OverlayEntry entry = OverlayEntry(
    builder: (BuildContext context) {
      final ThemeData theme = Theme.of(context);
      return Positioned(
        left: 24.0,
        right: 24.0,
        bottom: position.value,
        child: IgnorePointer(
          child: FadeTransition(
            opacity: opacity,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: ShapeDecoration(
                color: Colors.grey[800],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                shadows: kElevationToShadow[4],
              ),
              child: Text(message, style: theme.textTheme.caption.copyWith(color: Colors.white)),
            ),
          ),
        ),
      );
    },
  );
  final OverlayState overlay = Overlay.of(scaffoldKey.currentContext);
  controller.addListener(() {
    if (overlay.mounted)
      entry.markNeedsBuild();
  });
  controller.addStatusListener((AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (overlay.mounted)
        entry.remove();
      controller.dispose();
    }
  });
  overlay.insert(entry);
  controller.forward();
}

class PermanentTickerProvider extends TickerProvider {
  const PermanentTickerProvider();

  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}

class CruiseMonkeyApp extends StatelessWidget {
  const CruiseMonkeyApp({
    Key key,
    this.cruiseModel,
    this.scaffoldKey,
  }) : super(key: key);

  final CruiseModel cruiseModel;

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Cruise(
      cruiseModel: cruiseModel,
      child: Now(
        period: const Duration(seconds: 15),
        child: CruiseMonkeyHome(scaffoldKey: scaffoldKey),
      ),
    );
  }
}

class CruiseMonkeyHome extends StatelessWidget {
  const CruiseMonkeyHome({
    Key key,
    this.scaffoldKey,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  static const List<View> pages = <View>[
    UserView(),
    CalendarView(),
    CommsView(),
    DeckPlanView(),
    KaraokeView(),
  ];

  Widget buildTab(BuildContext context, View page, { EdgeInsets iconPadding = EdgeInsets.zero }) {
    return Tab(
      icon: Padding(padding: iconPadding, child: page.buildTabIcon(context)),
      text: (page.buildTabLabel(context) as Text).data,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CruiseMonkey',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue[900],
        accentColor: Colors.greenAccent,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: DefaultTabController(
        length: pages.length,
        child: Builder(
          builder: (BuildContext context) {
            final TabController tabController = DefaultTabController.of(context);
            final ThemeData theme = Theme.of(context);
            return AnimatedBuilder(
              animation: tabController,
              builder: (BuildContext context, Widget child) {
                return Scaffold(
                  key: scaffoldKey,
                  floatingActionButton: pages[tabController.index].buildFab(context),
                  floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
                  resizeToAvoidBottomInset: false,
                  body: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      const double bottomPadding = 50.0;
                      final double height = constraints.maxHeight + bottomPadding;
                      final MediaQueryData metrics = MediaQuery.of(context);
                      return OverflowBox(
                        minWidth: constraints.maxWidth,
                        maxWidth: constraints.maxWidth,
                        minHeight: height,
                        maxHeight: height,
                        alignment: Alignment.topCenter,
                        child: MediaQuery(
                          data: metrics.copyWith(padding: metrics.padding.copyWith(bottom: bottomPadding)),
                          child: TabBarView(
                            children: pages,
                          ),
                        ),
                      );
                    },
                  ),
                  bottomNavigationBar: BottomAppBar(
                    color: theme.primaryColor,
                    shape: const WaveShape(),
                    elevation: 4.0, // TODO(ianh): figure out why this has no effect
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Center(
                        heightFactor: 1.0,
                        child: TabBar(
                          isScrollable: true,
                          indicator: BoxDecoration(
                            color: const Color(0x10FFFFFF),
                            border: Border(
                              top: BorderSide(
                                color: theme.accentColor,
                                width: 10.0,
                              ),
                            ),
                          ),
                          tabs: pages.map<Widget>((View page) => buildTab(context, page, iconPadding: const EdgeInsets.only(top: 8.0))).toList(),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      routes: <String, WidgetBuilder>{
        '/profile': (BuildContext context) => const Profile(),
        '/create_account': (BuildContext context) => const CreateAccount(),
        '/settings': (BuildContext context) => const Settings(),
        '/twitarr': (BuildContext context) => const TweetStreamView(),
      },
    );
  }
}

class WaveShape extends NotchedShape {
  const WaveShape();

  @override
  Path getOuterPath(Rect host, Rect guest) {
    const double waveDiameter = 50.0;
    const double waveHeight = 13.0;
    const double waveWidth = 43.0;
    
    final double phaseOffset = ((host.width - waveWidth) / 2.0) % waveWidth;

    final Path circles = Path();
    double left = host.left - phaseOffset;
    while (left < host.right) {
      circles.addOval(
        Rect.fromCircle(
          center: Offset(left + waveWidth / 2.0, host.top + waveHeight - waveDiameter / 2.0),
          radius: waveDiameter / 2.0,
        ),
      );
      left += waveWidth;
    }
    final Path waves = Path.combine(PathOperation.difference, Path()..addRect(host), circles);

    if (guest != null)
      return Path.combine(PathOperation.difference, waves, Path()..addOval(guest.inflate(guest.width * 0.05)));
    return waves;
  }
}
