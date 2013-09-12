//
//  CSApplicationHelper.m
//  MobilSatis
//
//  Created by alp keser on 9/10/12.
//
//

#import "CSApplicationHelper.h"

@implementation CSApplicationHelper
+ (NSString*)getMonthFromNumber:(int)monthNo{
    switch (monthNo) {
        case 0:
            return @"Ocak";
            break;
        case 1:
            return @"Şubat";
            break;
        case 2:
            return @"Mart";
            break;
        case 3:
            return @"Nisan";
            break;
        case 4:
            return @"Mayıs";
            break;
        case 5:
            return @"Haziran";
            break;
        case 6:
            return @"Temmuz";
            break;
        case 7:
            return @"Ağustos";
            break;
        case 8:
            return @"Eylül";
            break;
        case 9:
            return @"Ekim";
            break;
        case 10:
            return @"Kasım";
            break;
        case 11:
            return @"Aralık";
            break;
            
        default:
            break;
    }
    return @"Ocak";
}

+ (NSString*)getDaysFromNumber:(int)daysNo{
    switch (daysNo) {
        case 0:
            return @"01";
            break;
        case 1:
            return @"02";
            break;
        case 2:
            return @"03";
            break;
        case 3:
            return @"04";
            break;
        case 4:
            return @"05";
            break;
        case 5:
            return @"06";
            break;
        case 6:
            return @"07";
            break;
        case 7:
            return @"08";
            break;
        case 8:
            return @"09";
            break;
        case 9:
            return @"10";
            break;
        case 10:
            return @"11";
            break;
        case 11:
            return @"12";
            break;
        case 12:
            return @"13";
            break;
        case 13:
            return @"14";
            break;
        case 14:
            return @"15";
            break;
        case 15:
            return @"16";
            break;
        case 16:
            return @"17";
            break;
        case 17:
            return @"18";
            break;
        case 18:
            return @"19";
            break;
        case 19:
            return @"20";
            break;
        case 20:
            return @"21";
            break;
        case 21:
            return @"22";
            break;
        case 22:
            return @"23";
            break;
        case 23:
            return @"24";
            break;
        case 24:
            return @"25";
            break;
        case 25:
            return @"26";
            break;
        case 26:
            return @"27";
            break;
        case 27:
            return @"28";
            break;
        case 28:
            return @"29";
            break;
        case 29:
            return @"30";
            break;
        case 30:
            return @"31";
            break;
            
        default:
            break;
    }
    
    return @"01";
}
@end
