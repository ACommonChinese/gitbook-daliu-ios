
#import "DL24HourCell.h"
#import "UIView+Addition.h"

#define cellHeight 188+45

#ifndef JKColorRGB
#   define JKColorRGB(r, g, b) (JKColorRGBA(r, g, b, 1.0))
#endif

#ifndef JKColorRGBA
#define JKColorRGBA(r, g, b, a) \
    [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:a]
#endif

#ifndef JKColorHex
#   define JKColorHex(hex) (JKColorHexA(hex, 1.0))
#endif

#ifndef JKColorHexA
#define JKColorHexA(hex, alpha) \
    (JKColorRGBA(((hex >> 16) & 0xff), ((hex >> 8) & 0xff), (hex & 0xff), alpha))
#endif

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface DL24HourCell ()

@property (nonatomic,strong) UIScrollView  *scrView;

@property (nonatomic,strong) CAShapeLayer *scrollViewlayer;

@end

@implementation DL24HourCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    self.backgroundColor = JKColorHexA(0xffffff, 0.1);
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(12, (45 -21)/2.f, 90, 21)];
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.textColor = UIColor.whiteColor;
    titleLab.text = @"24小时天气";
    [self.contentView addSubview:titleLab];
    
    UIView *line_h = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, SCREEN_WIDTH, 0.5)];
    line_h.backgroundColor = JKColorHexA(0xffffff, 0.1);
    [self.contentView addSubview:line_h];
    
    [self.contentView addSubview:self.scrView];
    
}

- (UIScrollView *)scrView{
    if (!_scrView) {
        _scrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 188)];
        _scrView.showsHorizontalScrollIndicator = NO;
        _scrView.showsVerticalScrollIndicator = NO;
        _scrView.contentSize = CGSizeMake(63*24, 188);
    }
    return _scrView;
}

- (CAShapeLayer *)scrollViewlayer{
    if (!_scrollViewlayer) {
        _scrollViewlayer = [CAShapeLayer layer];
    }
    return _scrollViewlayer;
}



- (void)displayContentView:(NSArray *)dataArr{
    for (int i =0; i < dataArr.count; i ++) {
        Main24HoureItem *item = [self.contentView viewWithTag:1808 +i];
        if (!item) {
            item = [[Main24HoureItem alloc] initWithFrame:CGRectMake(63*i, 0, 63, 188)];
            item.tag = 1808 +i;
            [self.scrView addSubview:item];
        }
        NSDictionary *info = dataArr[i];
        CGPoint point = [info[@"point"] CGPointValue];
        [item setItemInfoWithTemp:info[@"temp"] time:info[@"time"] weatherIcon:info[@"icon"] index:i point:point];
    }
    
}

- (void)drawPathWithPoints:(NSArray *)points animation:(BOOL)animation{

    UIBezierPath *path = [UIBezierPath bezierPath];

    CGPoint prePonit;
    for (int i =0; i<points.count; i++) {
        if (i==0) {
            // 起点
            [path moveToPoint:[points[0] CGPointValue]];

            prePonit = [points[0] CGPointValue];
        }else{

            CGPoint nowPoint = [points[i] CGPointValue];
            // 三次曲线
            [path addCurveToPoint:nowPoint
                    controlPoint1:CGPointMake((prePonit.x+nowPoint.x)/2, prePonit.y)
                    controlPoint2:CGPointMake((prePonit.x+nowPoint.x)/2, nowPoint.y)];

            prePonit = nowPoint;
        }
    }

    // 创建CAShapeLayer
//    _scrollViewlayer = [CAShapeLayer layer];

    self.scrollViewlayer.fillColor = [UIColor clearColor].CGColor;
    self.scrollViewlayer.lineWidth =  1.0f;
    self.scrollViewlayer.lineCap = kCALineCapRound;
    self.scrollViewlayer.lineJoin = kCALineJoinRound;
    self.scrollViewlayer.strokeColor = JKColorHex(0xffffff).CGColor;
    [self.scrView.layer addSublayer:self.scrollViewlayer];
    self.scrollViewlayer.path = path.CGPath;

    if (animation) {
        // 创建Animation
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = @(0.0);
        animation.toValue = @(1.0);
        self.scrollViewlayer.autoreverses = NO;
        animation.duration = 4.0;

        // 设置layer的animation
        [self.scrollViewlayer addAnimation:animation forKey:nil];
    }
}


