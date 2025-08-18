import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

class FilterResultScreen extends StatefulWidget {
  const FilterResultScreen({super.key});

  @override
  State<FilterResultScreen> createState() => _FilterResultScreenState();
}

class _FilterResultScreenState extends State<FilterResultScreen> {
  List filterOptions = ["Electronic", "1 ton", "Argentina"];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView(
        children: [
          Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Filter Result For",
                  style: kwikTextStlye(14.0, FontWeight.w500, colorCodes.black),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 40,
                width: MediaQuery.of(context).size.width,
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(width: 12),
                  itemCount: 3,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 35,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: colorCodes.white,
                        border: Border.all(
                          color: colorCodes.antiFlashWhite,
                          width: 1.2,
                        ),
                      ),
                      child: Text(
                        filterOptions[index],
                        style: kwikTextStlye(
                          12.0,
                          FontWeight.w300,
                          colorCodes.black,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 48),
              Image.asset(
                "assets/images/icons/filter_result.png",
                height: 96,
                width: 113,
              ),
              SizedBox(height: 24),
              Text(
                "Contract not found",
                style: kwikTextStlye(24.0, FontWeight.w600, colorCodes.black),
              ),
              SizedBox(height: 6),
              Text(
                "Search again the ",
                style: kwikTextStlye(
                  14.0,
                  FontWeight.w300,
                  colorCodes.graniteGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
