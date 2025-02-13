import 'package:drink_rewards_lis/views/widgets/drink_card.dart';
import 'package:drink_rewards_lis/views/widgets/round_shadow.dart';
import 'package:flutter/material.dart';
import '../utils/data.dart';
import '../utils/styles.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  static final _demoData = DemoData();
  final double _listPadding = 20;
  DrinkData? _selectedDrink;
  final ScrollController _scrollController = ScrollController();
  final List<DrinkData> _drinks = _demoData.drinks;
  final int _earnedPoints = _demoData.earnedPoints;

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).size.aspectRatio > 1;
    double headerHeight =
        MediaQuery.of(context).size.height * (isLandscape ? .25 : .2);
    return Scaffold(
      backgroundColor: const Color(0xff22222b),
      body: Theme(
        data: ThemeData(fontFamily: "Poppins", primarySwatch: Colors.orange),
        child: Stack(
          children: <Widget>[
            ListView.builder(
              padding: EdgeInsets.only(bottom: 40, top: headerHeight + 10),
              itemCount: _drinks.length,
              scrollDirection: Axis.vertical,
              controller: _scrollController,
              itemBuilder: (context, index) => _buildListItem(index),
            ),
            _buildTopBg(headerHeight),
            _buildTopContent(headerHeight),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(int index) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: _listPadding / 2, horizontal: _listPadding),
      child: DrinkListCard(
        earnedPoints: _earnedPoints,
        drinkData: _drinks[index],
        isOpen: _drinks[index] == _selectedDrink,
        onTap: _handleDrinkTapped,
      ),
    );
  }

  Widget _buildTopBg(double height) {
    return Container(
      alignment: Alignment.topCenter,
      height: height,
      child: RoundedShadow(
          topLeftRadius: 0,
          topRightRadius: 0,
          shadowColor: const Color(0x00000000).withAlpha(65),
          child: SizedBox(
            width: double.infinity,
            child: Image.asset(
              "assets/images/Header-Dark.png",
              fit: BoxFit.fill,
            ),
          ),),
    );
  }

  Widget _buildTopContent(double height) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          padding: EdgeInsets.all(height * .08),
          constraints: BoxConstraints(maxHeight: height),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "My Rewards",
                style: Styles.text(height * .13, Colors.white, true),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.star,
                      color: AppColors.redAccent, size: height * .2),
                  const SizedBox(width: 8),
                  Text(
                    "$_earnedPoints",
                    style: Styles.text(height * .3, Colors.white, true),
                  ),
                ],
              ),
              Text(
                "Your Points Balance",
                style: Styles.text(height * .1, Colors.white, false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleDrinkTapped(DrinkData data) {
    setState(() {
      //If the same drink was tapped twice, un-select it
      if (_selectedDrink == data) {
        _selectedDrink = null;
      }
      //Open tapped drink card and scroll to it
      else {
        _selectedDrink = data;
        var selectedIndex = _drinks.indexOf(data);
        var closedHeight = DrinkListCard.nominalHeightClosed;
        //Calculate scrollTo offset, subtract a bit so we don't end up perfectly at the top
        var offset =
            selectedIndex * (closedHeight + _listPadding) - closedHeight * .35;
        _scrollController.animateTo(offset,
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutQuad);
      }
    });
  }
}
