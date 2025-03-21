import 'package:easy_learners/view/utils/common_imports.dart';

class HomeScreen extends GetWidget<BottomNavController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     controller.getGeminiResponse(
      //         "Give me the best technology to be learned in 2025");
      //   },
      //   child: Icon(Icons.search),
      // ),
      body: Obx(
        () => SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(() => Search());
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined),
                        reusableText(
                            giveText: "Current Location",
                            fontsize: 20,
                            fontweight: FontWeight.w600),
                      ],
                    ),
                    vSpace(6),
                    SizedBox(
                      width: Get.width * 0.6,
                      child: reusableText(
                          giveText: controller.userLocation.value,
                          fontsize: 16,
                          fontweight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              vSpace(30),
              AssistantScreen()
            ],
          ),
        )),
      ),
    );
  }
}
