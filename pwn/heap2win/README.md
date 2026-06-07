# heap2win — GYUCTF 2026

**Category:** Pwn

**Source:** you can download the files from **https://github.com/sajjadium/ctf-archives/tree/main/ctfs/BYUCTF/2026/pwn/heap2win**


**Description:** the idea of the challenge is to overwrite vtable of an object with anthor vtable 

**Tools Used** : gdb-gef , ghidra , pwntools  , c++flit

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




****

## **Dynamic analysis:**

after running it normally and try to fuzz the **customButton** variable , it crashes  but not cause of corrupting vtable value , but cause we corrupted the top chunk 

<img width="870" height="452" alt="image" src="https://github.com/user-attachments/assets/9d39540d-2b84-4a58-86b5-d84b736abd1c" />

let us go to gdb and see where is our variable stored and the top chunk 
we can do three breakpoints (since we have symbols :) ) 

<img width="815" height="337" alt="image" src="https://github.com/user-attachments/assets/94fdf0f1-87ae-42c5-836d-4669a01209d9" />

let us go for making **customButton** first 

and when we break in **makeButton** we can step in until we reach the **customButton** constructor or just break on **CustomButton** too

<img width="1920" height="1020" alt="image" src="https://github.com/user-attachments/assets/36391198-65ca-45b5-869e-b8343b1b81be" />


after we reach **customButton** constructor , we now see the same instruction that we saw in ghidra above .

so we can get the location of **name** by **RSI** 
<img width="1920" height="1020" alt="image" src="https://github.com/user-attachments/assets/659882f4-0926-4809-b5a7-ba4daa1d9d36" />


we can see start of **name** variable is in (0x419898) 


<img width="1920" height="1020" alt="image" src="https://github.com/user-attachments/assets/813d5acd-8d30-4984-b742-179f511b9ce0" />


this is location of our data we provided (AAA...) and if we examine our data - 8 bytes we will see an address of the vtable of **customButton** object class as that showed in the image , also by examining the location of top chunk , it is directly after the our data , so we should expand the top chunk 



****


## **exploit senario**

after several attempts to expand topchunk and to do multiple button , notice that when : 

1) creating HypeButton
2) Creating CustomButton#1 (AAAAAA...)
3) Creating CustomeButton#2 (BBBBB....)

<img width="1920" height="1020" alt="image" src="https://github.com/user-attachments/assets/e3efff1d-139d-46ed-9da6-368c43b6f5a3" />


notice that , **CustomButton#2** is locating before **CustomButton#1** so we can overflow it  from (0x4198b8) 24 bytes + address_of_winner_class_vtable 

then we choose to push **CustomButton#1** to call address_of_winner_class_vtable

and we have the shell : ) 

<img width="1920" height="1020" alt="image" src="https://github.com/user-attachments/assets/9a6289e2-3953-41c1-937a-0aa43b282dca" />

****

Thanks for reading ,

**0xbishop from Rooted Minds Team** 







