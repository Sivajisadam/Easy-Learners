import 'common_imports.dart';

Widget reusableText(
        {required String giveText,
        double fontsize = 14,
        FontWeight fontweight = FontWeight.normal,
        Color textColor = Colors.black,
        double? textHeight,
        TextDecoration? underline,
        int? maxLine,
        TextOverflow? overflow = TextOverflow.ellipsis,
        double? letterSpacing,
        String? fontFamily,
        TextAlign textAlignment = TextAlign.start}) =>
    Text(
      giveText,
      maxLines: maxLine,
      overflow: overflow,
      textAlign: textAlignment,
      style: textStyle(
        letterSpacing: letterSpacing,
        underline: underline,
        fontfamily: fontFamily,
        fontsize: fontsize,
        fontweight: fontweight,
        textColor: textColor,
        textHeight: textHeight,
      ),
    );

TextStyle textStyle(
    {FontWeight? fontweight,
    Color? textColor,
    double? textHeight,
    String? fontfamily,
    double? fontsize,
    double? letterSpacing,
    TextDecoration? underline}) {
  return TextStyle(
    letterSpacing: letterSpacing,
    decoration: underline,
    fontFamily: fontfamily ?? 'Roboto',
    color: textColor,
    fontSize: fontsize,
    fontWeight: fontweight,
    height: textHeight,
  );
}

Widget svgButton({
  required Function() ontap,
  required String assetLocation,
  EdgeInsetsGeometry? padding,
  BoxFit? fit,
  double? height,
  double? width,
  double? size,
}) {
  return InkWell(
    onTap: ontap,
    child: Container(
        color: Colors.transparent,
        padding: padding,
        child: reuseSvg(
            assetLocation: assetLocation,
            fit: fit,
            height: height,
            width: width,
            size: size)),
  );
}

Widget reuseSvg(
    {required String assetLocation,
    BoxFit? fit,
    double? height,
    double? width,
    double? size,
    Color? color,
    // ColorFilter? colorFilter,
    void Function()? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: SvgPicture.asset(
      assetLocation,
      fit: fit ?? BoxFit.contain,
      height: height ?? size,
      width: width ?? size,
      color: color,
      // colorFilter: colorFilter,
    ),
  );
}

Widget reuseBackIcon() {
  return
      // assetSvg(assetLocation: "images/icons/back_arrow.svg");
      Icon(
    Icons.chevron_left_rounded,
    size: 35,
    shadows: [Shadow(color: Colors.white, blurRadius: 10)],
  );
}

SizedBox vSpace(double height) => SizedBox(height: height);

SizedBox hSpace(double width) => SizedBox(width: width);

Widget reuseableBtn(
    {required Function() onTap,
    String? text,
    Color? color,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color textColor = Colors.white,
    double height = 40,
    double width = 100,
    double? borderRadius,
    Widget? child,
    bool isLoading = false}) {
  return ElevatedButton(
    onPressed: onTap,
    style: ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 8))),
        fixedSize: WidgetStatePropertyAll(Size(width, height)),
        backgroundColor:
            WidgetStatePropertyAll(color ?? ColorConstants.primaryColor)),
    child: isLoading
        ? SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(color: Colors.white))
        : child ??
            reusableText(
                giveText: text ?? "Submit",
                fontsize: fontSize,
                fontweight: fontWeight,
                textColor: textColor),
  );
}

Widget reuseableOutlineBtn({
  required Function() onTap,
  String? text,
  Color? color,
  double fontSize = 16,
  FontWeight fontWeight = FontWeight.w600,
  Color textColor = ColorConstants.primaryColor,
  double? height,
  double? width,
  double? borderRadius,
  Widget? child,
}) {
  return OutlinedButton(
    onPressed: onTap,
    style: ButtonStyle(
        fixedSize: WidgetStatePropertyAll(Size(width ?? 80, height ?? 20)),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 8))),
        side: WidgetStatePropertyAll(
            BorderSide(color: ColorConstants.primaryColor))),
    child: child ??
        reusableText(
            giveText: text ?? "Submit",
            fontsize: fontSize,
            fontweight: fontWeight,
            textColor: textColor),
  );
}

