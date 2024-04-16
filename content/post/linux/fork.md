# linux fork() 方法
fork 创建一个新进程，这个系统调用会复制当前的进程，在进程表中创建一个新的表项，新表项中的许多属性与当前进程是相同的。新进程几乎与原进程一模一样，执行的代码也完全相同。
但新进程有自己的数据空间，环境和文件描述符。
```c
#include <sys/types>
#include <unistd.h>

pid_t fork(void);
```
![image](https://github.com/nreckle/blog/assets/8310017/904ed8bb-7c92-4e2e-b73a-0922808745ad)

示例：
```c
#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

int main()
{
    pid_t pid;
    char *message;
    int n;

    printf("fork program starting\n");
    pid = fork();
    
    switch(pid)
    {
    case -1:
	perror("fork failed");
	exit(1);
    case 0:
	message = "This is the child";
	n = 5;
	break;
    default:
	message = "This is the parent";
	n = 3;
	break;
    }

    for(; n > 0; n--)
    {
        puts(message);
	sleep(1);
    }
    exit(0);
}
```

执行过程
```shell
gcc fork.c -o fork
./fork
```

运行结果
```
fork program starting
This is the parent
This is the child
This is the parent
This is the child
This is the parent
This is the child
This is the child
```
