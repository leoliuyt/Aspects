//
//  AspectsViewController.m
//  AspectsDemo
//
//  Created by Peter Steinberger on 05/05/14.
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//

#import "AspectsViewController.h"
#import "Aspects.h"
#import "Person.h"
#import "Son.h"
#import <objc/runtime.h>
#import <objc/objc.h>
#import <objc/message.h>

@implementation AspectsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Person *p = [Person new];
//    Son *p = [Son new];
    
//    Method md = class_getInstanceMethod(p.class, @selector(test2));
//    IMP imp = method_getImplementation(md);
//
//    Method md1 = class_getInstanceMethod(p.class, @selector(test1));
//    IMP imp1 = method_getImplementation(md1);
//
//    const char * types = method_getTypeEncoding(md);
//    IMP originalImplementation = class_replaceMethod(p.class, @selector(test1), imp, types);
//
//    if (originalImplementation) {//当前类中没有test1 方法 但是父类中实现了 originalImplementation == nil
//        class_addMethod(p.class, NSSelectorFromString(@"aa_test"), originalImplementation, types);
//    }
//    [p test1];
    
    Method md = class_getInstanceMethod(p.class, @selector(test1));
    IMP i = getMsgForwardIMP(p, @selector(test1));
    if (!class_addMethod(Person.class, @selector(test1), i, method_getTypeEncoding(md))) {
        class_replaceMethod(Person.class, @selector(test1),  i, method_getTypeEncoding(md));
    }
    [p test1];
//    [p performSelector:@selector(aa_test) withObject:nil];
}

static IMP getMsgForwardIMP(NSObject *self, SEL selector) {
    IMP msgForwardIMP = _objc_msgForward;
#if !defined(__arm64__)
    // As an ugly internal runtime implementation detail in the 32bit runtime, we need to determine of the method we hook returns a struct or anything larger than id.
    // https://developer.apple.com/library/mac/documentation/DeveloperTools/Conceptual/LowLevelABI/000-Introduction/introduction.html
    // https://github.com/ReactiveCocoa/ReactiveCocoa/issues/783
    // http://infocenter.arm.com/help/topic/com.arm.doc.ihi0042e/IHI0042E_aapcs.pdf (Section 5.4)
    Method method = class_getInstanceMethod(self.class, selector);
    const char *encoding = method_getTypeEncoding(method);
    BOOL methodReturnsStructValue = encoding[0] == _C_STRUCT_B;
    if (methodReturnsStructValue) {
        @try {
            NSUInteger valueSize = 0;
            NSGetSizeAndAlignment(encoding, &valueSize, NULL);
            
            if (valueSize == 1 || valueSize == 2 || valueSize == 4 || valueSize == 8) {
                methodReturnsStructValue = NO;
            }
        } @catch (__unused NSException *e) {}
    }
    if (methodReturnsStructValue) {
        msgForwardIMP = (IMP)_objc_msgForward_stret;
    }
#endif
    return msgForwardIMP;
}


- (IBAction)buttonPressed:(id)sender {
    
//    UIViewController *testController = [[UIImagePickerController alloc] init];
//
//    testController.modalPresentationStyle = UIModalPresentationFormSheet;
//    [self presentViewController:testController animated:YES completion:NULL];
//
//    // We are interested in being notified when the controller is being dismissed.
//    [testController aspect_hookSelector:@selector(viewWillDisappear:) withOptions:0 usingBlock:^(id<AspectInfo> info, BOOL animated) {
//        UIViewController *controller = [info instance];
//        if (controller.isBeingDismissed || controller.isMovingFromParentViewController) {
//            [[[UIAlertView alloc] initWithTitle:@"Popped" message:@"Hello from Aspects" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
//        }
//    } error:NULL];
//
//    // Hooking dealloc is delicate, only AspectPositionBefore will work here.
//    [testController aspect_hookSelector:NSSelectorFromString(@"dealloc") withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> info) {
//        NSLog(@"Controller is about to be deallocated: %@", [info instance]);
//    } error:NULL];
}

+ (void)classFunc{
    NSLog(@"%s",__func__);
}

@end
