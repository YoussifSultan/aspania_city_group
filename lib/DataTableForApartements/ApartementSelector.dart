import 'dart:convert';

import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:aspania_city_group/Common_Used/sql_functions.dart';
import 'package:aspania_city_group/class/realestate.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/src/response.dart';

import '../class/buidlingproperties.dart';

class ApartementSelector extends StatefulWidget {
  const ApartementSelector({super.key, required this.width});
  final double width;
  @override
  State<ApartementSelector> createState() => _ApartementSelectorState();
}

class _ApartementSelectorState extends State<ApartementSelector> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: widget.width,
      height: height * 0.8,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: FutureBuilder(
          future: getRealEstateTree(),
          builder: (context, snpashot) {
            if (snpashot.data != null) {
              return TreeView.simple(
                  expansionBehavior:
                      ExpansionBehavior.collapseOthersAndSnapToTop,
                  builder: (context, item) {
                    if (item.level == 0) {
                      /* *SECTION - Spain Tile */
                      return Row(
                        children: [
                          const Icon(
                            Icons.view_compact_rounded,
                            size: 20,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Spain City",
                            style: GoogleFonts.notoSansArabic(fontSize: 18),
                          )
                        ],
                      );
                      /* *!SECTION */
                    } else if (item.level == 1) {
                      /* *SECTION - real Estate Tile */
                      return Row(
                        children: [
                          const Icon(
                            Icons.apartment_outlined,
                            size: 20,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            item.key,
                            style: GoogleFonts.notoSansArabic(fontSize: 18),
                          )
                        ],
                      );
                      /* *!SECTION */
                    } else if (item.level == 2) {
                      /* *SECTION - Floor Tile */
                      return Row(
                        children: [
                          const Icon(
                            Icons.format_line_spacing_rounded,
                            size: 20,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            item.key,
                            style: GoogleFonts.notoSansArabic(fontSize: 18),
                          )
                        ],
                      );
                      /* *!SECTION */
                    } else if (item.level == 3) {
                      /* *SECTION - Apartements Tile */
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(item.data);
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.maps_home_work_rounded,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              item.data.apartementName,
                              style: GoogleFonts.notoSansArabic(fontSize: 18),
                            )
                          ],
                        ),
                      );
                      /* *!SECTION */
                    } else {
                      return const SizedBox();
                    }
                  },
                  shrinkWrap: true,
                  indentation: const Indentation(
                      style: IndentStyle.squareJoint, width: 40),
                  tree: snpashot.data ?? TreeNode.root());
            } else {
              return const CircularProgressIndicator(
                color: Colors.blueAccent,
              );
            }
          }),
    );
  }

  final List<RealEstateData> _realEstates = [];

  Future<TreeNode<dynamic>> getRealEstateTree() async {
    Response getDataResponse;

    getDataResponse = await SQLFunctions.sendQuery(
        query: "SELECT * FROM SpainCity.RealEstates");

    if (getDataResponse.statusCode == 200) {
      var data = json.decode(getDataResponse.body);
      for (var element in data) {
        _realEstates.add(RealEstateData(
            id: element[0],
            apartementStatusId: element[12],
            apartementPostionInFloorId: element[11],
            apartementPostionInBuildingId: element[10],
            apartementLink: element[9],
            isApartementHasEnoughData: element[1] == 1 ? true : false,
            apartementName: element[13],
            ownerName: element[2],
            ownerPhoneNumber: element[3],
            apartementGarage: element[14],
            responsibleName: element[7],
            responsiblePhone: element[8]));
      }
    } else {
      _realEstates.add(RealEstateData(
          id: 400,
          apartementStatusId: 400,
          apartementPostionInFloorId: 400,
          apartementPostionInBuildingId: 400,
          apartementLink: getDataResponse.body,
          isApartementHasEnoughData: false,
          apartementName: getDataResponse.body));
    }
    final List<Building> buildings = [
      Building(buildingName: 'عمارة رقم ۱', id: 1),
      Building(buildingName: 'عمارة رقم ۲', id: 2),
      Building(buildingName: 'عمارة رقم ۳', id: 3),
      Building(buildingName: 'عمارة رقم ٤', id: 4),
      Building(buildingName: 'عمارة رقم ٥', id: 5),
      Building(buildingName: 'عمارة رقم ٦', id: 6),
      Building(buildingName: 'عمارة رقم ۷', id: 7),
    ];
    final List<Floor> realEstateFloors = [
      Floor(floorName: 'الارضي المنخفض', id: 1),
      Floor(floorName: 'الارضي مرتفع', id: 2),
      Floor(floorName: 'الاول', id: 3),
      Floor(floorName: 'الثاني', id: 4),
      Floor(floorName: 'الثالث', id: 5),
      Floor(floorName: 'الرابع', id: 6),
    ];
    final treeview = TreeNode.root()
      ..addAll(buildings.map((building) {
        return TreeNode(key: building.buildingName)
          ..addAll(realEstateFloors.map((floor) {
            List<RealEstateData> realEstatesInBuildingInSpecificFloor = [];
            for (var i = 0; i < _realEstates.length; i++) {
              if (_realEstates[i].apartementPostionInBuildingId ==
                      building.id &&
                  _realEstates[i].apartementPostionInFloorId == floor.id) {
                realEstatesInBuildingInSpecificFloor.add(_realEstates[i]);
              }
            }
            return TreeNode(key: floor.floorName)
              // ..add(TreeNode(
              //     key: realEstatesInBuildingInSpecificFloor[0].ownerName));
              ..addAll(realEstatesInBuildingInSpecificFloor.map((apartement) {
                return TreeNode(data: apartement);
              }));
            // ..addAll(_realEstates.map((e) {
            //   if (e.apartementPostionInBuildingId == building.id &&
            //       e.apartementPostionInFloorId == floor.id) {
            //     return TreeNode(key: e.apartementName);
            //   } else {
            //     return TreeNode();
            //   }
            // }));
          }));
      }));
    return treeview;
  }
}
