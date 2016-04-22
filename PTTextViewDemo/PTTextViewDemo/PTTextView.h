//
//  PTTextView.h
//  ImageTextEdition
//
//  Created by Peter on 16/3/27.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTTextView;

@protocol PTTextViewDelegate <NSObject>

@optional

- (BOOL)textViewShouldBeginEditing:( PTTextView * _Nonnull )textView;
- (BOOL)textViewShouldEndEditing:(PTTextView * _Nonnull)textView;

- (void)textViewDidBeginEditing:(PTTextView * _Nonnull)textView;
- (void)textViewDidEndEditing:(PTTextView * _Nonnull)textView;

- (BOOL)textView:(PTTextView * _Nonnull)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString * _Nonnull)text;
- (void)textViewDidChange:(PTTextView * _Nonnull)textView;

@end

@interface PTTextView : UIView

@property (null_resettable,nonatomic,copy) NSString *placeHolder;
@property (nullable,nonatomic,strong) UIColor *placeHolderColor;
@property (nullable,nonatomic,strong) UIColor *textColor;
@property (nullable,nonatomic,strong) UIFont *font;
@property (null_resettable,nonatomic,copy) NSString *text;
@property (nonatomic, assign) NSInteger lineSpace;
@property (nonatomic, assign) BOOL autoResizeingHeight;

@property (nonatomic, weak) id<PTTextViewDelegate> delegate;

@end
