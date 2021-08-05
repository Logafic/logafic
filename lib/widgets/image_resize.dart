// import 'package:image/image.dart';

// abstract class ImageResize {
//   Image createImageResize(Image image, int maxSize) {
//     double width = image.width.toDouble();
//     double height = image.height.toDouble();

//     double bitmapRatio = width / height;
//     if (bitmapRatio > 1) {
//       width = maxSize.toDouble();
//       height = width / bitmapRatio;
//     } else {
//       height = maxSize.toDouble();
//       width = height * bitmapRatio.toDouble();
//     }
//     return copyResize(image, width: width.toInt(), height: height.toInt());
//   }
// }