- (void)set24HoureCellWithModel:(JKWWMainModel *)model{
    //获取开始时间下标
    NSInteger startIndex = 3;
    //获取所需数据源数组
    NSMutableArray *tempArr = [NSMutableArray arrayWithObjects:
                        @(26),
                        @(24.8),
                        @(23.6),
                        @(22.4),
                        @(20),
                        @(19),
                        @(18.2),
                        @(17.3),
                        @(17),
                        @(17),
                        @(17),
                        @(17),
                        @(17),
                        @(17.3),
                        @(17.4),
                        @(18),
                        @(20),
                        @(21.5),
                        @(23),
                        @(25),
                        @(26),
                        @(27),
                        @(27),
                        @(27), nil];
    
    CGFloat maxValue = [[tempArr valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat minValue = [[tempArr valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat maxchangedValue = (minValue < 0)?maxValue -minValue:maxValue;
    
    NSMutableArray *muArr = [[NSMutableArray alloc] init];
    NSMutableArray *pointArr = [[NSMutableArray alloc] init];
    
    for (int i =0 ; i < tempArr.count; i ++) {
        //最大高度为 120 -28 = 92
        //每一度高度为 92/maxValu
        //底部最低留出20px
        CGFloat tempValue = [tempArr[i] floatValue];
        CGFloat ory = 120 - 72/maxchangedValue*(tempValue -minValue) -20;
        CGPoint point = CGPointMake(i*63+63/2.f, ory);
        NSString *tempStr = [NSString stringWithFormat:@"%.0f°",tempValue];
       
        NSString *hhTimeStr = @"14";
        //判断  当时间字符串第一个为0时  去掉0
        NSString *timeStr = [NSString stringWithFormat:@"%ld点",(long)hhTimeStr.integerValue];
        timeStr = (i ==1) ? @"现在" : timeStr;
        NSString *weatherIconName = @"CSIcon/CLOUDY-CS";
        [muArr addObject:@{@"temp":tempStr,@"time":timeStr,@"point":[NSValue valueWithCGPoint:point],@"icon":weatherIconName}];
        
        CGPoint linePoint = CGPointMake(i*63+63/2.f, ory);
        [pointArr addObject:[NSValue valueWithCGPoint:linePoint]];
    }
    [self displayContentView:muArr];
    [self drawPathWithPoints:pointArr animation:NO];
    
}

/// 获取使用时间的下标
- (NSInteger)getStartTimeIndexWithModel {
    return 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end


@interface Main24HoureItem ()

@property (nonatomic,strong) UILabel  *tempLab;

@property (nonatomic,strong) UIImageView  *weatherImgV;

@property (nonatomic,strong) UILabel  *timeLab;

@property (nonatomic,strong) UIView  *line_v;

@property (nonatomic,strong) UIView  *line_h;

@end

@implementation Main24HoureItem

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI{
    
    [self addSubview:self.tempLab];
    [self addSubview:self.timeLab];
    [self addSubview:self.weatherImgV];
    
    [self addSubview:self.line_h];
    [self addSubview:self.line_v];
    
}

- (UILabel *)tempLab{
    if (!_tempLab) {
        _tempLab = [[UILabel alloc] init];
        _tempLab.size = CGSizeMake(self.width, 21);
        _tempLab.textAlignment = NSTextAlignmentCenter;
        _tempLab.font = [UIFont systemFontOfSize:15.0];
        _tempLab.originX = 0;
        _tempLab.textColor = JKColorHex(0xffffff);
    }
    return _tempLab;
}
- (UIImageView *)weatherImgV{
    if (!_weatherImgV) {
        _weatherImgV = [[UIImageView alloc] initWithFrame:CGRectMake((self.width -32)/2.f, self.height -32 -self.timeLab.height -10, 32, 32)];
    }
    return _weatherImgV;
}

- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 12)];
        _timeLab.font = [UIFont systemFontOfSize:12.0];
        _timeLab.textColor = JKColorHex(0xffffff);
        _timeLab.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLab;
}

- (UIView *)line_v{
    if (!_line_v) {
        _line_v = [[UIView alloc] init];
        _line_v.originX = self.frame.size.width/2.f;
        _line_v.width = 0.5;
        _line_v.bottom = 188 -120;
        _line_v.backgroundColor = [self commonColor];
    }
    return _line_v;
}

- (UIColor *)commonColor {
    return JKColorHexA(0xffffff, 0.2);
}

- (UIView *)line_h{
    if (!_line_h) {
        _line_h = [[UIView alloc] init];
        _line_h.originY = 120 -0.5;
        _line_h.height = 0.5;
        _line_h.width = self.width;
        _line_h.originX = 0;
        _line_h.backgroundColor = [self commonColor];
    }
    return _line_h;
}


- (void)setItemInfoWithTemp:(NSString *)temp time:(NSString *)time weatherIcon:(NSString *)iconStr index:(NSInteger)index point:(CGPoint)point{
    self.tempLab.text = temp;
    self.tempLab.originY = point.y -self.tempLab.height -5;
    
    
    self.timeLab.text = time;
    if ([time isEqualToString:@"现在"]) {
        self.timeLab.textColor = [UIColor orangeColor];
    }else{
        self.timeLab.textColor = JKColorHex(0xffffff);
    }
    
    
    if (index ==0) {
        self.line_h.originX = self.width/2.f;
        self.line_h.width = self.width/2.f;
    }else if (index == 23){
        self.line_h.width = self.width/2.f;
    }
    self.line_v.originY = point.y;
    self.line_v.height = 120 - self.line_v.originY;
    
    // self.weatherImgV.image = JKBundleImage(iconStr); todo://
}

@end
