//
//  ViewController.m
//  KobeNews
//
//  Created by kobelin on 2019/12/24.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+Title.h"
#import "NewsModel.h"
#import "AFNetworking.h"
#import "SDWebImage/SDWebImage.h"
#import "MYViewController.h"

#define screenHeight [UIScreen mainScreen].bounds.size.height
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define mainScreenOffSetHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define marginY 0.01*[UIScreen mainScreen].bounds.size.height
#define marginX 0.01*[UIScreen mainScreen].bounds.size.width
#define ScrollNewsCount 5

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray *newsArray;
@property (nonatomic, strong)NSMutableArray *newsImageArray;
@property (nonatomic, strong)NSMutableArray *headerNewsArray;
@property (nonatomic, strong)UISegmentedControl *segmentedControl;
@property (nonatomic, strong)UIScrollView *headerNewsScrollPlayer;
@property (nonatomic, strong)UITableView *tableView;

@end

@implementation ViewController

- (void)loadHeaderNewsScrollPlayerData
{
    
    CGRect headerNewsScrollPlayerFrame = self.headerNewsScrollPlayer.frame;
    for(int i=0;i<_newsArray.count;i++)
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*screenWidth, 0, self.headerNewsScrollPlayer.frame.size.width, self.headerNewsScrollPlayer.frame.size.height)];
        NewsModel *model = self.newsArray[i];
        [imgView sd_setImageWithURL:[[NSURL alloc]initWithString:model.newsImage]];
        [imgView addTitle:model.newsTitle];
        NSLog(@"头部标题:%@",model.newsTitle);
        imgView.clipsToBounds=true;
        [imgView setContentMode:UIViewContentModeScaleToFill];
        [self.headerNewsScrollPlayer addSubview:imgView];
    }
    self.headerNewsScrollPlayer.contentSize = CGSizeMake(screenWidth * 5, headerNewsScrollPlayerFrame.size.height);
    self.headerNewsScrollPlayer.pagingEnabled = YES;
}

- (void)loadSubViews
{
    [self getNews];
    int navigationControllerBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,self.headerNewsScrollPlayer.frame.origin.y + self.headerNewsScrollPlayer.frame.size.height, screenWidth, screenHeight -self.headerNewsScrollPlayer.frame.origin.y - self.headerNewsScrollPlayer.frame.size.height) style:UITableViewStylePlain];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
                             
}

- (void)changePageContent
{
    [self.newsArray removeAllObjects];
    [self.newsImageArray removeAllObjects];
    [self loadSubViews];
}

#pragma Decode-Model

- (void)getNews
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSArray *tagTitles = @[@"toutiao", @"shehui", @"keji", @"yule", @"tiyu", @"junshi"];
    NSString *juHeShuJuKey = @"e5c944d13ffcb73dc39aed78e528ddf3";
//    juHeShuJuKey = @"aac5ceb82beb0fbdff4210f12a004608";
//    juHeShuJuKey = @"27d98876a75e6fb3f9eac28f71d807a0";
//    juHeShuJuKey = @"89b6c98a78e2e7d365a06c380ffe38af";
//    juHeShuJuKey = @"32b9973df2e6ee0c2bf094b61c7d7844";
    juHeShuJuKey = @"e79de06ab95e2b39dc62b5783bb42739";
//    juHeShuJuKey = @"b5bbc1256b3f6cc13f289117babe4b41";
    //juHeShuJuKey = @"62d2d93f806c19671fb6b443127bea17";
    juHeShuJuKey = @"8b7c45a06ba583baa5d17c0b2f88a4e0";
    if(self.segmentedControl.selectedSegmentIndex<0)self.segmentedControl.selectedSegmentIndex = 0;
    NSDictionary *parameters = @{@"type":tagTitles[self.segmentedControl.selectedSegmentIndex],@"key":juHeShuJuKey};
    NSString *urlStr1 = @"http://v.juhe.cn/toutiao/index";
    [manager GET:urlStr1 parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *newDic = [responseObject valueForKeyPath:@"result"];
        NSArray *newsArray = newDic[@"data"];
        [self extractNewsData:newsArray];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    parameters = @{@"type":tagTitles[self.segmentedControl.selectedSegmentIndex],@"key":juHeShuJuKey};
       urlStr1 = @"http://v.juhe.cn/toutiao/index";
       [manager GET:urlStr1 parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
           NSDictionary *newDic = [responseObject valueForKeyPath:@"result"];
           NSArray *newsArray = newDic[@"data"];
           [self extractNewsData:newsArray];
           [self loadHeaderNewsScrollPlayerData];
       } failure:^(NSURLSessionTask *operation, NSError *error) {
           NSLog(@"Error: %@", error);
       }];
}

