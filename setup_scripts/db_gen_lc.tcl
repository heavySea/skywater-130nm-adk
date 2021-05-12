set lib_name [file rootname [file tail $input_lib]]
# .fixed is still included in the name, fix that quickly
set lib_name [lindex [split $lib_name .] 0]
echo "Reading lib: $lib_name"
read_lib $input_lib
echo "Writing DB: ${output_db}"
set ret_code [write_lib $lib_name -output ${output_db}]
if { $ret_code == 1 } {
    exit 0
} {
    exit 1
} 
exit