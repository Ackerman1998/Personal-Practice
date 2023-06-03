--[[ 
API
常用函数和参数：
frac函数,此函数主要是 返回小数部分(正值)

_SinTime , //float4 _SinTime; // sin(t/8), sin(t/4), sin(t/2), sin(t)

_Time : t是自该场景加载开始所经过的时间，4个分量分别是t/20,t,t*2,t*3

step(a,b)函数解释:如果a>b返回0;如果a<=b返回1

lerp（a,b,c）函数：如果c越靠近1返回的值越接近b，越接近0返回值的越靠近a

_MainTex_TexelSize,这个变量的从字面意思是主贴图 _MainTex 的像素尺寸大小,是一个四元数,
是 unity 内置的变量,它的值为 Vector4(1 / width, 1 / height, width, height)


]]--