- (void)extractNewsData:(NSArray *)newsArray
{
    for (NSInteger i = 0; i < [newsArray count]; i++) {
        NewsModel *model = [[NewsModel alloc] init];
        model.newsTitle = newsArray[i][@"title"];
        NSLog(@"%@",model.newsTitle);
        model.newsImage = newsArray[i][@"thumbnail_pic_s"];
        model.newsUrl = newsArray[i][@"url"];
        NSLog(@"%@",model.newsTitle);
        [self.newsArray addObject:model];
        NSLog(@"%d",_newsArray.count);
        
        NSURL *imgUrl = [[NSURL alloc] initWithString:model.newsImage];
        UIImageView *imgView = [[UIImageView alloc] init];
        [imgView sd_setImageWithURL:imgUrl];
        [self.newsImageArray addObject:imgView];
        if(self.headerNewsArray.count < ScrollNewsCount)
        {
            [self.headerNewsArray addObject:model];
        }
    }
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.segmentedControl.selectedSegmentIndex = 0;
    int navigationControllerBarHeight = self.navigationController.navigationBar.frame.size.height;
    self.headerNewsScrollPlayer = [[UIScrollView alloc] initWithFrame:CGRectMake(0, mainScreenOffSetHeight + navigationControllerBarHeight + 0.045*screenHeight, screenWidth , 0.35*screenHeight)];
    [self.view addSubview:self.headerNewsScrollPlayer];
    self.headerNewsScrollPlayer.backgroundColor = [UIColor whiteColor];
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"推荐",@"社会",@"科技",@"娱乐",@"体育",@"军事"]];
    self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    self.segmentedControl.tintColor = [UIColor blueColor];
    self.segmentedControl.backgroundColor = [UIColor whiteColor];
    self.segmentedControl.frame = CGRectMake(0, mainScreenOffSetHeight + navigationControllerBarHeight, screenWidth, 0.045*screenHeight);
    [self.segmentedControl addTarget:self
              action:@selector(changePageContent)
    forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentedControl];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    
    [self loadSubViews];
    NSLog(@"tot:%d",(int)self.newsArray.count);
    [self loadHeaderNewsScrollPlayerData];
    // Do any additional setup after loading the view.
}



- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NewsModel *model = self.newsArray[indexPath.row];
//    UIImageView *imgView = self.newsImageArray[indexPath.row];
//    cell.imageView.image = imgView.image;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.0, 0.0, cell.frame.size.width - 80, cell.frame.size.height)];
    titleLabel.text = model.newsTitle;
    UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.02*cell.frame.size.height, 80.0, 0.96*cell.frame.size.height)];
    //cell.contentMode = UIViewContentModeScaleAspectFit;
    [cellImageView sd_setImageWithURL:[NSURL URLWithString:model.newsImage]];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [cell.contentView addSubview:cellImageView];
    [cell.contentView addSubview:titleLabel];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _newsArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsModel *model = self.newsArray[indexPath.row];
    MYViewController *webVC = [[MYViewController alloc] init];
    webVC.urlStr = model.newsUrl;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma getter

- (NSMutableArray *)newsArray
{
    if(!_newsArray)
    {
        _newsArray = [[NSMutableArray alloc] init];
    }
    return _newsArray;
}

- (NSMutableArray *)newsImageArray
{
    if(!_newsImageArray)
    {
        _newsImageArray = [[NSMutableArray alloc]init];
    }
    return _newsImageArray;
}

- (NSMutableArray *)headerNewsArray
{
    if(!_headerNewsArray)
    {
        _headerNewsArray = [[NSMutableArray alloc] init];
    }
    return _headerNewsArray;
}

@end
