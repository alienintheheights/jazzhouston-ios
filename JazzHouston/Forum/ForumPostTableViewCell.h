//
//  ForumPostTableViewCell.h
//  SocialApp
//
//  Created by Mr. Shoe on 3/17/13.
//
//

#import <UIKit/UIKit.h>

@interface ForumPostTableViewCell : UITableViewCell <UIWebViewDelegate>


@property (nonatomic, strong) IBOutlet UIWebView *messageBodyWebView;
@property (weak, nonatomic) IBOutlet UILabel *fullName;

@property (nonatomic, weak) IBOutlet UILabel *authorLabel;
@property (nonatomic, weak) IBOutlet UILabel *postDate;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;


-(void) setCellData:(NSDictionary *) forumTopicData;

@end
