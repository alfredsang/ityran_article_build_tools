Block使用中的一些疑问解答和实例
=============================================================

归类于Cocoa Touch | 泰然官方查看:195 | 2012-05-09
Rating: 0.0/10 (0 votes cast)
本文由泰然教程组 jesse 原创，版权所有，转载请注明原出处，并通知原作者！！！

原文地址：[http://jessex.me/?p=181](ss)

本文主要是阐述一下Block中如何的使用外部变量以及block本身的内存管理。

先定义一个block变量，作为后续的例子中使用：

    typedef void(^BlockCC)(void);
    BlockCC _block;

1、block中引用外部变量
-------------------------------------------------------------
block中可以直接使用外部的变量，比如

    int number = 1;
    _block = ^(){
        NSLog(@"number %d", number);
    };

那么实际上，在block生成的时候，是会把number当做是常量变量编码到block当中。可以看到，以下的代码，block中的number值是不会发生变化的：

    int number = 1;
    _block = ^(){
        NSLog(@"number %d", number);
    };
    number = 2;
    _block();

则输出的值为 1，而不是2。原因就是如上所说。

如果要在block中尝试改变外部变量的值，则会报错的。对于这个问题的解决办法是引入__block标识符。将需要在block内部修改的变量标识为__block scope。更改后的代码如下：

    __block int number = 1;
    _block = ^(){
        number++;
        NSLog(@"number %d", number);
    };

而这个时候，其实block外部的number和block内部的number指向了同一个值，回到刚才的在外部改变block的例子，它的输出结果将是2，而不是1。有兴趣的可以自己写一个例子试试。


2、block自身的内存管理
-------------------------------------------------------------

block本身是像对象一样可以retain，和release。但是，block在创建的时候，它的内存是分配在栈(stack)上，而不是在堆(heap)上。他本身的作于域是属于创建时候的作用域，一旦在创建时候的作用域外面调用block将导致程序崩溃。比如下面的例子。
我在view did load中创建了一个block：

    - (void)viewDidLoad
    {
        [superviewDidLoad];
     
        int number = 1;
        _block = ^(){
     
        NSLog(@"number %d", number);
    };
    
并且在一个按钮的事件中调用了这个block：

    - (IBAction)testDidClick:(id)sender {
        _block();
    }
    
此时我按了按钮之后就会导致程序崩溃，解决这个问题的方法就是在创建完block的时候需要调用copy的方法。copy会把block从栈上移动到堆上，那么就可以在其他地方使用这个block了~
修改代码如下：

    _block = ^(){
        NSLog(@"number %d", number);
    };
     
    _block = [_blockcopy];



同理，特别需要注意的地方就是在把block放到集合类当中去的时候，如果直接把生成的block放入到集合类中，是无法在其他地方使用block，必须要对block进行copy。不过代码看上去相对奇怪一些：
    
    [array addObject:[[^{
        NSLog(@"hello!");
    } copy] autorelease]];
     

3、循环引用
-------------------------------------------------------------

这一点其实是在第一点的一个小的衍生。当在block内部使用成员变量的时候，比如

 
    
    @interface ViewController : UIViewController
    {
        NSString *_string;
    }
    @end



在block创建中：
    
    _block = ^(){
        NSLog(@"string %@", _string);
    };



这里的_string相当于是self->_string；那么block是会对内部的对象进行一次retain。也就是说，self会被retain一次。当self释放的时候，需要block释放后才会对self进行释放，但是block的释放又需要等self的dealloc中才会释放。如此一来变形成了循环引用，导致内存泄露。
修改方案是新建一个__block scope的局部变量，并把self赋值给它，而在block内部则使用这个局部变量来进行取值。因为__block标记的变量是不会被自动retain的。

 

    __block ViewController *controller = self;
    _block = ^(){
        NSLog(@"string %@", controller->_string);
    };
    
先写到这里，基本是我在用block时候碰到的一些问题。需要更详细的解释，可以看看《Adanced Mac OS X Programming》这本书，推荐给大家。


4、实例
-------------------------------------------------------------

block在开发中有非常多的场景，举个简单的例子，从UIAlertView 开始

常用方式是实现UIAlertViewDelegate，然后在方法中通过tag来判定是哪个alertView，继而根据buttonIndex来实现不同的业务逻辑。

	- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
	{
	    switch (alertView.tag) 
	    {
	        case 1:
	         	{
	               if (buttonIndex == 1)
	               {
	                   //do something
	               }
	           }
	           break;
           
	        case 2:
	            if (buttonIndex == 0)
	            {
	                //do something
	            }
	            break;
	        default:
	            break;
	    }
	}

如果一个视图里有很多alertView就会比较麻烦，所有业务逻辑都纠结到一起，代码会变得臃肿难度。
那么能不能不实现UIAlertViewDelegate，把业务逻辑和alertView放在一起呢？

No320TAlertView的使用方式
-------------------------------------------------------------
首先创建No320TAlertView实例
	
	No320TAlertView *alert = [[No320TAlertView alloc] 
		initWithTitle:@"test"
		 message:@"这个组件是为了测试带有闭包的No320TAlertView用法"];
方式1：

	 void (^ssClickCB)() = ^() {
	     NSLog(@"ssClickCB:INFO");
	 };

	[alert addButtonWithAction:@"ssClickTest"
	 	callback: ssClickCB];

方式2：

	[alert addButtonWithAction:@"ddClickTest" callback:^(void) {
	    NSLog(@"ddClickTest:INFO");
	    No320TAlertView *alert = [[No320TAlertView alloc] 
			initWithTitle:@"确认之再确认信息标题" 
			message:@"确认之再确认信息标题提示：会用了没？不点2秒钟之后也会自动关闭"];
	    [alert addButtonWithAction:@"不会也得会" callback: nil];
	    [alert show];
	    [alert disappear:2];
	    [alert release];
	}];

其他功能：
	[alert disappear:5];  
	//[alert addCancelButtonTitle:@"cancle"];
	[alert show];
	[alert release];

No320TAlertView.h
-------------------------------------------------------------

	//
	//  No320TAlertView.h
	//  no320.com
	//
	//  Created by iwill on 2011-05-21.
	//  Modified by shiren1118 on 2011-11-22.
	//  Copyright 2011 no320.com. All rights reserved.
	//

	#import <Foundation/Foundation.h>

	@interface No320TAlertView : UIAlertView <UIAlertViewDelegate>

	// The only initialize method!!
	- (id) initWithTitle:(NSString *)title
	 			message:(NSString *)message;

	//增加按钮方法
	- (NSInteger) addButtonWithAction:(NSString *)title 
				callback:(void (^)())callback;
	- (NSInteger) addCancelButtonWithAction:(NSString *)title 
				callback:(void (^)())callback;
	- (NSInteger) addButton:(NSString *)title;
	- (NSInteger) addCancelButton:(NSString *)title;

	//自动消失
	- (void) disappear:(int)seconds;

	@end


No320TAlertView.m
-------------------------------------------------------------

	#import "No320TAlertView.h"

	@interface No320TAlertView ()

	@property (nonatomic, readwrite, retain) NSMutableArray *callbacks;

	@end


	@interface No320TAlertView (Private)

	- (void) handleHideSelf;

	@end


	@implementation No320TAlertView

	@synthesize callbacks = _callbacks;

	#pragma mark - init

	- (id) initWithTitle:(NSString *)title message:(NSString *)message {
	    self = [super initWithTitle:title 
				message:message delegate:self 
				cancelButtonTitle:nil 
				otherButtonTitles:nil];
	    if (self) {
	        NSMutableArray *callbacks = [[NSMutableArray alloc] init];
	        self.callbacks = callbacks;
	        [callbacks release];
	        [super setDelegate:self];
	    }
	    return self;
	}

	#pragma mark - lifeCycle

	- (void) dealloc {
	    self.callbacks = nil;
	    // super dealloc: it maybe self.delegate = nil;
	    // that will not release the delegate, because setDelegate is overrided and nothing to do.
	    [super setDelegate:nil];
	    [super dealloc];
	}

	#pragma mark - Private Method Implemetion

	- (void)handleHideSelf {
	    NSLog(@"No320TAlertView INFO: 
			{title=[%@],message=[%@]} will disAppear",
			[self title],[self message]);
	    [self setHidden:YES];
	}

	#pragma mark - Public Method Implemetion

	- (NSInteger) addButton:(NSString *)title {
	    return [self addButtonWithAction:title 
					callback:nil];
	}

	- (NSInteger) addCancelButton:(NSString *)title {
	    return [self addCancelButtonWithAction:title callback:nil];
	}

	- (NSInteger) addButtonWithAction:(NSString *)title 
				callback:(void (^)())callback{
	    if (!title) {
	        return - 1;
	    }
    
	    if (!callback) {
	        //default
	        callback = ^() {
	            NSLog(@"No320TAlertView INFO: 
					Buttons[%@]has no callback block and do nothing."
					,title);
	        };
	    }
	    callback = [callback copy];
	    [self.callbacks addObject:callback];
	    [callback release];
    
	    return [super addButtonWithTitle:title];
	}

	- (NSInteger) addCancelButtonWithAction:(NSString *)title 
			callback:(void (^)())callback{
	    NSInteger index = [self addButtonWithAction:title 
			callback:callback];
	    if (index >= 0) {
	        self.cancelButtonIndex = index;
	    }
	    return index;
	}

	- (void) disappear:(int)seconds{
	    [NSTimer scheduledTimerWithTimeInterval:seconds
	                                     target:self
	                                   selector:@selector(handleHideSelf)
	                                   userInfo:nil
	                                    repeats:NO];
	}

	#pragma mark - override super methods

	- (id) delegate {
	    return nil;
	}

	- (void) setDelegate:(id)delegate {
	}

	#pragma mark - UIAlertViewDelegate

	- (void) alertView:(UIAlertView *)alertView
	 		clickedButtonAtIndex:(NSInteger)buttonIndex {
	    if (buttonIndex >= 0 && buttonIndex < self.callbacks.count) {
	        void (^callback)() = [self.callbacks objectAtIndex:buttonIndex];
	        if (callback) {
	            callback(buttonIndex, [self buttonTitleAtIndex:buttonIndex]);
	        }
	    }
	}

	- (void) alertViewCancel:(UIAlertView *)alertView {
	    [self alertView:self clickedButtonAtIndex:self.cancelButtonIndex];
	}


	@end



视图定义原理简析
-------------------------------------------------------------

1、先看定义No320TAlertView继承自UIAlertView，并实现了UIAlertViewDelegate,也就是说它就是UIAlertView
2、我们看[增加按钮方法]方法部分，都是用block的
比如

	- (NSInteger) addButtonWithAction:(NSString *)title 
		callback:(void (^)())callback;
		
3、但是如何存储呢？我怎么知道是哪个按钮来响应对应的block呢？
其实代码里有一个NSMutableArray用于缓存所有的按钮响应的闭包。
@property (nonatomic, readwrite, retain) NSMutableArray *callbacks;
4、核心，仍然是UIAlertViewDelegate

	#pragma mark - UIAlertViewDelegate

	- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	    if (buttonIndex >= 0 && buttonIndex < self.callbacks.count) {
	        void (^callback)() = [self.callbacks objectAtIndex:buttonIndex];
	        if (callback) {
	            callback(buttonIndex, [self buttonTitleAtIndex:buttonIndex]);
	        }
	    }
	}

	- (void) alertViewCancel:(UIAlertView *)alertView {
	    [self alertView:self clickedButtonAtIndex:self.cancelButtonIndex];
	}
	
5、至此，完成了所有的使用方式的改变。

结语
-------------------------------------------------------------
从ios4开始就支持block，并且此项改进已提交到c标准委员会，使用起来确实非常方便，所以在以后的API里很有可能都改成block方式。
请大家拭目以待吧。


 
更多教程
----------
* [泰然翻译小组官方网址](http://article.ityran.com/)      
<br />


Contact:
  If you experience bugs or want to request new features please visit 
  <http://article.ityran.com/>, if you have any
problems
  or comments please feel free to contact me: see 
  <http://www.ityran.com/forum.php/>

