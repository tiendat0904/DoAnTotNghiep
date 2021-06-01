<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>

<body>
    <table cellpadding="0" cellspacing="0" style="border-collapse:collapse;background:#fff;width:800px;margin:auto">
        <tbody>
            <tr>
                <td style="background:linear-gradient(to right,#243a76,#ed1b24)">
                    <table cellpadding="0" cellspacing="0" style="border-collapse:collapse;width:100%">
                        <tbody>
                            <tr>
                                <td style="color:#fff;padding:10px 20px">
                                    <h1 style="font-size:1.2em">Thông tin liên hệ tới TIENDATCOMPUTER</h1>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </td>
            </tr>
            <tr style="border-bottom:2px dashed #ddd">
                <td style="padding:1em 20px 1.5em 20px">
                    <h2 style="font-size:1em">Cảm ơn quý khách {{$name}} đã liên hệ đến với chúng tôi</h2>
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
                                                <td>Nội dung liên hệ: </td>
                                                <td>{{$note}}</td>
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
</body>

</html>