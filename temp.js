

function format(string) {
	return string.replace('\n', '').replace(/\n/g, '\r\n');
}

function ls(args) {
	term.writeln(Object.keys(files).join(' '));

}

function help(args) {
	term.writeln(`Commands:\n\rls\n\rcat\n\rhelp`);
}

function cat(args) {
	if (args.length !== 1) {
		term.writeln(`requires 1 argument, provided ${args.length}`)
		return;
	}
	if (!files[args[0]]) {
		term.writeln(`file not found: ${args[0]}`)
		return;
	}
	term.write(files[args[0]]);

}

function execute(command) {
	history.push(command);
	term.writeln('\r');
	tokens = command.split(' ');

	if (commands[tokens[0]]) {
		commands[tokens[0]](tokens.slice(1));
	} else {
		term.writeln(`shell: command not found: ${command}. Try 'help' to get started.`);
	}
}




const PROMPT = ` ~/$ `;
const PROMPT_LENGTH = PROMPT.length;
//const PROMPT_LENGTH = PROMPT.replace(/\u001b\[[\d;]+m/g, '').length;

const commands = {
	cat,
	ls,
	help,
};

const ABOUT = format(`
Currently learning: 
	- AWS Solutions Architect
	- Devops
	- Golang
My desktop setup:
	- NixOs unstable
	- Hyprland (customised)
	- Alacritty shell (zsh)
Interests: 
	- Music
	- Movies
	- The internet 
	 
`);

const CONTACT = format(`
Email:   michaelsavedra@gmail.com
Github:  https://github.com/savedra1
LinkdIn: https://www.linkedin.com/in/michael-savedra-3a4597144/
`);

const README = format(`
This website and my CV are hosted for free using Terraform 
and AWS with a full deployemt pipeline. To see the source 
code visit: https://github.com/savedra1/website
`);

const files = {
	'about.txt': ABOUT,
	'contact.txt': CONTACT,
	'README.md': README,
};


let term = new Terminal({
	cols: 80,
	rows: 20,
	fontSize: 15,
	cursorBlink: true,
	theme: {
		selection: '#FFF',
		foreground: '#FFF',
		cursor: '#FFF',
		background: '#4C566A',
	},
});

term.open(document.getElementById('terminal-container'));
term.write(`\n` + PROMPT)

term.registerLinkMatcher(/https:\/\/\w+\.[^\s]*/, (event, uri) => window.open(uri, '_blank'));
//term.open(document.querySelector('#terminal > .modeless-dialog'));
window.scrollTo(0, 0);

let history = [];
let pointer = 0;
let command = '';

term.onData(event => {
	switch (event) {
		case '\r': // Enter
			execute(command);
		case '\u0003': // Ctrl+C
			command = '';
			pointer = history.length;
			term.write(`\r\n${PROMPT}`);
			break;
		case '\u0010': // Ctrl+P
			pointer = Math.max(pointer - 1, 0);
			term.write('\x1b[2K');
			term.write(`\r${PROMPT}`);
			term.write(history[pointer] || '')
			command = history[pointer] || '';
			break;
		case '\u007F': // Backspace (DEL)
			if (term._core.buffer.x > PROMPT_LENGTH) {
				command = command.slice(0, -1);
				term.write('\b \b');
			}
			break;
		case '\f': // Ctrl+L
			term.clear();
			break;
		default: // Print all other characters for demo
			if (event.charCodeAt(0) < 30 || event.charCodeAt(0) > 128) {
				break;
			}
			command += event;
			term.write(event);
	}
});
    