import 'package:doer/pages/dashboard_page.dart';
import 'package:doer/pages/logout.dart';
import 'package:doer/pages/notification.dart';
import 'package:doer/pages/profile.dart';
import 'package:doer/pages/projects_list.dart';
import 'package:doer/help/help_page.dart';
import 'package:doer/rera/rera_fill.dart';

typedef T Constructor<T>();

final Map<String, Constructor<Object>> _constructors = <String, Constructor<Object>>{};

void register<T>(Constructor<T> constructor) {
  _constructors[T.toString()] = constructor as Constructor<Object>;
}

class ClassBuilder {
  static void registerClasses(userToken) {
    register<DashboardPage>(() => DashboardPage(userToken));
    register<ProfilePage>(() => ProfilePage(userToken,2));
    register<HelpPage>(() => HelpPage(userToken,2));
   // register<NotificationPage>(() => NotificationPage(userToken,2));
    register<LogoutPage>(() => LogoutPage());
  }

  static dynamic fromString(String type) {
    if (_constructors[type] != null) return _constructors[type]!();
  }
}
