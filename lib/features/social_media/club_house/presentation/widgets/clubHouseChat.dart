import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../../res/style/app_colors.dart';

class ClubHouseChat extends StatelessWidget {
  const ClubHouseChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Column(
          children: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            context.pop();
                          },
                          icon: const Icon(Icons.arrow_back_ios),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            'نقاش عن حقوق المرأة على برنامج  ٤٩ لجميع الخدمات',
                            style: TextStyle(),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          width: 100,
                        ),
                        Icon(FontAwesomeIcons.ellipsis),
                      ],
                    ),
                    const Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Replies on',
                            style: TextStyle(color: Colors.green),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          CircleAvatar(
                            radius: 1,
                            backgroundColor: Colors.grey,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '132 here now',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          CircleAvatar(
                            radius: 1,
                            backgroundColor: Colors.grey,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '140',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.person_outline_outlined,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: DecoratedBox(
                decoration: const BoxDecoration(color: Color(0xffe8dfd8)),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.symmetric(
                                vertical: 3,
                                horizontal: 5,
                              ),
                              width: MediaQuery.of(context).size.width / 2,
                              decoration: BoxDecoration(
                                color: AppColors.PRIMARY_COLOR.withOpacity(.8),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text(
                                'نص يستبدل نص يستبدل نص يستبدل',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const CircleAvatar(
                              radius: 20,
                              backgroundImage: CachedNetworkImageProvider(
                                'https://i.pinimg.com/474x/87/be/16/87be1686157a356132813070bbb1c027.jpg',
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.symmetric(
                                vertical: 3,
                                horizontal: 5,
                              ),
                              width: MediaQuery.of(context).size.width / 2,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text(
                                'نص يستبدل نص يستبدل نص يستبدل',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 5),
              decoration: const BoxDecoration(color: Color(0xffebebeb)),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(onPressed: () {}, icon: const Icon(Icons.mic)),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.camera_alt_outlined),
                      ),
                      Expanded(
                        child: Container(
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    const BorderSide(color: Colors.black12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    const BorderSide(color: Colors.black12),
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
