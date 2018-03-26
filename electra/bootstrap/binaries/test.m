// xcrun -sdk iphoneos gcc -dynamiclib -arch arm64 -framework Foundation -o test.dylib test.m
// jtool --sign --inplace test.dylib

#include <dlfcn.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <mach/mach.h>
#include <mach-o/loader.h>
#include <mach/error.h>
#include <errno.h>
#include <stdlib.h>
#include <sys/sysctl.h>
#include <dlfcn.h>
#include <sys/mman.h>
#include <spawn.h>
#include <sys/stat.h>
#include <pthread.h>
#include <xpc/xpc.h>

#import <Foundation/Foundation.h>


//>* attribute((constructor(PRIORITY))) 和 attribute((destructor(PRIORITY)))
//
//```
//1、PRIORITY 是指执行的优先级，main 函数执行之前会执行 constructor，main 函数执行后会执行 destructor，+load 会比 constructor 执行的更早点，因为动态链接器加载 Mach-O 文件时会先加载每个类，需要 +load 调用 之后，然后才会调用所有的 constructor 方法。
//
//
//2、通过这个特性，可以做些比较好玩的事情，比如说类已经 load 完了，是不是可以在 constructor 中对想替换的类进行替换，而不用加在特定类的 +load 方法里。
//
//```

__attribute__ ((constructor))
static void ctor(void) {
	NSLog(@"Unsigned dylib!!");
}
