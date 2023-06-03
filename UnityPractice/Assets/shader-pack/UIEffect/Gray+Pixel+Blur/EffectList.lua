--[[ 
=========================================
UI效果：
1.UIBlur:ui模糊效果
2.UIGlitch:ui电磁波干扰效果
3.UIGray:ui置灰效果
4.UIPixel：ui像素化效果
5.UIDissolve：ui消融效果
待实现：
8.UI阴影效果
9.UI内描边效果
10.UI 外描边效果
11.UI 描线
12.UI 外发光
12.UI 流光

6.UI全息效果
7.UI扫光效果
=========================================
1.UIBlur(高斯模糊)实现原理:
blurIntensive：模糊值；根据模糊值计算得到一个UV取样偏移值cc
对每个像素点取样以及对像素点的cc距离周围九宫的八个点取样的color；
并将这九个颜色累加,累加起来得到的结果就是最终值
得到的效果：一张图片有八个重影，重叠在一起的效果就像是模糊.
2.UIGlitch(干扰)实现原理:
frac(sin(dot(uv, float2(12.9898, 78.233))) * 43758.5453)
首先根据上面公式用uv和游戏时间来计算一个白噪声的值val，范围[0,1]
对这个值处理一下：val = val*2 - 1，范围变为[-1,1]
定义一个干扰程度参数(tt)与val相乘，得到的就是uv.u的偏移量，再用这个
偏移量去影响uv取样，得到的效果就是可以看到像素点会左右波动
3.UIGray(置灰)实现原理:
因为白色=(1,1,1,1),黑色=(0,0,0,1);从白色到黑色就是RGB三个值同时变化到0(三个值都相等)；
可以使用一个值c = [0,1] ,得到一个颜色 grayCol = (c,c,c)就是灰色
片元着色器code：
    fixed cc = color.r*0.299+color.g*0.587+color.b*0.114;//置灰公式
	color = fixed4(cc,cc,cc,1);//最终得到的颜色
最终整个UI的颜色就是介于黑色与白色之间的颜色(呈灰色，只是强度大小不一)。
4.UIPixel：(像素)实现原理:
像素化公式： 根据_PixelFactor来控制这张图像素的大小,使用_PixelFactor这个
参数对图片的UV进行放大取整,再用这个参数做除法，这样得到的UV精度就丢
失了，得到的图片就是像素化效果.
half2 pixelSize =(1-_PixelFactor*0.95) * _MainTex_TexelSize.zw;
IN.texcoord = round(IN.texcoord * pixelSize) / pixelSize;
5.UIDissolve：(消融)实现原理:
利用一张噪音图来实现，噪音图的颜色主要是介于黑色与白色之间的颜色组成，
由此可得color.r 范围 = [0,1];在片元着色器中读取噪音图的UV，得到的
颜色的r值作为是否溶解的标准，当r值小于消融参数时，则舍弃像素的渲染，
当消融参数从0变为1时，就可以看到ui的消融效果。
8.UIShadow：(阴影)实现原理:
根据阴影偏移参数对主贴图进行采样得到一张主贴图作为阴影，
当原图的alpha值大于阈值时；则显示原图采样值，否则显示阴影值，
只要将偏移调整一下，就可以将阴影图片移动一点，看起来就像是有阴影
9.UI内描边:内描边效果实现原理:(内缩)
在顶点着色器中，计算上下左右偏移的UV
片元计算中：用上面四个UV采样，得到的alpha值相乘，得到的值作为
颜色插值的阈值，插值公式(描边颜色，贴图颜色)。
可以理解为图片上只要是周边有透明的像素点时，这个点就变成描边的颜色
10.UI外描边:效果实现原理:(外扩)
与上面类似处理，像素点采样值透明度越低，颜色越接近于描边值
11.
]]--

--[[
模型效果：
]]