Container reuseContainer({
  Color giveColor = Colors.transparent,
  Color giveBorderColor = Colors.transparent,
  double giveBorderWidth = 0,
  double? giveHeight,
  double? giveWidth,
  double topLeft = 12,
  double topRight = 12,
  double bottomRight = 12,
  double bottomLeft = 12,
  Color? shadow,
  bool top = true,
  bool bottom = true,
  Widget? child,
  BorderRadiusGeometry? borderRadius,
  Decoration? decoration,
  EdgeInsetsGeometry? margin,
  EdgeInsetsGeometry? padding,
  LinearGradient? gradient,
  Offset? offset,
  double? spreadRadius,
  double? maxHeight,
  double? maxWidth,
  double? minHeight,
  double? minWidth,
}) {
  return Container(
    height: giveHeight,
    width: giveWidth,
    margin: margin,
    padding: padding,
    constraints: BoxConstraints(
      maxHeight: maxHeight ?? double.infinity,
      maxWidth: maxWidth ?? double.infinity,
      minHeight: minHeight ?? 0.0,
      minWidth: minWidth ?? 0.0,
    ),
    decoration: decoration ??
        BoxDecoration(
          color: giveColor,
          boxShadow: [
            BoxShadow(
                offset: offset ?? const Offset(0, 3),
                color: shadow ?? Colors.transparent,
                spreadRadius: spreadRadius ?? 3,
                blurRadius: 3)
          ],
          borderRadius: borderRadius,
          border: Border.all(width: giveBorderWidth, color: giveBorderColor),
          gradient: gradient,
        ),
    child: child,
  );
}

Future reusabledialogue(
    {required String text,
    Function()? ontap,
    Widget? child,
    String? confirmText,
    String? cancleText}) {
  return showDialog(
      context: Get.context!,
      builder: (context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 25),
                // height: 150,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: ColorConstants.secondaryColor, width: 2),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    child ??
                        reusableText(
                            giveText: text,
                            textColor: Colors.black,
                            fontsize: 18,
                            maxLine: 2),
                    vSpace(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        reuseableOutlineBtn(
                          onTap: ontap ?? () {},
                          text: confirmText ?? "Yes",
                          width: Get.width / 4,
                        ),
                        reuseableBtn(
                          onTap: () => Get.back(),
                          text: cancleText ?? "No",
                          // fixedSize: WidgetStatePropertyAll(Size(80, 20)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      });
}

TextFormField textField(
        {required TextEditingController fieldController,
        required String giveHint,
        required void Function(String)? onFieldEntry,
        void Function(String)? onFieldSubmitted,
        bool autofocus = false,
        double? textSize,
        Color? textColor,
        TextStyle? hintStyle,
        String? prefixText,
        Color? borderColor,
        double? giveHeight = 50,
        double? giveWidth,
        bool alignLabelasHint = false,
        Widget? suffixWidget,
        Widget? prefixWidget,
        FocusNode? fieldFocusNode,
        TextInputType? keyboardType,
        void Function()? onFieldTap,
        int? fieldMaxLines = 1,
        bool isFieldReadOnly = false,
        Color backgroundColor = const Color(0xffEDEDED),
        InputBorder? enabledBorder,
        InputBorder? focusedBorder,
        InputBorder? focusedErrorBorder,
        InputBorder? errorBorder,
        Color? cursorColor,
        EdgeInsetsGeometry? contentPadding,
        String? lableText,
        TextStyle? lableStyle,
        String? Function(String?)? validator,
        int? maxLength,
        double? borderRadius,
        Color? fillColor}) =>
    TextFormField(
      readOnly: isFieldReadOnly,
      // onTapOutside: (event) => FocusScope.of(Get.context!).unfocus(),
      textInputAction: TextInputAction.newline,
      maxLines: fieldMaxLines,
      onTap: onFieldTap,
      focusNode: fieldFocusNode,
      autofocus: false,
      onChanged: onFieldEntry,
      onFieldSubmitted: onFieldSubmitted,
      controller: fieldController,
      keyboardType: keyboardType,
      cursorColor: cursorColor ?? ColorConstants.primaryColor,
      validator: validator,
      maxLength: maxLength,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
          fillColor: fillColor,
          prefixStyle: TextStyle(color: Colors.black),
          prefixText: prefixText,
          filled: fillColor != null,
          labelText: lableText,
          labelStyle:
              lableStyle ?? textStyle(textColor: ColorConstants.primaryColor),
          // label: ,
          prefixIcon: prefixWidget,
          suffixIcon: suffixWidget,
          floatingLabelBehavior: alignLabelasHint
              ? FloatingLabelBehavior.never
              : FloatingLabelBehavior.auto,
          alignLabelWithHint: alignLabelasHint,
          hintStyle: hintStyle ??
              textStyle(
                  textColor: Colors.black,
                  fontsize: 12,
                  fontweight: FontWeight.w400),
          hintText: giveHint,
          contentPadding: contentPadding ?? EdgeInsets.fromLTRB(12, 0, 12, 0),
          enabledBorder: enabledBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(borderRadius ?? 5),
                ),
                borderSide: BorderSide(
                  color: borderColor ?? ColorConstants.primaryColor,
                  width: 1,
                ),
              ),
          focusedBorder: focusedBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(borderRadius ?? 5),
                ),
                borderSide: BorderSide(
                  color: borderColor ?? ColorConstants.primaryColor,
                  width: 1,
                ),
              ),
          focusedErrorBorder: focusedErrorBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(borderRadius ?? 5),
                ),
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 1,
                ),
              ),
          errorBorder: errorBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(borderRadius ?? 5),
                ),
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 1,
                ),
              )),
      style: textStyle(
        textColor: textColor ?? Colors.black,
        fontweight: FontWeight.w400,
        fontsize: textSize ?? 14,
      ),
    );

