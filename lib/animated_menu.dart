library animated_menu;

import 'package:flutter/material.dart';

/// A Calculator.
class AnimatedMenu extends StatefulWidget {
  final List<MenuItem> items;
  final MenuStyle style;
  final OnSelectedChange onSelectedChange;
  AnimatedMenu({
    Key? key,
    required this.items,
    required this.style,
    required this.onSelectedChange,
  }) : super(key: key);

  @override
  _AnimatedMenuState createState() => _AnimatedMenuState();
}

bool isOpen = false;

class _AnimatedMenuState extends State<AnimatedMenu>
    with TickerProviderStateMixin {
  List<MenuItem> _items = [];
  List<MenuItem> _iconItems = [];
  late AnimationController _animationController;

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final GlobalKey<AnimatedListState> listKeyIcons =
      GlobalKey<AnimatedListState>();
  int selectedIndex = 0;
  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var maxHeight = widget.style.iconBoxWidth +
        (widget.style.iconBoxWidth / 2) +
        widget.style.heightOfItem * widget.items.length;
    var iconBoxHeight = widget.style.heightOfItem * widget.items.length;
    return Stack(
      alignment: widget.style.isRtl ? Alignment.topRight : Alignment.topLeft,
      children: [
        Container(
            width: widget.style.iconBoxWidth +
                widget.style.textBoxWidth +
                widget.style.spaceBetween,
            height: maxHeight),
        AnimatedContainer(
            duration: Duration(milliseconds: 200),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(widget.style.iconBoxWidth / 2),
                ),
                color: widget.style.menuColor),
            width: widget.style.iconBoxWidth,
            height: !isOpen ? widget.style.iconBoxWidth : maxHeight),
        widget.style.isRtl
            ? Positioned(
                top: (widget.style.iconBoxWidth - 24) / 2,
                right: (widget.style.iconBoxWidth - 24) / 2,
                child: GestureDetector(
                  onTap: () {
                    _openCloseMenu();
                  },
                  child: AnimatedIcon(
                      icon: AnimatedIcons.menu_close,
                      color: Colors.white,
                      progress: _animationController),
                ),
              )
            : Positioned(
                top: (widget.style.iconBoxWidth - 24) / 2,
                left: (widget.style.iconBoxWidth - 24) / 2,
                child: GestureDetector(
                  onTap: _openCloseMenu,
                  child: AnimatedIcon(
                      icon: AnimatedIcons.menu_close,
                      color: Colors.white,
                      progress: _animationController),
                ),
              ),
        widget.style.isRtl
            ? Positioned(
                top: widget.style.iconBoxWidth,
                right: widget.style.iconBoxWidth + widget.style.spaceBetween,
                child: Container(
                  width: widget.style.textBoxWidth + widget.style.spaceBetween,
                  height: iconBoxHeight,
                  child: AnimatedList(
                    key: listKey,
                    initialItemCount: _items.length,
                    itemBuilder: (context, index, animation) {
                      return slideIt(context, index, animation);
                    },
                    shrinkWrap: true,
                  ),
                ))
            : Positioned(
                top: widget.style.iconBoxWidth,
                left: widget.style.iconBoxWidth + widget.style.spaceBetween,
                child: Container(
                  width: widget.style.textBoxWidth + widget.style.spaceBetween,
                  height: iconBoxHeight,
                  child: AnimatedList(
                    key: listKey,
                    initialItemCount: _items.length,
                    itemBuilder: (context, index, animation) {
                      return slideIt(context, index, animation);
                    },
                    shrinkWrap: true,
                  ),
                )),
        widget.style.isRtl
            ? Positioned(
                top: widget.style.iconBoxWidth,
                right: 0,
                child: Container(
                  width: widget.style.iconBoxWidth,
                  height: iconBoxHeight,
                  child: AnimatedList(
                    key: listKeyIcons,
                    initialItemCount: _iconItems.length,
                    itemBuilder: (context, index, animation) {
                      return slideItIcon(context, index, animation);
                    },
                  ),
                ))
            : Positioned(
                top: widget.style.iconBoxWidth,
                left: 0,
                child: Container(
                  width: widget.style.iconBoxWidth,
                  height: iconBoxHeight,
                  child: AnimatedList(
                    key: listKeyIcons,
                    initialItemCount: _iconItems.length,
                    itemBuilder: (context, index, animation) {
                      return slideItIcon(context, index, animation);
                    },
                  ),
                ))
      ],
    );
  }

  Widget slideIt(BuildContext context, int index, animation) {
    MenuItem item = _items[index];
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-0.3, 0),
        end: Offset(0, 0),
      ).animate(animation),
      child: GestureDetector(
        onTap: () {
          _changeSelected(index);
        },
        child: Container(
          height: widget.style.heightOfItem,
          child: Align(
            alignment: widget.style.isRtl
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Text(
              item.title,
              maxLines: 1,
              textAlign: widget.style.isRtl ? TextAlign.right : TextAlign.left,
              style: index == selectedIndex
                  ? widget.style.selectedTextStyle
                  : widget.style.textStyle,
            ),
          ),
        ),
      ),
    );
  }

  Widget slideItIcon(BuildContext context, int index, animation) {
    MenuItem item = _iconItems[index];
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-0.3, 0),
        end: Offset(0, 0),
      ).animate(animation),
      child: GestureDetector(
        onTap: () {
          _changeSelected(index);
        },
        child: Container(
          height: widget.style.heightOfItem,
          child: Align(
              alignment: Alignment.center,
              child: Icon(item.iconData,
                  color: index == selectedIndex
                      ? widget.style.selectedIconColor
                      : item.iconColor)),
        ),
      ),
    );
  }

  void addItems() {
    for (int i = 0; i < widget.items.length; i++) {
      listKey.currentState!
          .insertItem(i, duration: const Duration(milliseconds: 300));

      _items.add(widget.items[i]);
    }
  }

  void addIconItems() {
    for (int i = 0; i < widget.items.length; i++) {
      listKeyIcons.currentState!
          .insertItem(i, duration: const Duration(milliseconds: 300));

      _iconItems.add(widget.items[i]);
    }
  }

  removeIconItems() {
    for (int i = 0; i < widget.items.length; i++) {
      listKeyIcons.currentState!.removeItem(
          widget.items.length - 1 - i,
          (_, animation) =>
              slideItIcon(context, widget.items.length - 1 - i, animation),
          duration: const Duration(milliseconds: 100));
      Future.delayed(Duration(milliseconds: 200))
          .then((value) => _iconItems.removeAt(widget.items.length - 1 - i));
    }
  }

  removeItems() {
    for (int i = 0; i < widget.items.length; i++) {
      listKey.currentState!.removeItem(
          widget.items.length - 1 - i,
          (_, animation) =>
              slideIt(context, widget.items.length - 1 - i, animation),
          duration: const Duration(milliseconds: 100));
      Future.delayed(Duration(milliseconds: 200))
          .then((value) => _items.removeAt(widget.items.length - 1 - i));
    }
  }

  void _openCloseMenu() {
    setState(() {
      isOpen = !isOpen;
      isOpen ? addItems() : removeItems();
      isOpen ? addIconItems() : removeIconItems();
      isOpen ? _animationController.forward() : _animationController.reverse();
    });
  }

  void _changeSelected(int index) {
    selectedIndex = index;
    _openCloseMenu();
    widget.onSelectedChange(selectedIndex);
  }
}

class MenuItem {
  IconData iconData;
  String title;
  Color iconColor;
  MenuItem(
      {required this.iconData,
      required this.title,
      this.iconColor = Colors.white});
}

class MenuStyle {
  TextStyle textStyle;
  TextStyle selectedTextStyle;
  Color menuColor;
  Color selectedIconColor;
  Color selectedBoxColor;
  double iconBoxWidth;
  double textBoxWidth;
  double heightOfItem;
  double spaceBetween;
  bool isRtl;
  MenuStyle({
    this.textStyle = const TextStyle(
        color: Colors.blue, fontSize: 18, fontWeight: FontWeight.w400),
    this.selectedTextStyle = const TextStyle(
        color: Colors.amberAccent, fontSize: 18, fontWeight: FontWeight.w400),
    this.menuColor = Colors.blue,
    this.selectedBoxColor = Colors.blue,
    this.selectedIconColor = Colors.amberAccent,
    this.iconBoxWidth = 80,
    this.textBoxWidth = 100,
    this.heightOfItem = 50,
    this.spaceBetween = 12,
    this.isRtl = false,
  });
}

typedef OnSelectedChange = void Function(int index);
