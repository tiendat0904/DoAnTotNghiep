<div style="font-family:Roboto,RobotoDraft,Helvetica,Arial,sans-serif">
    <table align="center" cellpadding="0" cellspacing="0" style="background-color:#f2f2f2;margin:auto;border-collapse:collapse;width:100%;color:#222">
        <tbody>
            <tr>
                <td style="padding:20px 30px;width:auto">
                    <table cellpadding="0" cellspacing="0" style="border-collapse:collapse;background:#fff;width:800px;margin:auto">
                        <tbody>
                            <tr>
                                <td style="background:linear-gradient(to right,#243a76,#ed1b24)">
                                    <table cellpadding="0" cellspacing="0" style="border-collapse:collapse;width:100%">
                                        <tbody>
                                            <tr>
                                                <td style="color:#fff;padding:10px 20px">
                                                    <h1 style="font-size:1.2em">Thông tin đơn hàng tại TIENDATCOMPUTER</h1>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr style="border-bottom:2px dashed #ddd">
                                <td style="padding:1em 20px 1.5em 20px">
                                    <h2 style="font-size:1em">Cảm ơn quý khách {{$name}} đã đặt hàng tại TIENDATCOMPUTER</h2>
                                    <span style="color: black;">TIENDATCOMPUTER rất vui mừng thông báo rằng đơn hàng của quý khách đã được tiếp nhận và đang trong quá trình xử lý. Nhân viên của TIENDATCOMPUTER sẽ gọi điện cho quý khách để xác nhận trong thời gian sớm nhất.</span>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table cellpadding="0" cellspacing="0" style="border-collapse:collapse;font-size:12px">
                                        <tbody>
                                            <tr>
                                                <td style="padding-left:20px;padding-right:20px;padding-bottom:30px;padding-top:10px;color:black">
                                                    <h3 style="color: black;">Thông tin khách hàng</h3>
                                                    <table>
                                                        <tbody style="color: black;">
                                                            <tr>
                                                                <td>Tên khách hàng: </td>
                                                                <td>{{$name}}</td>
                                                            </tr>
                                                            <tr>
                                                                <td>Địa chỉ email: </td>
                                                                <td><a href="mailto:hasagidzo@gmail.com" target="_blank">{{$email}}</a></td>
                                                            </tr>
                                                            <tr>
                                                                <td>Điện thoại: </td>
                                                                <td>0{{$phone_number}}</td>
                                                            </tr>
                                                            <tr>
                                                                <td>Địa chỉ: </td>
                                                                <td>{{$address}}</td>
                                                            </tr>
                                                            <tr>
                                                                <td>Khách hàng ghi chú: </td>
                                                                <td>{{$note}}</td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <h3 style="color: black;">Nội dung đặt hàng</h3>
                                                    <table id="m_9035216637260039555nddh" style="border-collapse:collapse;width:100%;color:#333" border="1">
                                                        <tbody>
                                                            <tr style="background-color:#fc0;font-weight:bold">
                                                                <td style="padding:4px">STT</td>
                                                                <td style="padding:4px">Mã kho</td>
                                                                <td style="padding:4px">Sản phẩm</td>
                                                                <td style="padding:4px">Đơn giá</td>
                                                                <td style="padding:4px">Số lượng</td>
                                                            </tr>
                                                            @foreach ($listProduct as $index => $product)
                                                            <tr>

                                                                <td style="padding:4px">{{$index + 1}}</td>
                                                                <td style="padding:4px">{{$product['bill_detail_id']}}</td>
                                                                <td style="padding:4px">
                                                                    <a target="_blank"><b>{{$product['product_name']}} </b></a>
                                                                </td>
                                                                <td style="padding:4px">{{number_format($product['price'], 0, ',', '.')}} <u>đ</u> </td>
                                                                <td style="padding:4px">{{$product['amount']}}</td>
                                                            </tr>
                                                            @endforeach
                                                            <tr>
                                                                <td colspan="3" align="right" style="padding:4px;text-align:right">
                                                                    Thanh toán
                                                                </td>
                                                                <td colspan="2" style="padding:4px;font-weight:bold;color:#e00">
                                                                    {{number_format($total_money, 0, ',', '.')}} <u>đ</u>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td style="min-height:1px;max-height:1px;height:1px;line-height:1px;background:#b3e4fc"></td>
                            </tr>
                        </tbody>
                    </table>
                </td>
            </tr>
        </tbody>
    </table>
    <div class="yj6qo"></div>
    <div class="adL">
    </div>
</div>