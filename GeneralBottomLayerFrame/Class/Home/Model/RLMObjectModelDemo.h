//
//  RLMObjectModelDemo.h
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2019/3/29.
//  Copyright © 2019年 jimmy. All rights reserved.
//

#import "RLMObject.h"

NS_ASSUME_NONNULL_BEGIN

//@interface RLMObjectModelPerson : RLMArray
//
//@property NSArray<RLMObjectModelDemo*><RLMObjectModelDemo> * modelDemo;
//
//@property NSString  *  name;
//
//
//@end



@interface RLMObjectModelDemo : RLMObject


@property NSString * dogName;

@property NSData   * allData;

@property NSInteger  ages;



@end

NS_ASSUME_NONNULL_END
