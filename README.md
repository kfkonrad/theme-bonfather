## bonfather fish theme

Clean git theme with homey feel and git-centric features.

![screenshot](http://i.imgur.com/mh7a39d.png)

#### Prompt structure:

* Left-hand side:
	* user@host:
	* full path
	* git branch with state info (if applicable)

* Right-hand side:
	* last error code (if applicable)

#### Optional settings

You can set the following git-related options with a universal variable:
- `__fish_git_prompt_showdirtystate`: Should the git status be highlightet at all? Defaults to `yes`
- `__fish_git_prompt_char_dirtystate`: How will a 'dirty' git state be marked? Defaults to `±`
- `__fish_git_prompt_char_cleanstate`: How will a 'clean' git state be marked? Defaults to empty string
- `__fish_git_prompt_char_addedstate`: How will a 'added' git state be marked? Defaults to `•`

You can also override the character last printed by bonfather.
- `__fish_prompt_nicepromptchar`: Defaults to `#` for root and to `$` for any other user.

#### Credits:

Colors and git functions taken from [amio](https://github.com/amio)'s
[edan](https://github.com/bpinto/oh-my-fish/tree/master/themes/edan) theme.
