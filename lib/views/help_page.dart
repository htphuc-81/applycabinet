import 'package:flutter/material.dart';
import 'package:flutter_cabinett/views/widgets/custom_appbar.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Hướng dẫn sử dụng",
        hasBack: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "*Chức năng Scan Qrcode",
                      style:
                          TextStyle(color: Color(0xff405864), fontSize: 16.0),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20,top: 3,right: 27),
                    child: Text(
                        "Cho phép người dùng thực hiện nhận dạng được tủ muốn thuê.Người dùng "
                            "thực hiện bấm vào nút scan trên màn hình mở tủ và thực hiện quét mã. "
                            ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 14,left: 20,right: 19),
                    child: Image.asset('assets/images/Rectangle.png'),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "*Chức năng thuê tủ",
                      style:
                      TextStyle(color: Color(0xff405864), fontSize: 16.0),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20,top: 3,right: 27),
                    child: Text(
                        "Cho phép người dùng thực hiện việc thuê tủ để sử dụng.Người dùng "
                            "thực hiện bấm vào nút thuê tủ trên màn hình thuê tủ."
                            "Nếu không muốn sử dụng tiếp người dùng vui lòng bấm hủy thuê trên màn hình."
                            "Ứng dụng sẽ hiện thị lên màn hình thời gian thuê và số tiền đã thuê tủ bao nhiêu. ",
                      style: TextStyle(color: Color(0xff4A4A4A),fontSize: 14.0),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 14,left: 20,right: 19),
                    child: Image.asset('assets/images/Rectangle.png'),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "*Chức năng mở tủ",
                      style:
                      TextStyle(color: Color(0xff405864), fontSize: 16.0),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20,top: 3,right: 27),
                    child: Text(
                        "Cho phép người dùng thực hiện mở tủ để sử dụng.Người dùng "
                            "thực hiện bấm vào nút mở khóa ngay trên màn hình mở tủ để mở khóa ứng dụng. ",
                        style: TextStyle(color: Color(0xff4A4A4A),fontSize: 14.0)
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 14,left: 20,right: 19),
                    child: Image.asset('assets/images/Rectangle.png'),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "*Chức năng Thanh toán phí momo",
                      style:
                      TextStyle(color: Color(0xff405864), fontSize: 16.0),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20,top: 3,right: 27),
                    child: Text(
                        "Cho phép người dùng thực hiện thanh toán phí để sử dụng.Người dùng "
                            "thực hiện bấm vào màn hình thanh toán sau đó chọn số tiền mình muốn sử dụng chọn."
                            "Sau đó bấm vào nút mua điểm để xác nhận thanh toán.Nếu không quý khách bấm back trở lại. ",
                        style: TextStyle(color: Color(0xff4A4A4A),fontSize: 14.0)
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 14,left: 20,right: 19),
                    child: Image.asset('assets/images/Rectangle.png'),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "*Thông tin liên hệ",
                      style:
                      TextStyle(color: Color(0xff405864), fontSize: 16.0),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20,top: 3,right: 27),
                    child: Text(
                        "Trường hợp Anh/chị không sử dụng được ứng dụng,"
                            "không hài lòng về ứng dụng, lỗi gì về khi sử dụng ứng dụng.Anh/chị vui lòng liện hệ qua email:"
                            "hotro@cabinet.vn để cải thiện và mang lại dịch vụ tốt hơn đến Anh/chị."
                            "Xin chân thành cảm ơn Anh/chị sử dụng ứng dụng",
                        style: TextStyle(color: Color(0xff4A4A4A),fontSize: 14.0)
                    ),
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
