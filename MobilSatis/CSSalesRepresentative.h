//
//  CSSalesRepresentative.h
//  MobilSatis
//
//  Created by Kerem Balaban on 17.05.2013.
//
//

#import <Foundation/Foundation.h>
#import "CSMapPoint.h"

@interface CSSalesRepresentative : NSObject{
    NSString *kunnr;
    NSString *name2;
    NSString *telf1;
    NSString *tarih;
    NSString *saat;
    CSMapPoint  *locationCoordinate;
}

@property(nonatomic,retain)NSString *kunnr;
@property(nonatomic,retain)NSString *name2;
@property(nonatomic,retain)NSString *telf1;
@property(nonatomic,retain)NSString *tarih;
@property(nonatomic,retain)NSString *saat;
@property(nonatomic,retain)CSMapPoint *locationCoordinate;

@end
