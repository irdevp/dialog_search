library dialog_search;

import 'dart:ui';

import 'package:flutter/material.dart';

import 'core/custom_dialog.dart';
import 'core/dialog_search_skeleton.dart';
import 'core/utils/constants_colors.dart';
import 'core/utils/dialog_search_style.dart';

// ignore: must_be_immutable
class DialogSearch<T> extends StatelessWidget {
  late final bool isMultiselect;

  late final List<int> initialItemIndex;
  Map<int, T> mapItems = {};

  late List<T> items;
  final dynamic initialValue;

  final String hintText;
  final TextStyle hintStyle;

//WEB
  late final bool isWeb;
  late final Future<List<T>> Function(String search) onSearch;

//ALL

  final void Function(List<T> newValue)? onChange;
  final bool Function()? beforeChange;

  final Widget Function(T item) fieldBuilderExternal;
  final Widget Function(T item, bool selected, RichText searchContrast)
      itemBuilder;
  final String Function(T) attributeToSearch;

  final bool disabled;

  //Default

  final DialogSearchStyle? dialogStyle;
  DialogSearch.single(
      {Key? key,
      required this.items,
      this.disabled = false,
      this.hintText = 'Select',
      this.hintStyle = const TextStyle(color: DefaultTheme.defaultTextColor),
      this.initialValue,
      this.onChange,
      this.beforeChange,
      required this.attributeToSearch,
      required this.fieldBuilderExternal,
      required this.itemBuilder,
      required this.onSearch,
      this.dialogStyle = const DialogSearchStyle(
        mainFieldStyle: FieldStyle(
          preffixWidget: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Icon(Icons.search_rounded,
                  color: DefaultTheme.defaultTextColor)),
          suffixWidget: Icon(Icons.keyboard_arrow_down_rounded,
              color: DefaultTheme.defaultTextColor),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          shadow: [
            BoxShadow(
              color: DefaultTheme.defaultShadowColor,
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            )
          ],
          radius: BorderRadius.all(Radius.circular(8.0)),
          color: Colors.white,
        ),
      )})
      : super(key: key) {
    isMultiselect = false;
    isWeb = false;
    initialItemIndex = [if (initialValue != null) items.indexOf(initialValue)];
    mapItems = items.asMap();
  }

  DialogSearch.multi(
      {Key? key,
      required this.items,
      required this.attributeToSearch,
      this.hintText = 'Select',
      this.disabled = false,
      this.hintStyle = const TextStyle(color: DefaultTheme.defaultTextColor),
      this.initialValue,
      this.onChange,
      this.beforeChange,
      this.dialogStyle = const DialogSearchStyle(
        mainFieldStyle: FieldStyle(
          preffixWidget: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Icon(Icons.search_rounded,
                  color: DefaultTheme.defaultTextColor)),
          suffixWidget: Icon(Icons.keyboard_arrow_down_rounded,
              color: DefaultTheme.defaultTextColor),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          shadow: [
            BoxShadow(
              color: DefaultTheme.defaultShadowColor,
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            )
          ],
          radius: BorderRadius.all(Radius.circular(8.0)),
          color: Colors.white,
        ),
      ),
      required this.itemBuilder,
      required this.fieldBuilderExternal})
      : assert((initialValue.runtimeType == List<T>) || initialValue == null),
        super(key: key) {
    isMultiselect = true;
    isWeb = false;

    if (initialValue != null) {
      final List<int> multiIndex = initialValue.map((i) {
        final int index = items.indexOf(i);
        if (index != -1) {
          return index;
        }
      }).toList();
      if (multiIndex.isNotEmpty) {
        initialItemIndex = multiIndex;
      } else {
        initialItemIndex = [];
      }
    } else {
      initialItemIndex = [];
    }
    mapItems = items.asMap();
  }

  DialogSearch.web(
      {Key? key,
      this.initialValue,
      this.onChange,
      this.disabled = false,
      this.hintText = 'Select',
      this.hintStyle = const TextStyle(color: DefaultTheme.defaultTextColor),
      required this.attributeToSearch,
      this.beforeChange,
      this.dialogStyle = const DialogSearchStyle(
        mainFieldStyle: FieldStyle(
          preffixWidget: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Icon(Icons.search_rounded,
                  color: DefaultTheme.defaultTextColor)),
          suffixWidget: Icon(Icons.keyboard_arrow_down_rounded,
              color: DefaultTheme.defaultTextColor),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          shadow: [
            BoxShadow(
              color: DefaultTheme.defaultShadowColor,
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            )
          ],
          radius: BorderRadius.all(Radius.circular(8.0)),
          color: Colors.white,
        ),
      ),
      required this.itemBuilder,
      required this.onSearch,
      required this.fieldBuilderExternal})
      : super(key: key) {
    isMultiselect = false;
    isWeb = true;
    mapItems = {};
    initialItemIndex = [];
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('RMK dialog_search');
    final ValueNotifier<List<int>?> selectedValueIndex =
        ValueNotifier<List<int>?>(initialItemIndex);
    return GestureDetector(
      onTap: disabled
          ? null
          : () async {
              Navigator.of(context, rootNavigator: true)
                  .push(DialogSearchSkeleton(
                barrierColor: Colors.transparent,
                builder: (BuildContext dialogContext) {
                  return Scaffold(
                    resizeToAvoidBottomInset: false,
                    body: SafeArea(
                        child: CustomDialog<T>(
                      itemBuild: itemBuilder,
                      fromJson: onSearch,
                      dialogStyle: dialogStyle!,
                      hintText: hintText,
                      hintStyle: hintStyle,
                      attributeToSearch: attributeToSearch,
                      items: mapItems,
                      selectedValueIndex: selectedValueIndex.value != null &&
                              selectedValueIndex.value!.isNotEmpty
                          ? selectedValueIndex.value!.first
                          : null,
                      isWeb: isWeb,
                    )),
                  );
                },
              ))
                  .then((value) {
                if (isWeb && value != null && value.isNotEmpty) {
                  items = value;
                  mapItems = value.asMap();
                  selectedValueIndex.value = [0];
                } else if (value != null && value.isNotEmpty) {
                  selectedValueIndex.value = value;
                }
                if (onChange != null) {
                  onChange!(selectedValueIndex.value!
                      .map((e) => mapItems.values.toList()[e])
                      .toList());
                }
              });
            },
      child: Container(
        padding: dialogStyle!.mainFieldStyle?.padding,
        decoration: dialogStyle!.mainFieldStyle?.toBoxDecoration(),
        child: ValueListenableBuilder(
            valueListenable: selectedValueIndex,
            builder: (_, List<int>? value, child) {
              return Hero(
                tag: 'field_hero',
                child: Material(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      dialogStyle!.mainFieldStyle?.preffixWidget ??
                          const SizedBox.shrink(),
                      Expanded(
                        child: isMultiselect && (value ?? []).isNotEmpty
                            ? Wrap(
                                children: (value ?? [])
                                    .map((e) => Container(
                                          color: Colors.red,
                                          child: Text(e.toString()),
                                        ))
                                    .toList())
                            : value!.isNotEmpty
                                ? fieldBuilderExternal(items[value.first])
                                : isWeb && initialValue != null
                                    ? fieldBuilderExternal(initialValue)
                                    : Text(
                                        hintText,
                                        style: hintStyle,
                                      ),
                      ),
                      dialogStyle!.mainFieldStyle?.suffixWidget ??
                          const SizedBox.shrink()
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
