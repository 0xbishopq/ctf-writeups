<img width="1547" height="706" alt="image" src="https://github.com/user-attachments/assets/09fc1da3-143a-475c-905f-de13d75644d3" /># heap2win — GYUCTF 2026

**Category:** Pwn

**Source:** you can download the files from **https://github.com/sajjadium/ctf-archives/tree/main/ctfs/BYUCTF/2026/pwn/heap2win**


**Description:** the idea of the challenge is to overwrite vtable of an object with anthor vtable 

**Tools Used** : gdb-gef , ghidra , pwntools 

**the following will be detailed wrietup for the challenge from checksec command to full dynamic analysis**
****

## **static analysis**

After downloaded the file , I explored the file by using **file** , **checksec** commands 



<img width="1856" height="382" alt="image" src="https://github.com/user-attachments/assets/ab6fdf5b-c073-4958-a440-27d86e9b9ffb" />

the program protection is simple : no canary , and no PIE so we will not need any kind of leak to do .
the program also is not stripped so the debugging process will be easier 

since the source code is provided , we can trace it to spot the vulnerability before open the program in ghidra

<img width="1547" height="706" alt="image" src="https://github.com/user-attachments/assets/4cd7f74f-7297-48f7-9200-3cee9269c5cc" />

from the image , we can see that the vuln is buffer overflow (name size is 0x10 ~=16 and no size check in scanf function )
now we know the vuln is buffer overflow but we need to know (name variable) is it saved in heap or the stack to detect if it stack overflow or heap oveflow .
<img width="1920" height="1020" alt="image" src="https://github.com/user-attachments/assets/db1d227e-c236-461a-bed6-f20f96032685" />

from the ghidra view we can detect that the name variable is saved in the heap , so this is going to be heap overflow :) , and notice that **name** variable is in **this+0x8** cause first 8 bytes are for vtables pointer of the object class 

good note to make use of during debugging : can reach name variable in heap by examining **RSI**





