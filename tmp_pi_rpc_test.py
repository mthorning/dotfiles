import json, subprocess, textwrap
msg = 'change hello to goodbye\n\nContext:\n' + textwrap.dedent('''You are running inside the pi.nvim Neovim plugin. The user has sent a request and will not be able to reply back. You must complete the task immediately without asking any questions or requesting clarification. Take action now and do what was asked.

File: /Users/mthorning/dotfiles/tmp-pi-apply-test.txt

Filetype: text

Selected lines: 1-1

Selected content:
```
hello world
```

Nearby context (1-1):
```
hello world
```
''')
payload = json.dumps({'type': 'prompt', 'message': msg}) + '\n'
for extra in ([], ['--no-extensions'], ['--no-skills'], ['--no-extensions', '--no-skills']):
    print('===== TEST', ' '.join(extra) or '(default)', '=====')
    proc = subprocess.run(['pi', '--mode', 'rpc', '--no-session', *extra], input=payload, text=True, capture_output=True, timeout=120)
    print('exit', proc.returncode)
    print(proc.stdout)
    print('stderr:', proc.stderr)
