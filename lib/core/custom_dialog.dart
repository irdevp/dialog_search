import 'dart:async';

import 'package:flutter/material.dart';

import 'utils/constants_colors.dart';
import 'utils/dialog_search_style.dart';
import 'utils/remove_accents.dart';

class CustomDialog<T> extends StatelessWidget {
  final int? selectedValueIndex;
  final MapEntry<int, T>? selectedValue;
  final String Function(T item) attributeToSearch;
  final Widget Function(T item, bool selected, RichText customShowSearchMark)
      itemBuild;

  final Map<int, T> items;
  final List<MapEntry<int, T>> itemsDefault;
  final int delaySearch;
  final EdgeInsets headPadding;
  final Widget? headWidget;
  final Widget? footWidget;
  final InputDecoration? searchFieldDecoration;
  final DialogSearchStyle dialogStyle;

  //WEB
  final String? url;
  final bool isWeb;
  final Future<List<T>> Function(String search)? fromJson;
  final String Function(String search)? urlInSearch;

  final String hintText;
  final TextStyle hintStyle;

  CustomDialog({
    Key? key,
    this.selectedValueIndex,
    required this.items,
    required this.attributeToSearch,
    this.headWidget,
    this.headPadding = const EdgeInsets.fromLTRB(10, 15, 15, 5),
    this.delaySearch = 500,
    this.searchFieldDecoration,
    this.footWidget,
    this.url,
    required this.isWeb,
    this.fromJson,
    this.urlInSearch,
    required this.itemBuild,
    required this.dialogStyle,
    required this.hintText,
    required this.hintStyle,
  })  : itemsDefault = items.entries.toList(),
        selectedValue = selectedValueIndex != null
            ? items.entries.toList()[selectedValueIndex]
            : null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('RMK custom_dialog');

    final TextEditingController searchFieldController = TextEditingController();
    final ValueNotifier<bool> loadingSearch = ValueNotifier<bool>(false);
    final ValueNotifier<int> currentIndexIcon = ValueNotifier<int>(0);

    Timer? debounce;

    if (selectedValue != null && !isWeb) {
      itemsDefault
        ..removeAt(selectedValueIndex!)
        ..insert(0, selectedValue!);
    }

    final ValueNotifier<List<MapEntry<int, T>>> filterListItem =
        ValueNotifier<List<MapEntry<int, T>>>(itemsDefault);

