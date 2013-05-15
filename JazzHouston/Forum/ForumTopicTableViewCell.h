//
//  ForumTopicTableViewCell.h
//  SocialApp
//
//  Created by Mr. Shoe on 3/16/13.
//
//

#import <UIKit/UIKit.h>

@interface ForumTopicTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *authorLabel;
@property (nonatomic, weak) IBOutlet UILabel *lastPostLabel;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *numberOfPostsLabel;

@end
