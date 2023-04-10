// ignore_for_file: cast_nullable_to_non_nullable

import 'package:Prism/data/notifications/model/inAppNotifModel.dart';
import 'package:Prism/global/globals.dart' as globals;
import 'package:Prism/logger/logger.dart';
import 'package:Prism/main.dart' as main;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

final FirebaseFirestore databaseReference = FirebaseFirestore.instance;

Future<QuerySnapshot> getLastMonthNotifs(String modifier) async {
  return databaseReference
      .collection("notifications")
      .orderBy("createdAt", descending: true)
      .where("createdAt",
          isGreaterThan:
              DateTime.now().toUtc().subtract(const Duration(days: 30)))
      .where('modifier', isEqualTo: modifier)
      .get();
}

Future<QuerySnapshot> getLatestNotifs(String modifier) async {
  return databaseReference
      .collection("notifications")
      .orderBy("createdAt", descending: true)
      .where("createdAt", isGreaterThan: main.prefs.get('lastFetchTime'))
      .where('modifier', isEqualTo: modifier)
      .get();
}

Future<void> getNotifs() async {
  logger.d("Fetching notifs");
  final Box<InAppNotif> box = Hive.box('inAppNotifs');
  if (main.prefs.get('lastFetchTime') != null) {
    logger.d("Last fetch time ${main.prefs.get('lastFetchTime')}");
    if (globals.prismUser.premium == false) {
      getLatestNotifs('free').then((snap) {
        for (final doc in snap.docs) {
          // ignore: cast_nullable_to_non_nullable
          if ((doc.data() as Map<String, dynamic>)['modifier'] != '' || (doc.data() as Map<String, dynamic>)['modifier'] != null) {
            // ignore: cast_nullable_to_non_nullable
            box.add(InAppNotif.fromSnapshot(doc.data() as Map<String, dynamic>));
          }
        }
      });
    }
    if (globals.prismUser.premium == true) {
      getLatestNotifs('premium').then((snap) {
        for (final doc in snap.docs) {
          if ((doc.data() as Map<String, dynamic>)['modifier'] != '' || (doc.data() as Map<String, dynamic>)['modifier'] != null) {
            box.add(InAppNotif.fromSnapshot(doc.data() as Map<String, dynamic>));
          }
        }
      });
    }
    getLatestNotifs('all').then((snap) {
      for (final doc in snap.docs) {
        if ((doc.data() as Map<String, dynamic>)['modifier'] != '' || (doc.data() as Map<String, dynamic>)['modifier'] != null) {
          box.add(InAppNotif.fromSnapshot(doc.data() as Map<String, dynamic>));
        }
      }
    });
    getLatestNotifs(globals.currentAppVersion).then((snap) {
      for (final doc in snap.docs) {
        if ((doc.data() as Map<String, dynamic>)['modifier'] != '' || (doc.data() as Map<String, dynamic>)['modifier'] != null) {
          box.add(InAppNotif.fromSnapshot(doc.data() as Map<String, dynamic>));
        }
      }
    });
    getLatestNotifs(globals.prismUser.email).then((snap) {
      for (final doc in snap.docs) {
        if ((doc.data() as Map<String, dynamic>)['modifier'] != '' || (doc.data() as Map<String, dynamic>)['modifier'] != null) {
          box.add(InAppNotif.fromSnapshot(doc.data() as Map<String, dynamic>));
        }
      }
    });
    main.prefs.put('lastFetchTime', DateTime.now());
  } else {
    logger.d("Fetching for first time");
    box.clear();
    if (globals.prismUser.premium == false) {
      getLastMonthNotifs('free').then((snap) {
        for (final doc in snap.docs) {
          if ((doc.data() as Map<String, dynamic>)['modifier'] != '' || (doc.data() as Map<String, dynamic>)['modifier'] != null) {
            box.add(InAppNotif.fromSnapshot(doc.data() as Map<String, dynamic>));
          }
        }
      });
    }
    if (globals.prismUser.premium == true) {
      getLastMonthNotifs('premium').then((snap) {
        for (final doc in snap.docs) {
          if ((doc.data() as Map<String, dynamic>)['modifier'] != '' || (doc.data() as Map<String, dynamic>)['modifier'] != null) {
            box.add(InAppNotif.fromSnapshot(doc.data() as Map<String, dynamic>));
          }
        }
      });
    }
    getLastMonthNotifs('all').then((snap) {
      for (final doc in snap.docs) {
        if ((doc.data() as Map<String, dynamic>)['modifier'] != '' || (doc.data() as Map<String, dynamic>)['modifier'] != null) {
          box.add(InAppNotif.fromSnapshot(doc.data() as Map<String, dynamic>));
        }
      }
    });
    getLastMonthNotifs(globals.currentAppVersion).then((snap) {
      for (final doc in snap.docs) {
        if ((doc.data() as Map<String, dynamic>)['modifier'] != '' || (doc.data() as Map<String, dynamic>)['modifier'] != null) {
          box.add(InAppNotif.fromSnapshot(doc.data() as Map<String, dynamic>));
        }
      }
    });
    getLastMonthNotifs(globals.prismUser.email).then((snap) {
      for (final doc in snap.docs) {
        if ((doc.data() as Map<String, dynamic>)['modifier'] != '' || (doc.data() as Map<String, dynamic>)['modifier'] != null) {
          box.add(InAppNotif.fromSnapshot(doc.data() as Map<String, dynamic>));
        }
      }
    });
    main.prefs.put('lastFetchTime', DateTime.now());
  }
}
