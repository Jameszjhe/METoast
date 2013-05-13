# METoast

`METoast` is a view to show toast message. It's a queue based FIFO toast.

![METoast](http://i39.tinypic.com/5ueruo.png)

## Usage ##

Show a toast message
```Objective-c
[METoast toastWithMessage:@"On the top of the screen!"];
```
Configure a toast
```Objective-c
METoastAttribute *attr = [[METoastAttribute alloc] init];
attr.location = METoastLocationMiddle;
[METoast setToastAttribute:attr];
[METoast toastWithMessage:@"On the middle of the screen!"];
[attr release];
```
Complete block
```Objective-c
[METoast toastWithMessage:@"Hello James"
    	andCompleteBlock:^{
    		// TODO: things to do
        }];
```