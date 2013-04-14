@echo off


setlocal EnableDelayedExpansion
set "LA=^<"
set "RA=^>"
:: 2 blank lines required below set NLM !
set NLM=^


set NL=^^^%NLM%%NLM%^%NLM%%NLM%

SET FILECONTENTS=^
 1.) In the url of the item you want to use the buy button on, Put Javascript:startbuy^(^);!NL!^
 2.) Inspect element on buy button.!NL!^
 3.) Put the code at the bottom in it.!NL!^
 4.) You now no longer need to refresh once the item goes onsale.!NL!^
 !LA!input type=^"submit^" class=^"newPurchaseButton^" value=^"^"!RA!

ECHO %FILECONTENTS%
 
pause
 