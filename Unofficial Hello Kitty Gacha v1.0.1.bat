@echo off
setlocal enabledelayedexpansion

for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)

set points=0
set bcrates=0
set mcrates=0

set HKitems=0 0 0
set MMitems=0 0 0
set LTSitems=0 0 0
set Pitems=0 0 0
set Citems=0 0 0
set Gitems=0 0 0
set NameItems="Plushie" "Hotwheels Car" "Pasta"
goto :load

:: FUNCTIONS
:ColorText
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1
echo(
goto :eof

:: ------------------------------------------------------------------------

:: GAME


:work

for /l %%i in (1, 1, 5) do (
	echo Round %%i/5
    set /a "num=!random! %% 9000 + 1000"
	echo "Please type this to work: !num!"
	set /p playerwork=""
	
	if !playerwork! == !num! (
		echo Correct!
		set /a points = points+1
	) else (
		echo Incorrect!
	)
	
)
echo Work finished!
call :save
goto :loop

:save
(
echo %points%
echo %bcrates%
echo %mcrates%
echo %HKitems%
echo %MMitems%
echo %LTSitems%
echo %Pitems%
echo %Citems%
echo %Gitems%
)>"!filename!".lop

goto :eof


:load
set /p filename="Please enter the file name of your save data (without .lop) or enter N to start a new game. Make sure the game data is in the same folder as this file: "
if /i "%filename%"=="N" (
	set /p filename="Please enter the name for your new save. DO NOT INCLUDE ANY SPACES : "
	echo "">"!filename!".lop
) else (
	(
	set /p points=
	set /p bcrates=
	set /p mcrates=
	set /p HKitems=
	set /p MMitems=
	set /p LTSitems=
	set /p Pitems=
	set /p Citems=
	set /p Gitems=
	)<"!filename!".lop
)

goto :loop
:: ------------------------------------------------------------------------------------------
:: SHOP

:shop
echo Welcome to the shop!
goto :shoploop
	
:shoploop
echo(
echo "You have %points% point(s), %bcrates% BASIC crate(s), %mcrates% MEDIUM crate(s)"
echo Press: & echo [1] to purchase a BASIC crate (13 Points) & echo [2] to purchase a MEDIUM crate (24 Points) & echo [X] to go back
set /p choice=""
if /i "%choice%"=="1" (
    echo How many do you want to purchase?
	set /p quantity=""
    echo !quantity!|findstr /R "^[0-9]*$" >nul || (
        echo Invalid input. Please enter a whole number / positive number.
        goto :shoploop
    )
    if !quantity! LEQ 0 (
        echo Invalid input. Please enter a positive number.
        goto :shoploop
    )
	set /a price=!quantity!*13
	echo The total price is !price!. You currently have !points! points
	if !points! GEQ !price! (
		echo "Are you sure you want to purchase !quantity! BASIC crate(s)? [Y/N]"
		set /p confirmation=""
		if /i "!confirmation!"=="Y" (
		set /a points=!points!-price
		set /a bcrates=!bcrates!+quantity
		echo Sucsessfully purchased!
		call :save
		)
	) else (
		echo You cannot afford this!
	)
) else if /i "%choice%"=="2" (
    echo How many do you want to purchase?
	set /p quantity=""
    echo !quantity!|findstr /R "^[0-9]*$" >nul || (
        echo Invalid input. Please enter a whole number / positive number.
        goto :shoploop
    )
    if !quantity! LEQ 0 (
        echo Invalid input. Please enter a positive number.
        goto :shoploop
    )
	set /a price=!quantity!*24
	echo The total price is !price!. You currently have !points! points
	if !points! GEQ !price! (
		echo "Are you sure you want to purchase !quantity! MEDIUM crate(s)? [Y/N]"
		set /p confirmation=""
		if /i "!confirmation!"=="Y" (
		set /a points=!points!-price
		set /a mcrates=!mcrates!+quantity
		echo Sucsessfully purchased!
		call :save
		)
	) else (
		echo You cannot afford this!
	)
) else if /i "%choice%"=="X" (
	goto :loop
) else (
    echo That is not an option!
)

goto :shoploop



:: ------------------------------------------------------------------------------------------
:: Inventory
:inventory

echo Press: & echo [C] to enter the crate inventory & echo [G] to enter the gatcha inventory  &echo [S] to save & echo [X] to go back
set /p choice=""

if /i "%choice%"=="C" (
	echo Entering crate inventory...
	goto :crainventory
) else if /i "%choice%"=="G" (
	echo Entering gatcha inventory...
	goto :gatinventory
	echo %found%
) else if /i "%choice%"=="S" (
	echo Saving...
	call :save
) else if /i "%choice%"=="X" (
	goto :loop
) else (
    echo That is not an option!
)
goto :inventory

:gatinventory

echo Press: & echo [1] To view Hello Kitty items & echo [2] To view My Melody items &echo [3] To view Little Twin Stars items &echo [4] To view Pompompurin items &echo [5] To view Cinnamoroll items &echo [6] To view Gudetama &echo [7] To view all & echo [X] to go back
set /p choice=""
if /i "%choice%"=="1" (
	echo Hello Kitty Items
	call :list HKitems
) else if /i "%choice%"=="2" (
	echo My Melody Items
	call :list MMitems
) else if /i "%choice%"=="3" (
	echo Little Twin Stars Items
	call :list LTSitems
) else if /i "%choice%"=="4" (
	echo Pompompurin Items
	call :list Pitems
) else if /i "%choice%"=="5" (
	echo Cinnamoroll Items
	call :list Citems
) else if /i "%choice%"=="6" (
	echo Gudetama Items
	call :list Gitems
) else if /i "%choice%"=="7" (
	echo All Items
	echo Hello Kitty Items
	call :list HKitems
	echo My Melody Items
	call :list MMtems
	echo Little Twin Stars Items
	call :list LTStems
	echo Pompompurin Items
	call :list Pitems
	echo Cinnamoroll Items
	call :list Citems
	echo Gudetama Items
	call :list Gitems

) else if /i "%choice%"=="X" (
	goto :loop
) else (
    echo That is not an option!
)

goto :gatinventory

:list
for /l %%a in (1, 1, 3) do (
	set count=0
	for %%c in (%NameItems%) do (
		set /a count+=1 
		if %%a == !count! (
			set itemname=%%c
		)
	)
	set currentItem=%%b
	set count=0
	for %%c in (!%1!) do (
		set /a count+=1 
		if %%a == !count! (
			set found=%%c
		)
	)
    echo %%a. !itemname!: !found!    
)
goto :eof





:crainventory
echo "You have %bcrates% BASIC crate(s) and %mcrates% MEDIUM crate(s)"


echo Press: & echo [B] to open BASIC crates & echo [M] to open MEDIUM crates  &echo [S] to save & echo [X] to go back
set /p choice=""

if /i "%choice%"=="B" (
	echo How many BASIC crates do you want to open?
	set /p choice=""
    echo !choice!|findstr /R "^[0-9]*$" >nul || (
        echo Invalid input. Please enter a whole number / positive number.
        goto :crainventory
    )
    if !choice! LEQ 0 (
        echo Invalid input. Please enter a positive number.
        goto :crainventory
    )
    if !choice! GTR !bcrates! (
        echo Invalid input. Please enter a number less than how many BASIC crates you have!.
        goto :crainventory
    )
	for /l %%a in (1,1, !choice!) do (
		call :opencrate basic
	)
	echo ----
) else if /i "%choice%"=="M" (
	echo How many MEDIUM crates do you want to open?
	set /p choice=""
    echo !choice!|findstr /R "^[0-9]*$" >nul || (
        echo Invalid input. Please enter a whole number / positive number.
        goto :crainventory
    )
    if !choice! LEQ 0 (
        echo Invalid input. Please enter a positive number.
        goto :crainventory
    )
    if !choice! GTR !mcrates! (
        echo Invalid input. Please enter a number less than how many BASIC crates you have!.
        goto :crainventory
    )
	for /l %%a in (1,1, !choice!) do (
		call :opencrate medium
	)
	echo ----
	goto :crainventory
) else if /i "%choice%"=="S" (
	echo Saving...
	call :save
) else if /i "%choice%"=="X" (
	goto :inventory
) else (
    echo That is not an option!
)

goto :crainventory

:: ------------------------------------------------------------------------------------------
:: Crate Opening
:opencrate

echo ----
set /a "random_num=!random! %% 22"

if !random_num! lss 7 (
	set variant=HKitems
	call :colorText 0f "Hello Kitty Variant"
) else if !random_num! lss 12 (
	set variant=MMitems
	call :colorText 0d "My Melody Variant"
) else if !random_num! lss 16 (
	set variant=LTSitems
	call :colorText 0a "Little Twin Sisters Variant"
) else if !random_num! lss 19 (
	set variant=Pitems
	call :colorText 0c "Pompompurin Variant"
) else if !random_num! lss 21 (
	set variant=Citems
	call :colorText 0b "Cinnamoroll Varient"
) else (
	set variant=Gitems
	call :colorText 0e "Gudetama Variant"
)

if "%1"=="basic" (
	set /a bcrates-=1
    set /a "random_num2=!random! %% 101"

    :: Increase the corresponding number based on the random number
    if !random_num2! leq 50 (
        call :increase 1 !variant!
		echo Plushie
    ) else if !random_num2! leq 80 (
        call :increase 2 !variant!
		echo Hotwheels Car
    ) else if !random_num2! leq 100 (
        call :increase 3 !variant!
		echo Pasta
    )

)else if "%1"=="medium" (
	set /a mcrates-=1
    set /a "random_num2=!random! %% 101"

    :: Increase the corresponding number based on the random number
    if !random_num2! leq 30 (
        call :increase 1 !variant!
		echo Plushie
    ) else if !random_num2! leq 60 (
        call :increase 2 !variant!
		echo Hotwheels Car
    ) else if !random_num2! leq 100 (
        call :increase 3 !variant!
		echo Pasta
    )
)	
call :save

goto :eof

:increase
set count=0
set "list-tmp="
for %%a in (!%2!) do (
    set /a count+=1
    if !count!==%1 (
        set /a "value=%%a + 1"
        set "list-tmp=!list-tmp! !value!"
    ) else (
        set "list-tmp=!list-tmp! %%a"
    )
)
set %2=!list-tmp!
goto :eof




:: ------------------------------------------------------------------------------------------
:: Loop

:loop
echo You have %points% point(s)
echo Press: & echo [W] to work & echo [B] to enter the shop  &echo [S] to save & echo [E] to open inventory & echo [X] to exit
set /p choice=""
if /i "%choice%"=="W" (
    echo Work Started...
	goto :work
) else if /i "%choice%"=="B" (
	echo Entering the shop...
	goto :shop
) else if /i "%choice%"=="E" (
	echo Entering inventory...
	goto :inventory
) else if /i "%choice%"=="S" (
	echo Saving...
	call :save
) else if /i "%choice%"=="X" (
	call :save
	exit /b
) else (
    echo That is not an option!
)
goto :loop

endlocal