import 'package:flutter/material.dart';
import 'package:quria/data/models/helpers/builderHelper.model.dart';
import 'package:quria/data/models/helpers/builderRecapHelper.model.dart';
import 'package:quria/data/models/helpers/classItemChoiceHelper.model.dart';
import 'package:quria/data/models/helpers/inspectData.model.dart';
import 'package:quria/data/models/helpers/inspectSubclassHelper.model.dart';
import 'package:quria/data/models/helpers/modHelper.model.dart';
import 'package:quria/data/models/helpers/statsFilterHelper.model.dart';
import 'package:quria/data/models/helpers/subclassHelper.model.dart';
import 'package:quria/data/models/helpers/subclassModHelper.model.dart';
import 'package:quria/presentation/screens/builder/build_recap/builder_recap_page.dart';
import 'package:quria/presentation/screens/builder/builder_results/builder_results_page.dart';
import 'package:quria/presentation/screens/builder/class_item_choice/class_item_choice_page.dart';
import 'package:quria/presentation/screens/builder/exotic/exotic_page.dart';
import 'package:quria/presentation/screens/builder/mods/mods_page.dart';
import 'package:quria/presentation/screens/builder/stats_filter/stats_filter_page.dart';
import 'package:quria/presentation/screens/builder/subclass/subclass_page.dart';
import 'package:quria/presentation/screens/builder/subclass_mods/subclass_mods_page.dart';
import 'package:quria/presentation/screens/collection/collection_item/collection_item_page.dart';
import 'package:quria/presentation/screens/collection/collection_weapon_page.dart';

import 'package:quria/presentation/screens/inspect/inspect_mobile.dart';
import 'package:quria/presentation/screens/inspect_subclass/inspect_subclass_page.dart';
import 'package:quria/presentation/screens/login.dart';
import 'package:quria/presentation/screens/profile/profile_page.dart';
import 'package:quria/presentation/screens/settings/settings_page.dart';
import 'package:quria/presentation/screens/vault/vault_page.dart';
import 'package:quria/presentation/var/routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case routeLogin:
        return MaterialPageRoute(builder: (_) => LoginWidget());
      case routeProfile:
        return MaterialPageRoute(builder: (_) => const ProfileWidget());
      case routeFilter:
        final StatsFilterHelper data = settings.arguments as StatsFilterHelper;
        return MaterialPageRoute(builder: (_) => StatsFilterPage(data: data));
      case routeBuilder:
        final BuilderPreparation data =
            settings.arguments as BuilderPreparation;
        return MaterialPageRoute(
            builder: (_) => BuilderResultsPage(data: data));
      case routeBuilderRecap:
        final BuilderRecapHelper data =
            settings.arguments as BuilderRecapHelper;
        return MaterialPageRoute(builder: (_) => BuilderRecapPage(data: data));
      case routeInspectMobile:
        final InspectData data = settings.arguments as InspectData;
        return MaterialPageRoute(builder: (_) => MobileInspect(data: data));
      case routeExotic:
        return MaterialPageRoute(builder: (_) => const ExoticWidget());
      case routeSubclass:
        final SubclassHelper data = settings.arguments as SubclassHelper;
        return MaterialPageRoute(
            builder: (_) => SubclassPage(
                  data: data,
                ));
      case routeClassItemChoice:
        final ClassItemChoiceHelper data =
            settings.arguments as ClassItemChoiceHelper;
        return MaterialPageRoute(
            builder: (_) => ClassItemChoicePage(
                  data: data,
                ));
      case routeMod:
        final ModHelper data = settings.arguments as ModHelper;
        return MaterialPageRoute(
            builder: (_) => ModsPage(
                  data: data,
                ));
      case routeVault:
        return MaterialPageRoute(builder: (_) => const VaultPage());
      case routeCollection:
        return MaterialPageRoute(builder: (_) => const CollectionWeaponPage());
      case routeSubclassMod:
        final SubclassModHelper data = settings.arguments as SubclassModHelper;
        return MaterialPageRoute(builder: (_) => SubclassModsPage(data: data));
      case routeInspectSubclass:
        final InspectSubclassHelper data =
            settings.arguments as InspectSubclassHelper;
        return MaterialPageRoute(
            builder: (_) => InspectSubclassPage(data: data));
      case routePageSettings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case routeCollectionItem:
        final int data = settings.arguments as int;
        return MaterialPageRoute(
            builder: (_) => CollectionItemPage(itemHash: data));
      default:
        return MaterialPageRoute(builder: (_) => LoginWidget());
    }
  }
}
