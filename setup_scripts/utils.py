from glob import glob

def write_concat_file(outfilename, infilenames):
    with open(outfilename, 'w') as outfile:
        for fname in infilenames:
            with open(fname) as infile:
                for line in infile:
                    outfile.write(line)



def file_insert_line_at_pattern (filename, pattern, text_insert, replace_line=False):
    read_file = open(filename, 'r').readlines()
    with open(filename,'w') as write_file:
        for line in read_file:
            write_file.write(line)
            if pattern in line:
                if replace_line:
                    write_file.write(text_insert + "\n") 
                else:
                    write_file.write("\n") 
                    write_file.write(text_insert + "\n")