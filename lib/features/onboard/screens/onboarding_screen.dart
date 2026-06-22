import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:zerin_express/features/onboard/controllers/on_board_page_controller.dart';
import 'package:zerin_express/helper/login_helper.dart';
import 'package:zerin_express/localization/language_selection_screen.dart';
import 'package:zerin_express/localization/localization_controller.dart';
import 'package:zerin_express/util/app_constants.dart';
import 'package:zerin_express/util/dimensions.dart';
import 'package:zerin_express/util/images.dart';
import 'package:zerin_express/util/styles.dart';
import 'package:zerin_express/features/splash/controllers/config_controller.dart';
class OnBoardingScreen extends StatefulWidget {
  final Map<String,dynamic>? notificationData;
  const OnBoardingScreen({super.key, required this.notificationData});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> with SingleTickerProviderStateMixin {
  late final PageController _pageController = PageController()..addListener(_handlePageChanged);
  late final ValueNotifier<int> _currentPage = ValueNotifier(0)..addListener(() => setState(() {}));

  late AnimationController _controller;

  final List<Widget> pages = [];


  @override
  void initState() {

    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller to free resources
    _pageController.dispose(); // Dispose PageController as well if not used elsewhere
    super.dispose();
  }



  void _handlePageChanged() {
    int newPage = _pageController.page?.round() ?? 0;
    _currentPage.value = newPage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<OnBoardController>(builder: (onBoardController) {
        return Stack(
          children: [
            // Top Image Section
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: Get.height * 0.6,
              child: PageView.builder(
                controller: _pageController,
                itemCount: AppConstants.onBoardPagerData.length,
                onPageChanged: (value) {
                  onBoardController.onPageChanged(value);
                  _controller.reset();
                  _controller.forward();
                },
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
                    child: Center(
                      child: SvgPicture.asset(
                        AppConstants.onBoardPagerData[index].image,
                        width: Get.width * 0.8,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom Content Section
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: Get.height * 0.45,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha:0.05),
                      blurRadius: 20,
                      offset: const Offset(0, -10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    // Logo at the top of content
                    Image.asset(Images.logoWithName, height: 40),
                    const SizedBox(height: 30),
                    
                    // Titles
                    SizedBox(
                      height: 100,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: AppConstants.onBoardPagerData[onBoardController.pageIndex].title1 + " ",
                              style: textBold.copyWith(fontSize: 26, color: Colors.black87),
                            ),
                            TextSpan(
                              text: AppConstants.onBoardPagerData[onBoardController.pageIndex].title2,
                              style: textBold.copyWith(fontSize: 26, color: Theme.of(context).primaryColor),
                            ),
                            TextSpan(
                              text: "\n" + AppConstants.onBoardPagerData[onBoardController.pageIndex].title3,
                              style: textRegular.copyWith(fontSize: 16, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const Spacer(),

                    // Indicators and Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Dots
                        Row(
                          children: List.generate(
                            AppConstants.onBoardPagerData.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.only(right: 8),
                              height: 8,
                              width: index == onBoardController.pageIndex ? 24 : 8,
                              decoration: BoxDecoration(
                                color: index == onBoardController.pageIndex 
                                    ? Theme.of(context).primaryColor 
                                    : Theme.of(context).primaryColor.withValues(alpha:0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),

                        // Action Button
                        onBoardController.pageIndex == 3
                            ? _GetStartedButtonWidget(notificationData: widget.notificationData)
                            : FloatingActionButton(
                                onPressed: () {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                backgroundColor: Theme.of(context).primaryColor,
                                child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                              ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            
            // Skip button at top right
            Positioned(
              top: 50,
              right: 20,
              child: TextButton(
                onPressed: () {
                  Get.find<ConfigController>().disableIntro();
                  _checkNavigationRoute(widget.notificationData);
                },
                child: Text(
                  'skip'.tr,
                  style: textMedium.copyWith(color: Colors.black45),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _GetStartedButtonWidget extends StatelessWidget {
  final Map<String,dynamic>? notificationData;
  const _GetStartedButtonWidget({required this.notificationData});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Get.find<ConfigController>().disableIntro();
        _checkNavigationRoute(notificationData);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 0,
      ),
      child: Text('get_started'.tr, style: textBold.copyWith(fontSize: 16)),
    );
  }
}

void _checkNavigationRoute(Map<String,dynamic>? notificationData){
  if(Get.find<LocalizationController>().haveLocalLanguageCode()){
    LoginHelper.checkLoginMedium();
  }else{
    Get.offAll(()=> LanguageSelectionScreen(notificationData: notificationData));
  }
}

