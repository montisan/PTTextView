//
//  PTTextView.m
//  ImageTextEdition
//
//  Created by Peter on 16/3/27.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "PTTextView.h"


@interface PTTextView()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeholderLabel;

@property (nonatomic, copy) NSDictionary *attributes;
@property (nonatomic, assign) int borderWidth;
@property (nonatomic, assign) int borderHeight;

@end

@implementation PTTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self loadSubviewsAndConfig];
    }
    
    return self;
}

- (void)loadSubviewsAndConfig
{
    UIFont *defaultFont = [UIFont systemFontOfSize:15];
    
    _placeholderLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _placeholderLabel.numberOfLines = 0;
    _placeholderLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _placeholderLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_placeholderLabel];
    
    _placeholderLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin
    | UIViewAutoresizingFlexibleHeight
    | UIViewAutoresizingFlexibleRightMargin
    | UIViewAutoresizingFlexibleLeftMargin
    | UIViewAutoresizingFlexibleTopMargin
    | UIViewAutoresizingFlexibleWidth;
    
    _placeholderLabel.font = defaultFont;
    _placeholderLabel.textColor = [UIColor grayColor];
    
    _textView = [[UITextView alloc] initWithFrame:self.bounds];
    _textView.autoresizingMask = _placeholderLabel.autoresizingMask;
    _textView.font = defaultFont;
    _textView.textColor = [UIColor blackColor];
    _textView.delegate = self;
    _textView.backgroundColor = [UIColor clearColor];
    [self addSubview:_textView];
    
    
    _borderWidth    = (_textView.contentInset.left
                            + _textView.contentInset.right
                            + _textView.textContainerInset.left
                            + _textView.textContainerInset.right
                            + _textView.textContainer.lineFragmentPadding
                            + _textView.textContainer.lineFragmentPadding);
    
    _borderHeight  = (_textView.contentInset.top
                            + _textView.contentInset.bottom
                            + _textView.textContainerInset.top
                            + _textView.textContainerInset.bottom);
    
    _placeholderLabel.hidden = _textView.text.length > 0;
    _textView.bounces = NO;
    
    [self updateAtrtributes];
    
    [self setAutoResizeingHeight:YES];
    
}

- (void)updateAtrtributes
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = _textView.textContainer.lineBreakMode;
    paragraphStyle.lineSpacing = _lineSpace;
    self.attributes = @{NSFontAttributeName:_textView.font, NSParagraphStyleAttributeName:[paragraphStyle copy]};
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeholderLabel.text = placeHolder;
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor
{
    _placeholderLabel.textColor = placeHolderColor;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textView.textColor = textColor;
}

- (void)setFont:(UIFont *)font
{
    _textView.font = font;
    _placeholderLabel.font = font;
    
    [self updateAtrtributes];
    
    if (_autoResizeingHeight)
    {
        [self autoHeightWithText:_textView.text];
    }
}

- (void)setText:(NSString *)text
{
    _textView.text = text;
    _textView.attributedText = [self attributedTextWithText:text];
    _placeholderLabel.hidden = _textView.text.length > 0;
    
    if (_autoResizeingHeight)
    {
        [self autoHeightWithText:text];
    }
    
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    _textView.attributedText = attributedText;
    _textView.text = [attributedText string];
    
    if (_autoResizeingHeight)
    {
        [self autoHeightWithText:_textView.text];
    }
}

- (void)setAutoResizeingHeight:(BOOL)autoResizeingHeight
{
    _autoResizeingHeight = autoResizeingHeight;
    
    if (_autoResizeingHeight)
    {
        [self autoHeightWithText:_textView.text];
    }
}

- (void)setLineSpace:(NSInteger)lineSpace
{
    _lineSpace = lineSpace;
    
    [self updateAtrtributes];
}

- (NSAttributedString *)attributedTextWithText:(NSString *)text
{
    return [[NSAttributedString alloc] initWithString:text attributes:self.attributes];
}

- (CGSize)getSizeInTextViewWithText:(NSString *)text;
{

    CGFloat contentWidth = CGRectGetWidth(_textView.frame);
 
    contentWidth -= _borderWidth;
    
    CGSize InSize = CGSizeMake(contentWidth, MAXFLOAT);
    
    CGSize calculatedSize =  [text boundingRectWithSize:InSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:self.attributes context:nil].size;
    
    CGSize adjustedSize = CGSizeMake(ceilf(calculatedSize.width),calculatedSize.height + _borderHeight);
    
    return adjustedSize;
}

- (NSString *)textWithOldText:(NSString *)oldText byChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *newText = nil;
    
    if (range.location >= [oldText length])
    {
        newText = [oldText stringByAppendingString:text];
    }
    else
    {
        newText = [oldText stringByReplacingCharactersInRange:range withString:text];
    }
    
    return newText;
}

- (void)autoHeightWithText:(NSString *)text
{
    CGSize size = [self getSizeInTextViewWithText:text];
    
    CGRect frame = self.frame;
    frame.size.height = size.height;
    self.frame = frame;
}


#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(textViewShouldBeginEditing:)])
    {
        return [self.delegate textViewShouldBeginEditing:self];
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(textViewShouldEndEditing:)])
    {
        [self.delegate textViewShouldEndEditing:self];
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(textViewDidBeginEditing:)])
    {
        [self.delegate textViewDidBeginEditing:self];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(textViewDidEndEditing:)])
    {
        [self.delegate textViewDidEndEditing:self];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (_autoResizeingHeight)
    {
        NSString *newText = [self textWithOldText:[textView text] byChangeTextInRange:range replacementText:text];
        
        [self autoHeightWithText:newText];
    }
    
    
    if ([self.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)])
    {
        return [self.delegate textView:self shouldChangeTextInRange:range replacementText:text];
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (_autoResizeingHeight)
    {
        [self autoHeightWithText:_textView.text];
    }
    
    if(_textView.markedTextRange == nil)
    {
        _textView.attributedText = [self attributedTextWithText:_textView.text];
        _placeholderLabel.hidden = _textView.text.length > 0;
    }
    
    
    if ([self.delegate respondsToSelector:@selector(textViewDidChange:)])
    {
        [self.delegate textViewDidChange:self];
    }
}


@end
