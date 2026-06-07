# heap2win — GYUCTF 2026

**Category:** Pwn

**Source:** you can download the files from **https://github.com/sajjadium/ctf-archives/tree/main/ctfs/BYUCTF/2026/pwn/heap2win**


**Description:** the idea of the challenge is to overwrite vtable of an object with anthor vtable 

**Tools Used** : gdb-gef , ghidra , pwntools 

**the following will be detailed wrietup for the challenge from checksec command to full dynamic analysis**
****

## **static analysis**

After downloaded the file , I explored the file by using **file** , **checksec** commands 



<img width="1856" height="382" alt="image" src="https://github.com/user-attachments/assets/ab6fdf5b-c073-4958-a440-27d86e9b9ffb" />
