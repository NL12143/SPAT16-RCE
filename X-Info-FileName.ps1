
https://stackoverflow.com/questions/37793050/use-variable-in-filename-with-underscore

In a script I name an argument $out and then trying to use it in a filename like this:

c:/.../$out_date.txt

My problem is that $out_ is recognized as "not only $out". 
The file name MUST be like this. 
I already tried quotations or double quotations or + with no appropriate results.

Answer: 
"C:\folder\$($out)_date.txt"


Multiple options.

Use {} to qualify the variable name (as pointed out by @PetSerAl):
"C:\folder\${out}_date.txt"

Use the -f operator to expand $out before placing it in the string:
'C:\folder\{0}_date.txt' -f $out

Use the backtick (`) escape character to stop parsing of the variable name:
"C:\folder\$out`_date.txt"

Use a sub-expression ($()) to evaluate the variable:
"C:\folder\$($out)_date.txt"
