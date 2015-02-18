//
//  FiltersViewController.m
//  Yelp
//
//  Created by Sean Dy on 2/16/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "switchCell.h"
#import "ClickCell.h"

float milesToMeters = 1609.34;

@interface FiltersViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, readonly) NSDictionary *filters;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSMutableSet *selectedCategories;
@property (nonatomic, strong) NSArray *sort;
@property (nonatomic, assign) NSInteger sortIndex;
@property (nonatomic, strong) NSMutableSet *selectedSort;
@property (nonatomic, assign) BOOL showSort;
@property (nonatomic, assign) BOOL deal;
@property (nonatomic, assign) BOOL showDistances;
@property (nonatomic, assign) NSInteger distanceIndex;
@property (nonatomic, strong) NSArray *distances;
@property (nonatomic, strong) NSMutableSet *selectedDistance;
@property (nonatomic, strong) NSMutableArray *orderedDistance;
@property (nonatomic, strong) NSMutableArray *orderedSort;
- (void)initCategories;
- (void)initSort;
- (void)initDistances;


@end

@implementation FiltersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.selectedCategories = [NSMutableSet set];
        [self initCategories];
        self.selectedSort = [NSMutableSet set];
        [self initSort];
        self.selectedDistance = [NSMutableSet set];
        [self initDistances];
        self.orderedDistance = [NSMutableArray arrayWithArray:self.distances];
        self.orderedSort = [NSMutableArray arrayWithArray:self.sort];

    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(onApplyButton)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.showSort = false;
    self.showDistances = false;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"switchCell" bundle:nil] forCellReuseIdentifier:@"switchCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ClickCell" bundle:nil] forCellReuseIdentifier:@"ClickCell"];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0)
        return @"Categories";
    
    if (section == 1)
        return @"Sort By";
    
    if (section == 2)
        return @"Distance";
    
    if (section == 3)
        return @"Most Popular";
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) //Categories
        return 4;
    if (section == 1) {
        if (self.showSort) {
            return 3;
        } else {
            return 1;
        }
    }//sort by
    
    if (section == 2) //Distance
        if (self.showDistances) {
            return 5;
        } else {
            return 1;
        }
    if (section == 3) //most popular (deals)
        return 1;
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0)
    {
        switchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"switchCell"];
        cell.switchLabel.text = self.categories[indexPath.row][@"name"];
        cell.on = [self.selectedCategories containsObject:self.categories[indexPath.row]];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section ==1) {
        ClickCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClickCell"];
        cell.settingsLabel.text = self.orderedSort[indexPath.row][@"name"];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section ==2) {
        ClickCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClickCell"];
        cell.settingsLabel.text = self.orderedDistance[indexPath.row][@"name"];
        //        cell.option = [self.selectedCategories containsObject:self.categories[indexPath.row]];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section ==3)
    {
        switchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"switchCell"];
        cell.switchLabel.text = @"Deal";
        cell.on = self.deal;
        cell.delegate = self;
        return cell;
    }
    
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1) {
        if(self.showSort) {
            self.showSort =  FALSE;
            //hide other options
            [self.selectedSort removeAllObjects];
            [self.selectedSort addObject:self.sort[indexPath.row]];
            self.sortIndex = indexPath.row;
        } else {
            self.showSort = TRUE;
        }
        //make new array to always move set params up as it closes
        //clear array
        [self.orderedSort removeAllObjects];
        NSInteger x = self.sortIndex;
        for (NSInteger i = 0 ; i < 3; i++){
            NSLog(@"%ld", x);
            [self.orderedSort addObject:self.sort[x]];
            x++;
            if (x ==3) {
                x = 0;
            }
            
        }
        NSLog(@"%@", self.orderedSort);
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    //make modular
    if(indexPath.section == 2) {
        if(self.showDistances) {
            self.showDistances =  FALSE;
            //hide other options
            [self.selectedDistance removeAllObjects];
            [self.selectedDistance addObject:self.distances[indexPath.row]];
            self.distanceIndex = indexPath.row;
        } else {
            self.showDistances = TRUE;
        }
        //make new array to always move set params up as it closes
        //clear array
        [self.orderedDistance removeAllObjects];
        NSInteger x = self.distanceIndex;
        for (NSInteger i = 0 ; i < 4; i++){
            NSLog(@"%ld", x);
            [self.orderedDistance addObject:self.distances[x]];
            x++;
            if (x == 4) {
                x = 0;
            }
            
        }
        NSLog(@"%@", self.orderedDistance);
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Switch Cell Delegate Methods

- (void)switchCell:(switchCell *)cell didUpdateValue:(BOOL)value {
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section ==1) {
        if (value) {
            [self.selectedCategories addObject:self.categories[indexPath.row]];
        } else
            [self.selectedCategories removeObject:self.categories[indexPath.row]];
    } else if (indexPath.section ==3) {
        self.deal = value;
    }
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Private methods

- (NSDictionary *) filters {
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    if (self.selectedCategories.count >0) {
        NSMutableArray *names = [NSMutableArray array];
        for (NSDictionary *category in self.selectedCategories) {
            [names addObject:category[@"code"]];
        }
        NSString *categoryFilter = [names componentsJoinedByString:@","];
        [filters setObject:categoryFilter forKey:@"category_filter"];
        
    }
    
    float distance  = milesToMeters * [self.distances[self.distanceIndex][@"code"] floatValue];
    
    [filters setObject:[NSString stringWithFormat:@"%ld",self.sortIndex] forKey:@"sort"];
    [filters setObject:[NSString stringWithFormat:@"%f",distance]  forKey:@"distance"];
    [filters setObject:[NSString stringWithFormat:@"%d",self.deal]  forKey:@"deal"];

    
    NSLog(@"Filters: %@", filters);
    return filters;
}

- (void)onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onApplyButton {
    [self.delegate filtersViewController:self didChangeFilters:self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];    
}

- (void)initCategories {
    self.categories = @[@{@"name":@"Japanese", @"code":@"japanese"},
                        @{@"name":@"Chinese", @"code":@"chinese"},
                        @{@"name":@"American (New)", @"code":@"newamerican"},
                        @{@"name":@"American (Traditional)", @"code":@"tradamerican"},
                        @{@"name":@"Deal", @"code":@TRUE},];
                          
}

- (void)initSort {
    self.sort = @[@{@"name":@"Best Match", @"code":@"0"},
                        @{@"name":@"Distance", @"code":@"1"},
                        @{@"name":@"Highest Rated", @"code":@"2"}];
    
}

- (void)initDistances {
    self.distances = @[@{@"name":@"Best Match", @"code":@0},
                  @{@"name":@"1 mile", @"code":@1},
                  @{@"name":@"5 miles", @"code":@5},
                  @{@"name":@"20 miles", @"code":@20}];
    
}

@end
