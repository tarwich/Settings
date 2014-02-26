#!/usr/bin/env python

import argparse, re, select, sys

# Main isn't sorted with othe functions
def main():
    # Make an argument parser to get optional command line arguments
    parser = argparse.ArgumentParser(description='Align columns from input by delimiter')
    # Add --file argument
    parser.add_argument('--file', '-f', help='Read input from file instead of stdin')
    # Add --line argument
    parser.add_argument('--lines', '-l', help='Range of lines to affect in the format A,B', nargs=1, default="0,0")
    # Add --dry-run argument
    parser.add_argument('--dry-run', '-n', help="Don't write to the output file", action="store_true")
    # Add any trailing arguments to argv
    parser.add_argument(dest='argv', nargs='*')
    # Perform the argument parsing
    options = parser.parse_args()
    # Set the scope of 'text'
    text = ""
    # If we were given a file, then read it
    if(options.file): 
        # Read all the text in the file
        with open(options.file) as f: text = f.read()
    else:
        # If input is piped through STDIN
        if(select.select([sys.stdin], [], [], 0))[0]:
            # Read all STDIN
            text = sys.stdin.read()
        else:
            print("ERROR: Need input")
    # Split the buffer into lines
    lines = str.split(text, "\n");    
    # Get the start and end lines
    start_line, end_line = [int(n) for n in options.lines[0].split(",")]
    # End line should default to end of file
    if not end_line: end_line = len(lines)
    # Align the lines we're supposed to align
    lines[start_line-1:end_line] = align(lines[start_line-1:end_line], options)
    # Merge the lines back into text
    text = str.join("\n", lines)
    # Write to the original file
    if options.dry_run: 
        print(text)
    else:
        with open(options.file, "w") as f: f.write(text)

def align(lines, options={}):
    # Parse the format expression from the command line
    [regex, columns, first_only] = input_parser(str.join(' ', options.argv))
    # Check to see if the regex is already a regex
    if(regex[0] == regex[-1] == '/'):
        # Strip the '/' symbols
        regex = regex[1:-1]
    # Not a regex, so escape the expression so it will be regex-safe
    else: regex = re.escape(regex)
    
    # Add padding to the regex to consume errant spaces
    regex = r'\s*' + regex + r'\s*'
    # Initialize to true for first pass
    change_made = True    
    # Column from last pass
    start_column = 0
    # Initialize the completed lines to an empty array with capax for n lines
    completed_lines = [""] * len(lines)
    # The column format we're currently on
    format_index = 0
    
    while(change_made):
        # Where we will align to
        new_column = 0
        next_column = start_column
        
        # Get the position of the new column
        for line in lines:
            # Execute the regex
            match = re.search(regex, line);
            # Calculate the new column
            if match: new_column = max(new_column, match.start())
        
        # If nothing found, then stop
        if new_column == 0: break
        
        # Align to the new column
        for i,line in enumerate(lines):
            # Execute the regex
            match = re.search(regex, line);
            if match:
                # Get the column format
                align1, padding1 = columns[format_index]
                # Increment the format index and wrap
                format_index = (format_index + 1) % len(columns)
                # Get the column format
                align2, padding2 = columns[format_index]
                # Increment the format index and wrap
                format_index = (format_index + 1) % len(columns)
                # Format the text for the column
                new_text = (" "*padding1) + (" "*(new_column-match.start())) + re.sub(r'\s*', '', match.group()) + (" "*padding2)
                # Format this column and add to the finished lines
                completed_lines[i] += line[0:match.start()] + new_text
                # Trim this column from the todo lines
                lines[i] = line[match.end():]
                # Calculate where we'll start on the next pass
                next_column = max(match.start() + len(new_text) + 1, next_column)
                # print(line)
        start_column = next_column
    # Add any remaining todo lines to the completed lines
    for i,line in enumerate(lines): completed_lines[i] += line
    # Output the result
    return completed_lines


#
# Function taken from randy3k: https://github.com/randy3k/AlignTab/
#
def input_parser(user_input):
    m = re.match(r"(.+)/([lcr*()0-9]*)(f[0-9]*)?", user_input)

    if m and (m.group(2) or m.group(3)):
        regex = m.group(1)
        option = m.group(2)
        f = m.group(3)
    else:
        # print("No options!")
        return [user_input, [['l', 1]], 0]

    try:
        # for option
        rParan = re.compile(r"\(([^())]*)\)\*([0-9]+)")
        while True:
            if not rParan.search(option): break
            for r in rParan.finditer(option):
                option = option.replace(r.group(0), r.group(1)*int(r.group(2)),1)

        for r in re.finditer(r"([lcr][0-9]*)\*([0-9]+)", option):
            option = option.replace(r.group(0), r.group(1)*int(r.group(2)),1)

        option = re.findall(r"[lcr][0-9]*", option)
        option = list(map(lambda x: [x[0], 1] if len(x)==1 else [x[0], int(x[1:])], option))
        option = option if option else [['l', 1]]

        # for f
        f = 0 if not f else 1 if len(f)==1 else int(f[1:])
    except:
        [regex, option ,f]= [user_input, [['l', 1]], 0]

    return [regex, option ,f]

main()
