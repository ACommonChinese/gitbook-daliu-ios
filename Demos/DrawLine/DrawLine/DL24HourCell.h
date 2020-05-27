#import <UIKit/UIKit.h>
@class JKWWMainModel;

NS_ASSUME_NONNULL_BEGIN

@interface DL24HourCell : UITableViewCell

- (void)set24HoureCellWithModel:(JKWWMainModel *)model;

@end


@interface Main24HoureItem : UIView

- (void)setItemInfoWithTemp:(NSString *)temp time:(NSString *)time weatherIcon:(NSString *)iconStr index:(NSInteger)index point:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
