import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class SuggestedForYouInstagramScreen extends StatelessWidget {
  const SuggestedForYouInstagramScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      mainCategoryId: 1,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const Sizer(),
              ...List.generate(
                5,
                (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                    
                          ),
                        ),
                        const Sizer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("zyad mohamed", style: Styles.mediumText(fontWeight: FontWeight.bold),),
                            Text("zyad", style: Styles.mediumText(fontWeight: FontWeight.w500, color: Colors.grey),),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: Text("Confirm", style: Styles.mediumText(color: Colors.white, fontSize: 25),),
                        ),
                        const Sizer(),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: Text("Delete", style: Styles.mediumText(fontSize: 25),),
                        )
                      ],
                    ),
                  );
                },
              ),
              Sizer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("See all", style: Styles.mediumText(color: Colors.blue, fontSize: 35, fontWeight: FontWeight.bold),),
                    Icon(Icons.keyboard_arrow_down_rounded)
                  ],
                ),
              ),
              const Sizer(),
              
              Row(
                children: [
                  Text(
                    "My Follower",
                    style: Styles.headerText(
                        fontSize: 41, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Sizer(),
              ...List.generate(
                5,
                (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                    
                          ),
                        ),
                        const Sizer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("zyad mohamed", style: Styles.mediumText(fontWeight: FontWeight.bold),),
                            Text("zyad", style: Styles.mediumText(fontWeight: FontWeight.w500, color: Colors.grey),),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: Text("Follow back", style: Styles.mediumText(color: Colors.white, fontSize: 25),),
                        ),
                        const Sizer(),
                        const Icon(Icons.close, size: 20,)
                      ],
                    ),
                  );
                },
              ),
              Sizer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("See all", style: Styles.mediumText(color: Colors.blue, fontSize: 35, fontWeight: FontWeight.bold),),
                    Icon(Icons.keyboard_arrow_down_rounded)
                  ],
                ),
              ),
              const Sizer(),
              Row(
                children: [
                  Text(
                    "Suggested for you",
                    style: Styles.headerText(
                        fontSize: 41, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Sizer(),
              ...List.generate(
                5,
                (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                    
                          ),
                        ),
                        const Sizer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("zyad mohamed", style: Styles.mediumText(fontWeight: FontWeight.bold),),
                            Text("zyad", style: Styles.mediumText(fontWeight: FontWeight.w500, color: Colors.grey),),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: Text("Follow", style: Styles.mediumText(color: Colors.white, fontSize: 25),),
                        ),
                        const Sizer(),
                        const Icon(Icons.close, size: 20,)
                      ],
                    ),
                  );
                },
              ),
              Sizer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("See all", style: Styles.mediumText(color: Colors.blue, fontSize: 35, fontWeight: FontWeight.bold),),
                    Icon(Icons.keyboard_arrow_down_rounded)
                  ],
                ),
              ),
              Sizer(height: 50,),
            ],
          ),
        ),
      ),
    );
  }
}
