// ignore_for_file: avoid_dynamic_calls

import 'package:Prism/data/categories/categories.dart' as listCategory;
import 'package:Prism/data/prism/provider/prismWithoutProvider.dart' as data;
import 'package:Prism/data/wallhaven/provider/wallhavenWithoutProvider.dart'
    as wdata;
import 'package:Prism/data/pexels/provider/pexelsWithoutProvider.dart' as pdata;
import 'package:Prism/global/categoryMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:Prism/main.dart' as main;

final List choices = listCategory.categories
    .map(
      (category) => CategoryMenu(
        name: category['name'].toString(),
        provider: category['provider'].toString(),
        image: category['image'].toString(),
      ),
    )
    .toList();

class CategorySupplier extends ChangeNotifier {
  // ignore: avoid_dynamic_calls

  late Future<List?> wallpaperFutureRefresh =
      listCategory.categories1.elementAt(1).type == 'non-search'
          ? listCategory.categories1.elementAt(1).name == 'Popular'
              ? wdata.getData("r", main.prefs.get('WHcategories') as int?,
                  main.prefs.get('WHpurity') as int?)
              : listCategory.categories1.elementAt(1).name == 'Curated'
                  ? pdata.getDataP("r")
                  : listCategory.categories1.elementAt(1).name == 'Community'
                      ? data.getPrismWalls()
                      : data.getPrismWalls()
          : data.getPrismWalls();

  late CategoryMenu selectedChoice = listCategory.categories1.elementAt(1);
  void changeSelectedChoice(CategoryMenu choice) {
    selectedChoice = choice;
    notifyListeners();
  }

  String? get getCurrentChoice {
    return selectedChoice.name;
  }

  Future<List> changeWallpaperFuture(CategoryMenu choice, String mode) async {
    for (final category in listCategory.categories1) {
      if (category.name == choice.name) {
        if (category.type == 'search') {
          if (category.provider == "WallHaven") {
            wallpaperFutureRefresh = wdata.categoryDataFetcher(
                category.name.toString(),
                mode,
                main.prefs.get('WHcategories') as int?,
                main.prefs.get('WHpurity') as int?);
          } else if (category.provider == "Pexels") {
            wallpaperFutureRefresh =
                pdata.categoryDataFetcherP(category.name.toString(), mode);
          }
        } else if (category.type == 'non-search') {
          if (category.name == 'Community') {
            wallpaperFutureRefresh = data.getPrismWalls();
          } else if (category.name == 'Curated') {
            wallpaperFutureRefresh = pdata.getDataP(mode);
          } else if (category.name == 'Popular') {
            wallpaperFutureRefresh = wdata.getData(
                mode,
                main.prefs.get('WHcategories') as int?,
                main.prefs.get('WHpurity') as int?);
          }
        }
      }
    }
    notifyListeners();
    return [];
  }
}
