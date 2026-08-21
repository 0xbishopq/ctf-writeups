set disassembly-flavor intel

define show
  if $argc == 0
    x/10i $pc
  else
    x/$arg0i $pc
  end
end

define stack
    if $argc == 0
      x/10i $rsp
    else
     x/$arg0i $rsp
  end
end

document show
document stack
Show n lines of disassembly starting at the current PC.
Usage: show [n]  (defaults to 10 if n is omitted)
end