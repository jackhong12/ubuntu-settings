
# zsh_help.py <file.zsh>
import argparse
import os
import re

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
        print(f'{tab}{name}' + ' ' * (maxLen - len(name)), end='')
        print(space, end='')
        print(':', end='')
        print(commands[name]['description'])

def show_command_help (commands, command):
    if not command in commands:
        print(f'No command: {command}')
        return

    tab = ''
    info = commands[command]
    print(f'{info["name"]}\n')
    print(f'{tab}{info["description"]}\n')
    for detail in info['details']:
        print(f'{tab}{detail}')

parser = argparse.ArgumentParser(
    prog='zsh-help',
    description='Parse zsh scripts and show help messages'
)

parser.add_argument('filename')
parser.add_argument("command", nargs='?', default="")

args = parser.parse_args()

try:
    with open(args.filename) as f:
        lines = f.readlines()
except:
    print(f"Cannot open file: {args.filename}")
    os._exit(1)

lines = trim_eol(lines)
sections = parse_section(lines)
commands = parse_commands(sections)
if args.command != '':
    show_command_help(commands, args.command)
else:
    show_all_commands(commands)
