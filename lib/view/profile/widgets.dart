import '../utils/common_imports.dart';

Row contactInfoWidget(BottomNavController controller,
    {required String title, required String value}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CircleAvatar(
          backgroundColor: ColorConstants.scaffoldBackgroundColor,
          child: Icon(title == "Email" ? Icons.email_outlined : Icons.phone,
              size: 20)),
      hSpace(10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          reusableText(
              giveText: title,
              fontsize: 16,
              fontweight: FontWeight.w600,
              textColor: ColorConstants.secondaryText),
          vSpace(5),
          reusableText(
              giveText: value, fontsize: 16, fontweight: FontWeight.w600),
        ],
      ),
      Spacer(),
      Visibility(
          visible:
              controller.userDetails.emailVerified! == true && title == "Email",
          child: Icon(Icons.verified, color: Colors.green)),
    ],
  );
}