TextFormField editProfileField(
    {required RxBool isEditable,
    required TextEditingController controller,
    TextInputType? textInputType,
    String? hintText,
    String? prefixIcon}) {
  return TextFormField(
    readOnly: !isEditable.value,
    controller: controller,
    keyboardType: textInputType ?? TextInputType.text,
    cursorColor: ColorConstants.primaryColor,
    decoration: inputDecoration(
        isEditable: isEditable, hintText: hintText, prefixIcon: prefixIcon),
  );
}

InputDecoration inputDecoration(
    {required RxBool isEditable, String? hintText, String? prefixIcon}) {
  return InputDecoration(
      hintText: hintText ?? "",
      border: !isEditable.value ? InputBorder.none : null,
      focusedBorder: isEditable.value
          ? UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 194, 194, 194)))
          : null,
      isDense: !isEditable.value ? true : false,
      prefixIconConstraints: const BoxConstraints(minWidth: 23, maxHeight: 25),
      hintStyle: textStyle(fontsize: 12),
      prefixIcon: prefixIcon != null
          ? Padding(
              padding: EdgeInsets.only(right: 10),
              child: reuseSvg(assetLocation: prefixIcon),
            )
          : null,
      counterText: '');
}

snackbarWidget({required String title}) {
  return Get.snackbar(
    title,
    "",
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.white,
    colorText: ColorConstants.primaryColor,
    borderColor: ColorConstants.primaryColor,
    borderWidth: 1,
  );
}

Widget expansionTile(
    {required String title,
    String? subTitle,
    FontWeight titleWeight = FontWeight.w500,
    FontWeight subTitleWeight = FontWeight.w400,
    double titleSize = 13,
    double subTitleSize = 10,
    Color? titleColor,
    Color? subTitleColor,
    List<Widget>? children}) {
  return ExpansionTile(
    leading: Image.asset(
      "images/custom_notification_icon.png",
      height: 30,
      width: 30,
    ),
    backgroundColor: Colors.white,
    collapsedBackgroundColor: Colors.white,
    tilePadding: EdgeInsets.symmetric(horizontal: 10),
    title: reusableText(
      giveText: title,
      fontweight: titleWeight,
      fontsize: titleSize,
      textColor: titleColor ?? ColorConstants.primaryColor,
      maxLine: 5,
    ),
    subtitle: Padding(
      padding: const EdgeInsets.only(top: 15),
      child: reusableText(
          giveText: subTitle ?? '',
          fontsize: subTitleSize,
          fontweight: subTitleWeight,
          textColor: subTitleColor ??
              Color.fromARGB(
                255,
                8,
                16,
                55,
              )),
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    collapsedShape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    children: children ?? [],
  );
}

MarkdownBody reuseMarkdownText({required String message}) {
  return MarkdownBody(
    data: message,
    styleSheet: MarkdownStyleSheet(
      p: const TextStyle(fontSize: 16),
      h1: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      h2: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      h3: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      code: TextStyle(
        backgroundColor: Colors.grey[200],
        fontFamily: 'monospace',
        fontSize: 14,
      ),
      codeblockDecoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    selectable: true,
  );
}
