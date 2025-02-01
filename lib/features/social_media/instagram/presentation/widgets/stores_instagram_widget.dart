import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class StoresInstagramWidget extends StatelessWidget {
  const StoresInstagramWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                            image: NetworkImage(
                                "https://s3-alpha-sig.figma.com/img/7b51/7fd1/166e1c96bb4d606ab3bc83385540dadb?Expires=1739145600&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=qNRQm2JukJgbuOrZneag1iBbDiXhzP~eUPwDbOTztcARFAlUCP51EzfRwBWlSzKjt6V0pQjix9ZAk3L7yzlelBQUFsLjayb7dmqBq1EQU2MLoZyCyTdo4OPXS8HOxH9mnw0d64a3aWGufWa17~97dgw347Q5zq2ZDXUt3ZQAZJ0FMjhtvxz~NtPN9Owf5-~WmoLxL74yrz97yLMSW4q8G0iDb2fYsW3D~zm96GWbatukP9qIdcDxD~NVZzrTIXwZgwZGzR1A~6OvdBnkxYl4a3xXIo9lPhPrJC9QMmc5zyi7wwuO-LoTgVVD9SVO9flzJGxobcjYmqZGV5iHQuWcCw__"),
                            fit: BoxFit.cover)
                  ),
                ),
                Positioned(
                  right: -3,
                  bottom: 0,
                  child: Container(
                    width: 23,
                    height: 23,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.PRIMARY_COLOR,
                        
                        ),
                    child: const Icon(
                      Icons.add,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            const Sizer(),
            ...List.generate(
              10,
              (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: 63,
                  height: 63,
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [ Color(0xff0B1035), Color(0xffFF3308)])
                  ),
                  child: Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      image: const DecorationImage(image: NetworkImage("https://s3-alpha-sig.figma.com/img/a677/a41f/027410390877dbe19c213b2e6ee60b75?Expires=1739145600&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=trQX6rLzjb2KRVVX2b7OTmfE69SHVesB4Zxz5~W0xrsT-0eGVGlVydBvDHFIXvG67eSnD951UOaz52LjUpX-f~E~FILgg26ieyspu-ifFKbB~JUrPS23hjBog~lcv~k9sv3JmT8mn10UHRnLdO0tAjYluVqjHwsPDMPC-b91LQm61GxL0GTJ1YdKihu2zyE9bLKlUHLriTxG-mUaZI1eytj0zuJBv-FwfHGPrJOSEplqy2RxoANRCpAef-k2uDqdds5WB1-R1baLF3Tfif~kMraTEq4lSYxEppQ6Dti2WOxzpsq80Sp9sOUBCF6tqxqEddd5FAoY2vhOqDQfHJHlLQ__"), fit: BoxFit.cover),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5)
                      ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
