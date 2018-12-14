//
//  TuSDKTSDate+Extend.h
//  TuSDK
//
//  Created by Clear Hu on 14/11/1.
//  Copyright (c) 2014年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  时间扩展
 */
@interface NSDate(TuSDKTSDateExtend)
#pragma mark - Calendar
/**
 *  获取当天的包括“年”，“月”，“日”，“周”，“时”，“分”，“秒”的NSDateComponents
 *
 *  @return 当天的包括“年”，“月”，“日”，“周”，“时”，“分”，“秒”的NSDateComponents
 */
- (NSDateComponents *)lsqComponentsOfDay;

/**
 *  获取NSDate对应的月份第几周
 *
 *  @return NSDate对应的月份第几周
 */
- (NSInteger)lsqWeekdayOrdinal;

/**
 *  获得NSDate对应的年份
 *
 *  @return NSDate对应的年份
 */
- (NSUInteger)lsqYear;

/**
 *  获得NSDate对应的月份
 *
 *  @return NSDate对应的月份
 */
- (NSUInteger)lsqMonth;

/**
 *  获得NSDate对应的日期
 *
 *  @return NSDate对应的日期
 */
- (NSUInteger)lsqDay;

/**
 *  获得NSDate对应的小时数
 *
 *  @return NSDate对应的小时数
 */
- (NSUInteger)lsqHour;

/**
 *  获得NSDate对应的分钟数
 *
 *  @return NSDate对应的分钟数
 */
- (NSUInteger)lsqMinute;

/**
 *  获得NSDate对应的秒数
 *
 *  @return NSDate对应的秒数
 */
- (NSUInteger)lsqSecond;

/**
 *  获得NSDate对应的星期
 *
 *  @return NSDate对应的星期 (Sunday:1, Monday:2, Tuesday:3, Wednesday:4, Thursday:5, Friday:6, Saturday:7)
 */
- (NSUInteger)lsqWeekday;

/**
 *  获得NSDate对应的周数
 *
 *  @return NSDate对应的周数
 */
- (NSUInteger)lsqWeek;

/**
 *  获取当天的起始时间（00:00:00）
 *
 *  @return 当天的起始时间
 */
- (NSDate *)lsqBeginingOfDay;

/**
 *  获取当天的结束时间（23:59:59）
 *
 *  @return 当天的结束时间
 */
- (NSDate *)lsqEndOfDay;

/**
 *  获取当月的第一天
 *
 *  @return 当月的第一天
 */
- (NSDate *)lsqFirstDayOfTheMonth;

/**
 *  获取当月的最后一天
 *
 *  @return 当月的最后一天
 */
- (NSDate *)lsqLastDayOfTheMonth;

/**
 *  获取前一个月的第一天
 *
 *  @return 前一个月的第一天
 */
- (NSDate *)lsqFirstDayOfThePreviousMonth;

/**
 *  获取后一个月的第一天
 *
 *  @return 后一个月的第一天
 */
- (NSDate *)lsqFirstDayOfTheFollowingMonth;

/**
 *  获取前一个月中与当天对应的日期
 *
 *  @return 前一个月中与当天对应的日期
 */
- (NSDate *)lsqAssociateDayOfThePreviousMonth;

/**
 *  获取后一个月中与当天对应的日期
 *
 *  @return 后一个月中与当天对应的日期
 */
- (NSDate *)lsqAssociateDayOfTheFollowingMonth;

/**
 *  获取当月的天数
 *
 *  @return 当月的天数
 */
- (NSUInteger)lsqNumberOfDaysInMonth;

/**
 *  获取当月的周数
 *
 *  @return 当月的周数
 */
- (NSUInteger)lsqNumberOfWeeksInMonth;

/**
 *  获取这一周的第一天
 *
 *  @return 这一周的第一天
 */
- (NSDate *)lsqFirstDayOfTheWeek;

/**
 *  获取当月中，前一周的第一天
 *
 *  @return 当月中，前一周的第一天
 */
- (NSDate *)lsqFirstDayOfThePreviousWeekInTheMonth;

/**
 *  获取前一个月中，最后一周的第一天
 *
 *  @return 前一个月中，最后一周的第一天
 */
- (NSDate *)lsqFirstDayOfTheLastWeekInPreviousMonth;

/**
 *  获取当月中，后一周的第一天
 *
 *  @return 当月中，后一周的第一天
 */
- (NSDate *)lsqFirstDayOfTheFollowingWeekInTheMonth;

/**
 *  获取下一个月中，最前一周的第一天
 *
 *  @return 下一个月中，最前一周的第一天
 */
- (NSDate *)lsqFirstDayOfTheFirstWeekInFollowingMonth;

/**
 *  获取当月中，这一周的第一天
 *
 *  @return 当月中，这一周的第一天
 */
- (NSDate *)lsqFirstDayOfTheWeekInTheMonth;

/**
 *  获取当月中，这一周的天数
 *
 *  @return 当月中，这一周的天数
 */
- (NSUInteger)lsqNumberOfDaysInTheWeekInMonth;

/**
 *  获取当天是当月的第几周
 *
 *  @return 当天是当月的第几周
 */
- (NSUInteger)lsqWeekOfDayInMonth;

/**
 *  获取当天是当年的第几周
 *
 *  @return 当天是当年的第几周
 */
- (NSUInteger)lsqWeekOfDayInYear;

/**
 *  获取前一周中与当天对应的日期
 *
 *  @return 前一周中与当天对应的日期
 */
- (NSDate *)lsqAssociateDayOfThePreviousWeek;

/**
 *  获取后一周中与当天对应的日期
 *
 *  @return 后一周中与当天对应的日期
 */
- (NSDate *)lsqAssociateDayOfTheFollowingWeek;

/**
 *  前一天
 *
 *  @return 前一天
 */
- (NSDate *)lsqPreviousDay;

/**
 *  后一天
 *
 *  @return 后一天
 */
- (NSDate *)lsqFollowingDay;

/**
 *  判断与某一天是否为同一天
 *
 *  @param otherDate 某一天
 *
 *  @return 与某一天是否为同一天
 */
- (BOOL)lsqSameDayWithDate:(NSDate *)otherDate;

/**
 *  判断与某一天是否为同一周
 *
 *  @param otherDate 某一天
 *
 *  @return 与某一天是否为同一周
 */
- (BOOL)lsqSameWeekWithDate:(NSDate *)otherDate;

/**
 *  判断与某一天是否为同一月
 *
 *  @param otherDate 某一天
 *
 *  @return 与某一天是否为同一月
 */
- (BOOL)lsqSameMonthWithDate:(NSDate *)otherDate;

#pragma mark - Timestamp
/**
 *  格式化时间
 *
 *  @param format 格式化字符串
 *
 *  @return 返回格式化后的时间
 */
- (NSString *)lsqDateFormat:(NSString*)format;

/**
 *  获取周名称
 *
 *  @return 周名称 TuSDK.strings=>"las_week_Sun" = "周日";
 */
- (NSString *)lsqWeekdayName;

#pragma mark - RFC1123
/**
 Convert a RFC1123 'Full-Date' string
 (http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.3.1)
 into NSDate.
 */
+ (NSDate *)lsqDateFromRFC1123:(NSString *)value;

/**
 Convert NSDate into a RFC1123 'Full-Date' string
 (http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.3.1).
 */
- (NSString *)lsqRfc1123String;
@end
