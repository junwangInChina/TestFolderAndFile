//
//  KTThumbsViewController.m
//  KTPhotoBrowser
//
//  Created by Kirby Turner on 2/3/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "KTThumbsViewController.h"
#import "KTThumbsView.h"
#import "KTThumbView.h"
#import "KTPhotoScrollViewController.h"
#import "GidKTThumbView.h"


@interface KTThumbsViewController (Private)
@end


@implementation KTThumbsViewController
@synthesize m_fileModelArray;
@synthesize dataSource = dataSource_;
@synthesize ktt_delegate;
@synthesize m_gidIsEditing;

- (void)dealloc
{
    [scrollView_ release], scrollView_ = nil;
    self.m_fileModelArray = nil;
    [super dealloc];
}

- (void)loadView {
   // Make sure to set wantsFullScreenLayout or the photo
   // will not display behind the status bar.
   [self setWantsFullScreenLayout:YES];

   KTThumbsView *scrollView = [[KTThumbsView alloc] initWithFrame:CGRectZero];
   [scrollView setDataSource:self];
   [scrollView setController:self];
   [scrollView setScrollsToTop:YES];
   [scrollView setScrollEnabled:YES];
   [scrollView setAlwaysBounceVertical:YES];
   [scrollView setBackgroundColor:[UIColor whiteColor]];
   
   if ([dataSource_ respondsToSelector:@selector(thumbsHaveBorder)]) {
      [scrollView setThumbsHaveBorder:[dataSource_ thumbsHaveBorder]];
   }
   
   if ([dataSource_ respondsToSelector:@selector(thumbSize)]) {
      [scrollView setThumbSize:[dataSource_ thumbSize]];
   }
   
   if ([dataSource_ respondsToSelector:@selector(thumbsPerRow)]) {
      [scrollView setThumbsPerRow:[dataSource_ thumbsPerRow]];
   }
   
   
   // Set main view to the scroll view.
   [self setView:scrollView];
   
   // Retain a reference to the scroll view.
   scrollView_ = scrollView;
   [scrollView_ retain];
   
   // Release the local scroll view reference.
   [scrollView release];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewWillAppear:(BOOL)animated {
  // The first time the view appears, store away the current translucency so we can reset on pop.
  UINavigationBar *navbar = [[self navigationController] navigationBar];
  if (!viewDidAppearOnce_) {
    viewDidAppearOnce_ = YES;
    navbarWasTranslucent_ = [navbar isTranslucent];
  }
  // Then ensure translucency to match the look of Apple's Photos app.
  [navbar setTranslucent:YES];
  [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  // Restore old translucency when we pop this controller.
  UINavigationBar *navbar = [[self navigationController] navigationBar];
  [navbar setTranslucent:navbarWasTranslucent_];
  [super viewWillDisappear:animated];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)willLoadThumbs {
   // Do nothing by default.
}

- (void)didLoadThumbs {
   // Do nothing by default.
}

- (void)reloadThumbs {
   [self willLoadThumbs];
   [scrollView_ reloadData];
   [self didLoadThumbs];
}

- (void)setDataSource:(id <KTPhotoBrowserDataSource>)newDataSource {
   dataSource_ = newDataSource;
   [self reloadThumbs];
}

- (void)didSelectThumbAtIndex:(NSUInteger)index {
   KTPhotoScrollViewController *newController = [[KTPhotoScrollViewController alloc] 
                                                        initWithDataSource:dataSource_ 
                                                  andStartWithPhotoAtIndex:index];
  
   [[self navigationController] pushViewController:newController animated:YES];
   [newController release];
}

/**
 * View层两个按钮的点击事件
 * 0:进入下一页
 * 1:弹出编辑视图
 * 2:选中删除
 */
- (void)didSelectThumbAtIndex:(NSUInteger)index AndPressWhitchBtn:(NSUInteger)btnIndex andChoosed:(BOOL)isChoosed
{
    // 去下一页
    if (btnIndex == 0)
    {
        if (self.ktt_delegate && [self.ktt_delegate respondsToSelector:@selector(toNextPageWithName:)])
        {
            [self.ktt_delegate toNextPageWithName:[[self.m_fileModelArray objectAtIndex:index] m_fileName]];
        }
    }
    // 查看详情
    else if (btnIndex == 1)
    {
        if (self.ktt_delegate && [self.ktt_delegate respondsToSelector:@selector(editFileWithName:)])
        {
            [self.ktt_delegate editFileWithName:[[self.m_fileModelArray objectAtIndex:index] m_fileName]];
        }
    }
    // 选中删除
    else
    {
        if (self.ktt_delegate && [self.ktt_delegate respondsToSelector:@selector(moreDeleteWhenChooseOrFail:andFileName:)])
        {
            [self.ktt_delegate moreDeleteWhenChooseOrFail:isChoosed andFileName:[[self.m_fileModelArray objectAtIndex:index] m_fileName]];
        }
    }
}

#pragma mark -
#pragma mark KTThumbsViewDataSource

- (NSInteger)thumbsViewNumberOfThumbs:(KTThumbsView *)thumbsView
{
   NSInteger count = [dataSource_ numberOfPhotos];
   return count;
}

- (KTThumbView *)thumbsView:(KTThumbsView *)thumbsView thumbForIndex:(NSInteger)index
{
    GidKTThumbView *thumbView = (GidKTThumbView *)[thumbsView dequeueReusableThumbView];
    if (!thumbView)
    {
      thumbView = [[[GidKTThumbView alloc] initWithFrame:CGRectZero] autorelease];
      [thumbView setController:self];
    }

    // Set thumbnail image.
    if ([dataSource_ respondsToSelector:@selector(thumbImageAtIndex:thumbView:)] == NO)
    {
      // Set thumbnail image synchronously.
       UIImage *thumbImage = [dataSource_ thumbImageAtIndex:index];
       [thumbView setThumbImage:thumbImage];
    }
    else
    {
      // Set thumbnail image asynchronously.
       [dataSource_ thumbImageAtIndex:index thumbView:thumbView];
    }
    
    thumbView.m_fileCreateLbl.text = @"";
    thumbView.m_fileNameLbl.text = @"";
    thumbView.m_fileSizeLbl.text = @"";
    
    thumbView.tag = index+100;
    thumbView.m_iconBtn.tag = index+100;
    thumbView.m_deleteBtn.tag = index+100;
    [thumbView sentEditDeleteBtn:self.m_gidIsEditing andIsChoosed:NO];

    if ([self.m_fileModelArray count] > 0)
    {
        // 将Model传递到View层展示
        [thumbView sentFileModelToShow:[self.m_fileModelArray objectAtIndex:index]];
    }
    
   return thumbView;
}


@end