    if (isWeb) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Material(
          type: MaterialType.card,
          color: dialogStyle.dialogFrameStyle.backgroundColor,
          borderRadius: dialogStyle.dialogFrameStyle.radius,
          elevation: dialogStyle.dialogFrameStyle.elevation,
          child: ClipRRect(
            borderRadius: dialogStyle.dialogFrameStyle.radius,
            child: Column(
              children: [
                headWidget ?? const SizedBox.shrink(),
                Container(
                  padding: headPadding,
                  color: dialogStyle.dialogFrameStyle.backgroundColor,
                  child: Hero(
                    tag: 'field_hero',
                    child: Material(
                      color: Colors.transparent,
                      child: TextField(
                        onChanged: (String value) {
                          if (value.isNotEmpty) {
                            currentIndexIcon.value = 1;
                          }
                          loadingSearch.value = true;
                          if (debounce?.isActive ?? false) {
                            debounce!.cancel();
                          }

                          debounce = Timer(const Duration(milliseconds: 200),
                              () async {
                            try {
                              filterListItem.value = (await fromJson!(value))
                                  .asMap()
                                  .entries
                                  .toList();
                            } catch (e) {
                              filterListItem.value = [];
                              debugPrint(e.toString());
                              rethrow;
                            }
                            loadingSearch.value = false;
                          });
                        },
                        decoration: searchFieldDecoration ??
                            InputDecoration(
                                prefixIcon: ValueListenableBuilder(
                                  valueListenable: loadingSearch,
                                  builder: (_, bool loading, child) {
                                    return SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: loading
                                          ? const Center(
                                              child: SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  color:
                                                      DefaultTheme.unfocusColor,
                                                  strokeWidth: 1.5,
                                                ),
                                              ),
                                            )
                                          : const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Icon(Icons.search)),
                                    );
                                  },
                                ),
                                hintText: selectedValue != null
                                    ? attributeToSearch(selectedValue!.value)
                                    : hintText,
                                hintStyle: hintStyle,
                                filled: true,
                                fillColor: Colors.white,
                                border: InputBorder.none,
                                suffixIcon: ValueListenableBuilder<int>(
                                    valueListenable: currentIndexIcon,
                                    builder: (_, int index, child) {
                                      return IconButton(
                                        icon: AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 350),
                                            transitionBuilder: (child, anim) =>
                                                RotationTransition(
                                                  turns: child.key ==
                                                          const ValueKey(
                                                              'icon1')
                                                      ? Tween<double>(
                                                              begin: 1,
                                                              end: 0.75)
                                                          .animate(anim)
                                                      : Tween<double>(
                                                              begin: 0.75,
                                                              end: 1)
                                                          .animate(anim),
                                                  child: ScaleTransition(
                                                      scale: anim,
                                                      child: child),
                                                ),
                                            child: index == 0
                                                ? const Icon(
                                                    Icons
                                                        .keyboard_arrow_right_rounded,
                                                    key: ValueKey('icon1'))
                                                : const Icon(
                                                    Icons.close,
                                                    key: ValueKey('icon2'),
                                                  )),
                                        onPressed: index == 1
                                            ? () {
                                                searchFieldController.clear();
                                                filterListItem.value =
                                                    itemsDefault;
                                                currentIndexIcon.value = 0;
                                              }
                                            : null,
                                      );
                                    })),
                        controller: searchFieldController,
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: ValueListenableBuilder<List<MapEntry<int, T>>>(
                        valueListenable: filterListItem,
                        builder: (_, List<MapEntry<int, T>> item, child) {
                          return ListView.builder(
                              itemCount: item.length,
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.all(10),
                              itemBuilder: (_, int index) {
                                return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Ink(
                                          decoration: BoxDecoration(
                                            borderRadius: dialogStyle
                                                .dialogItemTileStyle.radius,
                                            color: selectedValue != null &&
                                                    selectedValue!.value ==
                                                        item[index].value
                                                ? (dialogStyle
                                                        .dialogItemTileStyle
                                                        .selectedItemColor ??
                                                    DefaultTheme.unfocusColor)
                                                : dialogStyle
                                                    .dialogItemTileStyle
                                                    .unselectedItemColor,
                                          ),
                                          child: InkWell(
                                              borderRadius: dialogStyle
                                                  .dialogItemTileStyle.radius,
                                              onTap: () {
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();

                                                Navigator.of(context)
                                                    .pop([item[index].value]);
                                              },
                                              child: SizedBox(
                                                  width: double.infinity,
                                                  child: itemBuild(
                                                      item[index].value,
                                                      selectedValue ==
                                                          item[index].value,
                                                      customShowSearchMark(
                                                          item[index].value,
                                                          searchFieldController
                                                              .text))))),
                                      const Divider()
                                    ]);
                              });
                        })),
                footWidget ??
                    Container(
                      color: Colors.white,
                      height: 55,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Fechar'),
                          )
                        ],
                      ),
                    ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Material(
        type: MaterialType.card,
        color: dialogStyle.dialogFrameStyle.backgroundColor,
        borderRadius: dialogStyle.dialogFrameStyle.radius,
        elevation: dialogStyle.dialogFrameStyle.elevation,
        child: ClipRRect(
          borderRadius: dialogStyle.dialogFrameStyle.radius,
          child: Column(
            children: [
              headWidget ?? const SizedBox.shrink(),
              Container(
                padding: headPadding,
                color: dialogStyle.dialogFrameStyle.backgroundColor,
                child: Hero(
                  tag: 'field_hero',
                  child: Material(
                    color: Colors.transparent,
                    child: TextField(
                      onChanged: (String value) {
                        if (value.isNotEmpty) {
                          currentIndexIcon.value = 1;
                        }
                        loadingSearch.value = true;
                        if (debounce?.isActive ?? false) {
                          debounce!.cancel();
                        }

                        debounce = Timer(const Duration(milliseconds: 500), () {
                          filterListItem.value = itemsDefault.where((element) {
                            return removeAccents(
                                    attributeToSearch(element.value))
                                .toLowerCase()
                                .trim()
                                .contains(removeAccents(searchFieldController
                                    .text
                                    .toLowerCase()
                                    .trim()));
                          }).toList();
                          loadingSearch.value = false;
                        });
                      },
                      decoration: searchFieldDecoration ??
                          InputDecoration(
                              prefixIcon: ValueListenableBuilder(
                                valueListenable: loadingSearch,
                                builder: (_, bool loading, child) {
                                  return SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: loading
                                        ? const Center(
                                            child: SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                color:
                                                    DefaultTheme.unfocusColor,
                                                strokeWidth: 1.5,
                                              ),
                                            ),
                                          )
                                        : const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Icon(Icons.search)),
                                  );
                                },
                              ),
                              hintText: selectedValue != null
                                  ? attributeToSearch(selectedValue!.value)
                                  : 'Select',
                              filled: true,
                              fillColor: Colors.white,
                              border: InputBorder.none,
                              suffixIcon: ValueListenableBuilder<int>(
                                  valueListenable: currentIndexIcon,
                                  builder: (_, int index, child) {
                                    return IconButton(
                                      icon: AnimatedSwitcher(
                                          duration:
                                              const Duration(milliseconds: 350),
                                          transitionBuilder: (child, anim) =>
                                              RotationTransition(
                                                turns: child.key ==
                                                        const ValueKey('icon1')
                                                    ? Tween<double>(
                                                            begin: 1, end: 0.75)
                                                        .animate(anim)
                                                    : Tween<double>(
                                                            begin: 0.75, end: 1)
                                                        .animate(anim),
                                                child: ScaleTransition(
                                                    scale: anim, child: child),
                                              ),
                                          child: index == 0
                                              ? const Icon(
                                                  Icons
                                                      .keyboard_arrow_right_rounded,
                                                  key: ValueKey('icon1'))
                                              : const Icon(
                                                  Icons.close,
                                                  key: ValueKey('icon2'),
                                                )),
                                      onPressed: index == 1
                                          ? () {
                                              searchFieldController.clear();
                                              filterListItem.value =
                                                  itemsDefault;
                                              currentIndexIcon.value = 0;
                                            }
                                          : null,
                                    );
                                  })),
                      controller: searchFieldController,
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: ValueListenableBuilder<List<MapEntry<int, T>>>(
                      valueListenable: filterListItem,
                      builder: (_, List<MapEntry<int, T>> item, child) {
                        return ListView.builder(
                            itemCount: item.length,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(10),
                            itemBuilder: (_, int index) {
                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Ink(
                                        decoration: BoxDecoration(
                                          borderRadius: dialogStyle
                                              .dialogItemTileStyle.radius,
                                          color: selectedValue == item[index]
                                              ? (dialogStyle.dialogItemTileStyle
                                                      .selectedItemColor ??
                                                  DefaultTheme.unfocusColor)
                                              : dialogStyle.dialogItemTileStyle
                                                  .unselectedItemColor,
                                        ),
                                        child: InkWell(
                                            borderRadius: dialogStyle
                                                .dialogItemTileStyle.radius,
                                            onTap: () {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();

                                              Navigator.of(context)
                                                  .pop([item[index].key]);
                                            },
                                            child: SizedBox(
                                                width: double.infinity,
                                                child: itemBuild(
                                                    item[index].value,
                                                    selectedValue ==
                                                        item[index],
                                                    customShowSearchMark(
                                                        item[index].value,
                                                        searchFieldController
                                                            .text))))),
                                    const Divider()
                                  ]);
                            });
                      })),
              footWidget ??
                  Container(
                    color: Colors.white,
                    height: 55,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close'),
                        )
                      ],
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  RichText customShowSearchMark(T item, String searchValue) {
    if (searchValue.isNotEmpty) {
      try {
        final String itemName = attributeToSearch(item);
        final String itemNameLowerCase = itemName.toLowerCase();
        final String searchNameLowerCase =
            removeAccents(searchValue.toLowerCase());

        int startIndex =
            removeAccents(itemNameLowerCase).indexOf(searchNameLowerCase);
        int endIndex = searchValue.length;

        return RichText(
          text: TextSpan(
              style: const TextStyle(color: DefaultTheme.defaultTextColor),
              children: [
                TextSpan(text: itemName.substring(0, startIndex)),
                TextSpan(
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    text:
                        itemName.substring(startIndex, startIndex + endIndex)),
                TextSpan(
                    text: itemName.substring(
                        removeAccents(itemName)
                                .toLowerCase()
                                .indexOf(searchNameLowerCase) +
                            endIndex,
                        itemName.length))
              ]),
        );
      } catch (e) {
        return RichText(
            text: TextSpan(
                text: attributeToSearch(item),
                style: const TextStyle(color: DefaultTheme.defaultTextColor)));
      }
    } else {
      return RichText(
          text: TextSpan(
              text: attributeToSearch(item),
              style: const TextStyle(color: DefaultTheme.defaultTextColor)));
    }
  }
}
