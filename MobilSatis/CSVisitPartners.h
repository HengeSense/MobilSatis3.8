//
//  CSVisitPartners.h
//  MobilSatis
//
//  Created by Kerem Balaban on 28.06.2013.
//
//

#import <Foundation/Foundation.h>

@interface CSVisitPartners : NSObject
{
    NSString  *bayiId;
    NSString  *orgId;
    NSString  *mustturId;
    NSString  *mustgrpId;
    NSString  *mustozlId;
    NSString  *myk;
    NSString  *beginDate;
    NSString  *endDate;
    NSString *litreId;
}

@property (nonatomic,retain) NSString *bayiId;
@property (nonatomic,retain) NSString *orgId;
@property (nonatomic,retain) NSString *mustturId;
@property (nonatomic,retain) NSString *mustgrpId;
@property (nonatomic,retain) NSString *mustozlId;
@property (nonatomic,retain) NSString *myk;
@property (nonatomic,retain) NSString *litreId;
@property (nonatomic,retain) NSString *beginDate;
@property (nonatomic,retain) NSString *endDate;

@end
