#!python3
# zsh_help.py <file.zsh>
import argparse
import os
import re

class TermColor:
    green = '\033[1;32m'
    red   = '\033[1;31m'
    bold  = '\033[1m'
    reset = '\033[0m'

def printgreen (msg, end='\n'):
    print(TermColor.green + msg + TermColor.reset, end=end)

def printred (msg, end='\n'):
    print(TermColor.red + msg + TermColor.reset, end=end)

def printbold (msg, end='\n'):
    print(TermColor.bold + msg + TermColor.reset, end=end)

def trim_eol (lines):
    ret = []
    for line in lines:
        if len(line) == 0:
            ret += ['']
        elif line[-1] == '\n':
            ret += [line[:-1]]
        else:
            ret += [line]
    return ret

def parse_section (lines):
    ret = []
    section = []
    for line in lines:
        if len(line) and line[0] == '#':
            section += [line]
        elif len(section):
            ret += [section]
            section = []

    if len(section):
        ret += [section]

    return ret

cmdReg = re.compile(r'#>\s*([_a-zA-Z0-9\-]+)\s*:\s*([^\s][^{]+)')
def parse_command (section):
    if len(section) == 0:
        return None

    s = cmdReg.search(section[0])
    if s == None:
        return None
    matches = s.groups()
    if len(matches) != 2:
        return None

    cmd = matches[0]
    description = matches[1]
    details = []
    for line in section[1:]:
        if line[:2] == '# ':
            details += [line[2:]]
        elif line[0] == '#':
            details += [line[1:]]

    command = {
        'name': cmd,
        'description': description,
        'details': details,
        'content': lines
    }
    return command

def parse_commands (sections):
    cmds = {}
    for section in sections:
        cmd = parse_command(section)
        if cmd != None and not cmd['name'] in cmds:
            cmds[cmd['name']] = cmd
    return cmds

def show_all_commands (commands, space=' '):
    maxLen = 0
    tab = ''
    for name in commands:
        maxLen = max(maxLen, len(name))
    
    for name in commands:
        printgreen(f'{tab}{name}' + ' ' * (maxLen - len(name)), end='')
        print(space, end='')
        print(':', end='')
        print(commands[name]['description'])

def print_header (msg, end='\n'):
    printred(msg, end)

content_tab = '  '
def print_content (msg, end='\n'):
    print(f'{content_tab}{msg}', end=end)

header_keywords = ['USAGE', 'EXAMPLE', 'DESCRIPTION']
def parse_line (line):
    for keyword in header_keywords:
        if line.strip() == keyword:
            print_header(f'{line}')
            return
    print_content(line)

def show_command_help (commands, command):
    if not command in commands:
        print(f'No command: {command}')
        return

    info = commands[command]
    printgreen(f'{info["name"]}\n')
    print_header('DESCRIPTION')
    parse_line(f'{info["description"]}\n')
    for detail in info['details']:
        parse_line(detail)

parser = argparse.ArgumentParser(
    prog='zsh-help',
    description='Parse zsh scripts and show help messages'
)

parser.add_argument('filename')
parser.add_argument("command", nargs='?', default="")
parser.add_argument("-d", dest="directory")

args = parser.parse_args()

try:
    with open(args.filename) as f:
        lines = f.readlines()
except:
    print(f"Cannot open file: {args.filename}")
    os._exit(1)

if args.directory != None:
    files = []
    try:
        files = os.listdir(args.directory)
    except:
        print(f"No directory: {args.directory}")
        os._exit(1)

    for file in files:
        if file[0] == '.':
            continue

        if args.directory[-1] != '/':
            file = args.directory + '/' + file
        else:
            file = args.directory + file

        try:
            with open(file) as f:
                lines += f.readlines()
        except:
            print(f"Cannot open file: {file}")
            os._exit(1)

lines = trim_eol(lines)
sections = parse_section(lines)
commands = parse_commands(sections)
if args.command != '':
    show_command_help(commands, args.command)
else:
    show_all_commands(commands)
