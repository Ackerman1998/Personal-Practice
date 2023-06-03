--[[ 
abs(x) 返回输入参数的绝对值
acos(x) 反余切函数，输入参数范围为[-1,1]， 返回[0,π]区间的角度值
all(x) 如果输入参数均不为0，则返回ture； 否则返回flase。&&运算
any(x) 输入参数只要有其中一个不为0，则返回true。
asin(x) 反正弦函数,输入参数取值区间为，返回角度值范围为,
atan(x) 反正切函数，返回角度值范围为
atan2(y,x) 计算y/x的反正切值。实际上和atan(x)函数功能完全一样，至少输入参数不同。atan(x) = atan2(x, float(1))。
ceil(x) 对输入参数向上取整。例如： ceil(float(1.3)) ，其返回值为2.0
clamp(x,a,b) 如果x值小于a，则返回a；
如果x值大于b，返回b；
否则，返回x。
cos(x) 返回弧度x的余弦值。返回值范围为
cosh(x) 双曲余弦（hyperbolic cosine）函数，计算x的双曲余弦值。
cross(A,B) 返回两个三元向量的叉积(cross product)。注意，输入参数必须是三元向量！
degrees(x) 输入参数为弧度值(radians)，函数将其转换为角度值(degrees)
determinant(m) 计算矩阵的行列式因子。
dot(A,B) 返回A和B的点积(dot product)。参数A和B可以是标量，也可以是向量（输入参数方面，点积和叉积函数有很大不同）。
exp(x) 计算的值，e=2.71828182845904523536
exp2(x) 计算的值
 对输入参数向下取整。例如floor(float(1.3))返回的值为1.0；但是floor(float(-1.3))返回的值为-2.0。该函数与ceil(x)函数相对应。
fmod(x,y) 返回x/y的余数。如果y为0，结果不可预料。
frac(x) 返回标量或矢量的小数
frexp(x, out i) 将浮点数x分解为尾数和指数，即， 返回m，并将指数存入i中；如果x为0，则尾数和指数都返回0
isfinite(x) 判断标量或者向量中的每个数据是否是有限数，如果是返回true；否则返回false;
isinf(x) 判断标量或者向量中的每个数据是否是无限，如果是返回true；否则返回false;
isnan(x) 判断标量或者向量中的每个数据是否是非数据(not-a-number NaN)，如果是返回true；否则返回false;
ldexp(x, n) 计算的值
 计算或者的值。即在下限a和上限b之间进行插值，f表示权值。注意，如果a和b是向量，则权值f必须是标量或者等长的向量。
lit(NdotL, NdotH, m) N表示法向量；L表示入射光向量；H表示半角向量；m表示高光系数。 函数计算环境光、散射光、镜面光的贡献，返回的4元向量。 X位表示环境光的贡献，总是1.0; Y位代表散射光的贡献，如果 ，则为0；否则为 Z位代表镜面光的贡献，如果 或者，则位0；否则为;W位始终位1.0
log(x) 计算的值，x必须大于0
log2(x) 计算的值，x必须大于0
log10(x) 计算的值，x必须大于0
 比较两个标量或等长向量元素，返回最大值。
min(a,b) 比较两个标量或等长向量元素，返回最小值。
modf(x, out ip) 把x分解成整数和分数两部分，每部分都和x有着相同的符号，整数部分被保存在ip中，分数部分由函数返回
mul(M, N) 矩阵M和矩阵N的积
mul(M, v) 矩阵M和列向量v的积
mul(v, M) 行向量v和矩阵M的积
noise(x) 根据它的参数类型，这个函数可以是一元、二元或三元噪音函数。返回的值在0和1之间，并且通常与给定的输入值一样
radians(x) 函数将角度值转换为弧度值
round(x) 返回四舍五入值。
rsqrt(x) x的平方根的倒数，x必须大于0
 把x限制到[0,1]之间
sign(x) 如果则返回1；否则返回0
sin(x) 输入参数为弧度，计算正弦值，返回值范围 为[-1,1]
sincos(float x, out s, out c) 该函数是同时计算x的sin值和cos值，其中s=sin(x)，c=cos(x)。该函数用于“同时需要计算sin值和cos值的情况”，比分别运算要快很多!
sinh(x) 计算x的双曲正弦
 值x位于min、max区间中。如果x=min，返回0；如果x=max，返回1；如果x在两者之间，按照下列公式返回数据：
 对等 T= ( a < y ) ? 1 : 0
sqrt(x) 求x的平方根，，x必须大于0
tan(x) 计算x正切值
tanh(x) 计算x的双曲线切线
transpose(M) 矩阵M的转置矩阵

几何函数——描述
distance(pt1, pt2) 两点之间的欧几里德距离（Euclidean distance）
faceforward(N,I,Ng) 如果，返回N；否则返回-N。
length(v) 返回一个向量的模，即sqrt(dot(v,v))
 返回v向量的单位向量
reflect(I, N) 根据入射光纤方向I和表面法向量N计算反射向量，仅对三元向量有效
refract(I,N,eta) 根据入射光线方向I，表面法向量N和折射相对系数eta,计算折射向量。如果对给定的eta,I和N之间的角度太大，返回(0,0,0)。
只对三元向量有效

纹理映射函数——功能描述
tex1D(sampler1D tex, float s) 一维纹理查询
tex1D(sampler1D tex, float s, float dsdx, float dsdy) 使用导数值（derivatives）查询一维纹理
Tex1D(sampler1D tex, float2 sz) 一维纹理查询，并进行深度值比较
Tex1D(sampler1D tex, float2 sz, float dsdx,float dsdy) 使用导数值（derivatives）查询一维纹理， 并进行深度值比较
Tex1Dproj(sampler1D tex, float2 sq) 一维投影纹理查询
Tex1Dproj(sampler1D tex, float3 szq) 一维投影纹理查询，并比较深度值
Tex2D(sampler2D tex, float2 s) 二维纹理查询
Tex2D(sampler2D tex, float2 s, float2 dsdx, float2 dsdy) 使用导数值（derivatives）查询二维纹理
Tex2D(sampler2D tex, float3 sz) 二维纹理查询，并进行深度值比较
Tex2D(sampler2D tex, float3 sz, float2 dsdx,float2 dsdy) 使用导数值（derivatives）查询二维纹理，并进行深度值比较
 二维投影纹理查询
Tex2Dproj(sampler2D tex, float4 szq) 二维投影纹理查询，并进行深度值比较
texRECT(samplerRECT tex, float2 s) 二维非投影矩形纹理查询（OpenGL独有）
texRECT (samplerRECT tex, float3 sz, float2 dsdx,float2 dsdy) 二维非投影使用导数的矩形纹理查询（OpenGL独有）
texRECT (samplerRECT tex, float3 sz) 二维非投影深度比较矩形纹理查询（OpenGL独有）
texRECT (samplerRECT tex, float3 sz, float2 dsdx,float2 dsdy) 二维非投影深度比较并使用导数的矩形纹理查询（OpenGL独有）
texRECT proj(samplerRECT tex, float3 sq) 二维投影矩形纹理查询（OpenGL独有）
texRECT proj(samplerRECT tex, float3 szq) 二维投影矩形纹理深度比较查询（OpenGL独有）
Tex3D(sampler3D tex, float s) 三维纹理查询
Tex3D(sampler3D tex, float3 s, float3 dsdx, float3 dsdy) 结合导数值（derivatives）查询三维纹理
Tex3Dproj(sampler3D tex, float4 szq) 查询三维投影纹理，并进行深度值比较
texCUBE(samplerCUBE tex, float3 s) 查询立方体纹理
texCUBE (samplerCUBE tex, float3 s, float3 dsdx, float3 dsdy) 结合导数值（derivatives）查询立方体纹理
texCUBEproj (samplerCUBE tex, float4 sq) 查询投影立方体纹理


]]--

