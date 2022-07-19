import 'dart:async';

import 'package:flutter/material.dart';

import 'utils/constants_colors.dart';
import 'utils/remove_accents.dart';

class CustomDialog<T> extends StatelessWidget {
  final int? selectedValueIndex;
  final MapEntry<int, dynamic>? selectedValue;
  final String Function(dynamic item) itemLabel;
  final Map<int, dynamic> listItem;
  final List<MapEntry<int, dynamic>> listItemDefault;
  final int delaySearch;
  final EdgeInsets headPadding;
  final Widget headWidget;
  final Widget? footWidget;
  final InputDecoration? searchFieldDecoration;

  final Widget Function(dynamic item)? customSelectedItem;
  final Widget Function(dynamic item)? customUnselectedItem;

  CustomDialog({
    Key? key,
    this.selectedValueIndex,
    required this.listItem,
    required this.itemLabel,
    this.headWidget = const SizedBox(),
    this.headPadding = const EdgeInsets.fromLTRB(10, 15, 15, 5),
    this.delaySearch = 500,
    this.searchFieldDecoration,
    this.footWidget,
    this.customSelectedItem,
    this.customUnselectedItem,
  })  : listItemDefault = listItem.entries.toList(),
        selectedValue = selectedValueIndex != null
            ? listItem.entries.toList()[selectedValueIndex]
            : null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('RMK custom_dialog');

    final TextEditingController searchFieldController = TextEditingController();
    final ValueNotifier<bool> loadingSearch = ValueNotifier<bool>(false);
    final ValueNotifier<int> currentIndexIcon = ValueNotifier<int>(0);

    Timer? debounce;
    if (selectedValue != null) {
      listItemDefault
        ..removeAt(selectedValueIndex!)
        ..insert(0, selectedValue!);
    }

    final ValueNotifier<List<MapEntry<int, dynamic>>> filterListItem =
        ValueNotifier<List<MapEntry<int, dynamic>>>(listItemDefault);

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Material(
        type: MaterialType.card,
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        elevation: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            children: [
              headWidget,
              Container(
                padding: headPadding,
                color: Colors.white,
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
                          filterListItem.value =
                              listItemDefault.where((element) {
                            return removeAccents(itemLabel(element.value))
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
                                  ? itemLabel(selectedValue!.value)
                                  : 'Select',
                              filled: true,
                              fillColor: Colors.white,
                              border: InputBorder.none,
                              // hintStyle: TextStyle(color: kPrimaryColor),
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
                                                  listItemDefault;
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
                  child: ValueListenableBuilder<List<MapEntry<int, dynamic>>>(
                      valueListenable: filterListItem,
                      builder: (_, List<MapEntry<int, dynamic>> item, child) {
                        return ListView.builder(
                            itemCount: item.length,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(10),
                            itemBuilder: (_, int index) {
                              return CustomDialogItem<T>(
                                itemLabel: itemLabel,
                                item: item[index],
                                searchField: searchFieldController,
                                selectedValue: selectedValue,
                                customSelectedItem: customSelectedItem,
                                customUnselectedItem: customUnselectedItem,
                              );
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
}

class CustomDialogItem<T> extends StatelessWidget {
  final MapEntry<int, dynamic> item;
  final MapEntry<int, dynamic>? selectedValue;
  final String Function(dynamic item) itemLabel;

  final Widget Function(dynamic item)? customSelectedItem;
  final Widget Function(dynamic item)? customUnselectedItem;
  final TextEditingController searchField;

  const CustomDialogItem(
      {Key? key,
      required this.item,
      this.selectedValue,
      required this.searchField,
      required this.itemLabel,
      this.customSelectedItem,
      this.customUnselectedItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (item == selectedValue &&
        selectedValue != null &&
        customSelectedItem != null) {
      return customSelectedItem!(item);
    } else if (customUnselectedItem != null) {
      return customUnselectedItem!(item);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: selectedValue == item ? DefaultTheme.unfocusColor : null,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();

              Navigator.of(context).pop([item.key]);
            },
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: selectedValue == item
                    ? Row(
                        children: [
                          Expanded(
                            child: Text(
                              itemLabel(item.value),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: DefaultTheme.defaultTextColor),
                            ),
                          ),
                          const Icon(Icons.check_rounded,
                              color: DefaultTheme.defaultTextColor)
                        ],
                      )
                    : searchField.text.isNotEmpty
                        ? buildItem(item.value, searchField.text)
                        : Text(
                            itemLabel(item.value).toString(),
                            style: const TextStyle(
                                color: DefaultTheme.defaultTextColor),
                          ),
              ),
            ),
          ),
        ),
        const Divider()
      ],
    );
  }

  RichText buildItem(dynamic item, String searchValue) {
    try {
      final String itemName = itemLabel(item);
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
                  text: itemName.substring(startIndex, startIndex + endIndex)),
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
              text: itemLabel(item),
              style: const TextStyle(color: DefaultTheme.defaultTextColor)));
    }
  }
}
